%% FIR filter design example
addpath ../SIGNALS
%Sampling frequency
fs = 2048 ;%Hz;

%Number of samples in impulse input sequence
nSamples = 256;

%Sampling times
timeVec = (0:(nSamples-1))/fs;
 
%Filter order
fN = 30;
 
%Frequency values at which to specify
%the target transfer function
f = 0:2:1024;
 
%Target transfer function
targetTf = f.*(1024-f);
 
%Design the digital filter
b = fir2(fN,f/(fs/2),targetTf);
 
%Get the impulse response by letting the filter act on an impulse sequence
impVec = zeros(1,nSamples);
impVec(floor(nSamples/2))=1; %Impulse in the middle
impResp = fftfilt(b,impVec);
 
%Get the transfer function: FFT of impulse response
designTf = fft(impResp);

%Plots
figure;
hold on;
plot(f,targetTf);
kNyq = floor(nSamples/2)+1;
posFreq = (0:(kNyq-1))/(nSamples/fs);
plot(posFreq,abs(designTf(1:kNyq)));

figure;
plot(timeVec,impResp);

%% Application of the designed filter
% Signal parameters
a1=10;
a2=3;
a3=3;
A = 10;
timeVec2 = (0:2047)/fs;
sigVec = crcbgenqcsig(timeVec2,A,[a1,a2,a3]);
figure;
plot(timeVec2,sigVec);
hold on;
filtSigVec = fftfilt(b,sigVec);
axis tight;
plot(timeVec2,filtSigVec*max(sigVec)/max(filtSigVec));
xlabel('Time (sec)');
title(['Filter order ', num2str(fN)]);