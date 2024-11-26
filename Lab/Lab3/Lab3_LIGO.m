% 读取 txt 文件,记得手动补充部分缺失数据
filename = 'iLIGOSensitivity.txt';
data = load(filename);

fltrOrdr = 500;
% 分别赋值给变量 t 和 data
f = data(:, 1);
T = data(:, 2);
plot(f,log(T))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%将频率之外的sqrt（Sn）平滑处理
for i=1: length(T)
    if f(i)>50
        T(1:i)=T(i);
        break;
    end
end

for i=1: length(T)
    if f(i)>700
        T(i:end)=T(i);
        break;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Sampling frequency for noise realization
sampFreq = max(f)*2; %Hz
%Number of samples to generate
nSamples = 16384;
%Time samples
timeVec = (0:(nSamples-1))/sampFreq;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c = fir2(fltrOrdr,f/(sampFreq/2),T);
inNoise = randn(1,nSamples);
outNoise = sqrt(sampFreq)*fftfilt(c,inNoise);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
plot(timeVec,outNoise)
title('Noise Realization')
xlabel('Time(s)')
ylabel('Noise Amplitude')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[pxx, f] = pwelch(outNoise, [], [], [], sampFreq);
log_pxx = 10*log(pxx/2);
% 绘制功率谱密度
figure;
plot(f, log_pxx);
title('Noise PSD');
xlabel('Frequency (Hz)');
ylabel('10*Log_{10} PSD');
grid on;
hold off;
