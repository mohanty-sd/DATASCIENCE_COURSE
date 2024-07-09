%% Plot the quadratic chirp signal 绘制二次啁啾信号
% Signal parameters 参数
a1=10;
a2=3;
a3=3;
A = 10;
% Instantaneous frequency after 1 sec is 1秒后的瞬时频率
maxFreq = a1+2*a2+3*a3;
%Nyqust frequency guess: 2 * max. instantaneous frequency 奈奎斯特频率猜测2*最大，瞬时频率
nyqFreq = 2*maxFreq;
%Sampling frequency 采样频率
samplFreq = 5*nyqFreq; 
samplIntrvl = 1/samplFreq;
% Time samples 时间样本：定义了一个时间向量 timeVec，用于表示从 0 到 1.0 的一系列时间样本。每个样本间隔为samplIntrvl
timeVec = 0:samplIntrvl:1.0;
% Number of samples 样本数
nSamples = length(timeVec);

% Generate the signal 生成信号
sigVec = crcbgenqcsig(timeVec,A,[a1,a2,a3]);
%Plot the signal 信号绘图
figure;
plot(timeVec,sigVec,'Marker','.','MarkerSize',24);
xlabel('Time (sec)');
title('Sampled signal');

%Plot the periodogram 绘制周期图
%--------------
%Length of data 数据长度
dataLen = timeVec(end)-timeVec(1);
%DFT sample corresponding to Nyquist frequency 对应奈奎斯特频率的DFT样本
kNyq = floor(nSamples/2)+1;
% Positive Fourier frequencies 正傅里叶频率
posFreq = (0:(kNyq-1))*(1/dataLen);
% FFT of signal 信号的FFT
fftSig = fft(sigVec);
% Discard negative frequencies 丢弃负频率
fftSig = fftSig(1:kNyq);
%Plot periodogram 绘制周期图
figure;
plot(posFreq,abs(fftSig));
xlabel('Frequency (Hz)');
ylabel('|FFT|');
title('Periodogram');

%Plot a spectrogram 绘制谱图
%----------------
winLen = 0.2;%sec
ovrlp = 0.1;%sec
%Convert to integer number of samples 转换为整体样本数
winLenSmpls = floor(winLen*samplFreq);
ovrlpSmpls = floor(ovrlp*samplFreq);
[S,F,T]=spectrogram(sigVec,winLenSmpls,ovrlpSmpls,[],samplFreq);
figure;
imagesc(T,F,abs(S)); axis xy;
xlabel('Time (sec)');
ylabel('Frequency (Hz)');

%% Plot the quadratic chirp signal 绘制正弦信号
% 参数
A1 = 10;
f0 = 1;
c0 = 0;

% Sampling frequency 采样频率
samplFreq2 = 20 * pi;
samplIntrvl2 = 1 / samplFreq2;

% Time samples 时间样本：定义了一个时间向量 timeVec，用于表示从 0 到 1.0 的一系列时间样本。每个样本间隔为 samplIntrvl2
timeVec2 = 0:samplIntrvl2:1.0;

% Number of samples 样本数
nSamples2 = length(timeVec2);

% Generate the signal 生成信号
sigVec2 = crsin(timeVec2, A1, f0, c0);

% Plot the signal 信号绘图
figure;
plot(timeVec2, sigVec2, 'Marker', '.', 'MarkerSize', 24);
xlabel('Time (sec)');
title('Sampled signal');

%Plot the periodogram 绘制周期图
%--------------
%Length of data 数据长度
dataLen2 = timeVec2(end)-timeVec2(1);
%DFT sample corresponding to Nyquist frequency 对应奈奎斯特频率的DFT样本
kNyq2 = floor(nSamples2/2)+1;
% Positive Fourier frequencies 正傅里叶频率
posFreq2 = (0:(kNyq2-1))*(1/dataLen2);
% FFT of signal 信号的FFT
fftSig = fft(sigVec2);
% Discard negative frequencies 丢弃负频率
fftSig = fftSig(1:kNyq2);
%Plot periodogram 绘制周期图
figure;
plot(posFreq2,abs(fftSig));
xlabel('Frequency (Hz)');
ylabel('|FFT|');
title('Periodogram');

%Plot a spectrogram 绘制谱图
%----------------
winLen = 0.2;%sec
ovrlp = 0.1;%sec
%Convert to integer number of samples 转换为整体样本数
winLenSmpls = floor(winLen*samplFreq2);
ovrlpSmpls = floor(ovrlp*samplFreq2);
[S,F,T]=spectrogram(sigVec2,winLenSmpls,ovrlpSmpls,[],samplFreq2);
figure;
imagesc(T,F,abs(S)); axis xy;
xlabel('Time (sec)');
ylabel('Frequency (Hz)');