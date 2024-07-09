%% Plot the quadratic chirp signal ���ƶ�������ź�
% Signal parameters ����
a1=10;
a2=3;
a3=3;
A = 10;
% Instantaneous frequency after 1 sec is 1����˲ʱƵ��
maxFreq = a1+2*a2+3*a3;
%Nyqust frequency guess: 2 * max. instantaneous frequency �ο�˹��Ƶ�ʲ²�2*���˲ʱƵ��
nyqFreq = 2*maxFreq;
%Sampling frequency ����Ƶ��
samplFreq = 5*nyqFreq; 
samplIntrvl = 1/samplFreq;
% Time samples ʱ��������������һ��ʱ������ timeVec�����ڱ�ʾ�� 0 �� 1.0 ��һϵ��ʱ��������ÿ���������ΪsamplIntrvl
timeVec = 0:samplIntrvl:1.0;
% Number of samples ������
nSamples = length(timeVec);

% Generate the signal �����ź�
sigVec = crcbgenqcsig(timeVec,A,[a1,a2,a3]);
%Plot the signal �źŻ�ͼ
figure;
plot(timeVec,sigVec,'Marker','.','MarkerSize',24);
xlabel('Time (sec)');
title('Sampled signal');

%Plot the periodogram ��������ͼ
%--------------
%Length of data ���ݳ���
dataLen = timeVec(end)-timeVec(1);
%DFT sample corresponding to Nyquist frequency ��Ӧ�ο�˹��Ƶ�ʵ�DFT����
kNyq = floor(nSamples/2)+1;
% Positive Fourier frequencies ������ҶƵ��
posFreq = (0:(kNyq-1))*(1/dataLen);
% FFT of signal �źŵ�FFT
fftSig = fft(sigVec);
% Discard negative frequencies ������Ƶ��
fftSig = fftSig(1:kNyq);
%Plot periodogram ��������ͼ
figure;
plot(posFreq,abs(fftSig));
xlabel('Frequency (Hz)');
ylabel('|FFT|');
title('Periodogram');

%Plot a spectrogram ������ͼ
%----------------
winLen = 0.2;%sec
ovrlp = 0.1;%sec
%Convert to integer number of samples ת��Ϊ����������
winLenSmpls = floor(winLen*samplFreq);
ovrlpSmpls = floor(ovrlp*samplFreq);
[S,F,T]=spectrogram(sigVec,winLenSmpls,ovrlpSmpls,[],samplFreq);
figure;
imagesc(T,F,abs(S)); axis xy;
xlabel('Time (sec)');
ylabel('Frequency (Hz)');

%% Plot the quadratic chirp signal ���������ź�
% ����
A1 = 10;
f0 = 1;
c0 = 0;

% Sampling frequency ����Ƶ��
samplFreq2 = 20 * pi;
samplIntrvl2 = 1 / samplFreq2;

% Time samples ʱ��������������һ��ʱ������ timeVec�����ڱ�ʾ�� 0 �� 1.0 ��һϵ��ʱ��������ÿ���������Ϊ samplIntrvl2
timeVec2 = 0:samplIntrvl2:1.0;

% Number of samples ������
nSamples2 = length(timeVec2);

% Generate the signal �����ź�
sigVec2 = crsin(timeVec2, A1, f0, c0);

% Plot the signal �źŻ�ͼ
figure;
plot(timeVec2, sigVec2, 'Marker', '.', 'MarkerSize', 24);
xlabel('Time (sec)');
title('Sampled signal');

%Plot the periodogram ��������ͼ
%--------------
%Length of data ���ݳ���
dataLen2 = timeVec2(end)-timeVec2(1);
%DFT sample corresponding to Nyquist frequency ��Ӧ�ο�˹��Ƶ�ʵ�DFT����
kNyq2 = floor(nSamples2/2)+1;
% Positive Fourier frequencies ������ҶƵ��
posFreq2 = (0:(kNyq2-1))*(1/dataLen2);
% FFT of signal �źŵ�FFT
fftSig = fft(sigVec2);
% Discard negative frequencies ������Ƶ��
fftSig = fftSig(1:kNyq2);
%Plot periodogram ��������ͼ
figure;
plot(posFreq2,abs(fftSig));
xlabel('Frequency (Hz)');
ylabel('|FFT|');
title('Periodogram');

%Plot a spectrogram ������ͼ
%----------------
winLen = 0.2;%sec
ovrlp = 0.1;%sec
%Convert to integer number of samples ת��Ϊ����������
winLenSmpls = floor(winLen*samplFreq2);
ovrlpSmpls = floor(ovrlp*samplFreq2);
[S,F,T]=spectrogram(sigVec2,winLenSmpls,ovrlpSmpls,[],samplFreq2);
figure;
imagesc(T,F,abs(S)); axis xy;
xlabel('Time (sec)');
ylabel('Frequency (Hz)');