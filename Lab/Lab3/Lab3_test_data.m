% 读取 txt 文件
filename = 'testData.txt';
data = load(filename);

% 分别赋值给变量 t 和 data
t = data(:, 1);
data_values = data(:, 2);
nSamples = length(t);
% 作图
figure;
plot(t, data_values);
xlabel('time/s');
ylabel('data');
title('Test Data');
grid on;
hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% 提取 t < 5 的数据部分
noise_data = data(t < 5);
% 设置采样频率（假设你的数据采样频率为 fs）
fs = 1024;  % Test data 是1024

fltrOrdr = 500;
% 使用 pwelch 函数计算噪声功率谱密度
[pxx, f] = pwelch(noise_data, [], [], [], fs);
log_pxx = 10*log(pxx/2);
% 绘制功率谱密度
figure;
plot(f, log_pxx);
% plot(f, pxx);
title('Noise PSD (t<5s)');
xlabel('频率 (Hz)');
ylabel('10*Log_{10} PSD');
grid on;
hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
sdf
Whittened= Lab3_Whitten(nSamples,[f,pxx],fltrOrdr,fs);


figure;
plot(t, data_values);
xlabel('Time(s)');
ylabel('Ampliltude');
hold on;
plot(t, 10*log(Whittened));
legend('Original','Whittened');
grid on;



