%% Calculate GLRT for Quadratic chirp signal 
% Generalized Likelihood ratio test (GLRT) for a quadratic chirp when only
% the amplitude is unknown.

%%
% We will reuse codes that have already been written.
% Path to folder containing signal and noise generation codes.
addpath ../SIGNALS
addpath ../NOISE


%% Parameters for data realization
% Number of samples and sampling frequency.
nSamples = 2048;
sampFreq = 1024;
timeVec = (0:(nSamples-1))/sampFreq;

%% Supply PSD values
% This is the noise psd we will use.
noisePSD = @(f) (f>=100 & f<=300).*(f-100).*(300-f)/10000 + 1;
dataLen = nSamples/sampFreq;
kNyq = floor(nSamples/2)+1;
posFreq = (0:(kNyq-1))*(1/dataLen);
psdPosFreq = noisePSD(posFreq);

%% Generate  data realization
% Noise + SNR=10 signal. 
a1=9.5;
a2=2.8;
a3=3.2;
A=10;
noiseVec = statgaussnoisegen(nSamples,[posFreq(:),psdPosFreq(:)],100,sampFreq);
sig4data = crcbgenqcsig(timeVec,A,[a1,a2,a3]);
% Signal normalized to SNR=10
[sig4data,~]=normsig4psd(sig4data,sampFreq,psdPosFreq,10);
dataVec = noiseVec+sig4data;

figure;
plot(timeVec,dataVec);
hold on;
plot(timeVec,sig4data);
xlabel('Time (sec)')
ylabel('Data');
title('Data realization for calculation of LR');

figure;
kNyq = floor(nSamples/2)+1;
dataLen = nSamples/sampFreq;
posFreq = (0:(kNyq-1))*(1/dataLen);
datFFT = abs(fft(dataVec));
sigFFT = abs(fft(sig4data));
plot(posFreq,datFFT(1:kNyq));
hold on;
plot(posFreq,sigFFT(1:kNyq));
xlabel('Frequency (Hz)');
ylabel('Periodogram');

figure;
[S,F,T] = spectrogram(dataVec,64,60,[],sampFreq);
imagesc(T,F,abs(S)); axis xy;
xlabel('Time (sec)')
ylabel('Frequency (Hz)');

%% Compute GLRT
%Generate the unit norm signal (i.e., template). Here, the value used for
%'A' does not matter because we are going to normalize the signal anyway.
%Note: the GLRT here is for the unknown amplitude case, that is all other
%signal parameters are known
sigVec = crcbgenqcsig(timeVec,A,[a1,a2,a3]);
%We do not need the normalization factor, just the  template vector
[templateVec,~] = normsig4psd(sigVec,sampFreq,psdPosFreq,1);
% Calculate inner product of data with template
llr = innerprodpsd(dataVec,templateVec,sampFreq,psdPosFreq);
%GLRT is its square
llr = llr^2;
disp(llr);

