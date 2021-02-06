%% Spectrogram demo
addpath ../SIGNALS
sampFreq = 1024;
nSamples = 2048;
timeVec = (0:(nSamples-1))/sampFreq;

%% Quadratic chirp signal
% Signal parameters
a1=10;
a2=3;
a3=10;
A = 10;

%%
% Generate signal
sigVec = crcbgenqcsig(timeVec,A,[a1,a2,a3]);

%% 
% Make spectrogram with different time-frequency resolution

figure;
spectrogram(sigVec, 128,127,[],sampFreq);
figure;
spectrogram(sigVec, 256,250,[],sampFreq);

%%
% Make plots independently of the spectrogram function
[S,F,T]=spectrogram(sigVec, 256,250,[],sampFreq);
figure;
imagesc(T,F,abs(S));axis xy;
xlabel('Time (sec)');
ylabel('Frequency (Hz)');


