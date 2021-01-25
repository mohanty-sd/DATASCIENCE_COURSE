%% Low pass filter demo
addpath ../SIGNALS;
sampFreq = 1024;
nSamples = 2048;

timeVec = (0:(nSamples-1))/sampFreq;

%% Quadratic chirp signal
% Signal parameters
a1=10;
a2=3;
a3=10;
A = 10;
% Signal length
sigLen = (nSamples-1)/sampFreq;
%Maximum frequency
maxFreq = a1 + 2*a2*sigLen + 3*a3*sigLen^2;

disp(['The maximum frequency of the quadratic chirp is ', num2str(maxFreq)]);

% Generate signal
sigVec = crcbgenqcsig(timeVec,A,[a1,a2,a3]);

%% Remove frequencies above half the maximum frequency
% Design low pass filter
filtOrdr = 30;
b = fir1(filtOrdr,(maxFreq/2)/(sampFreq/2));
% Apply filter
filtSig = fftfilt(b,sigVec);

%% Plots
figure;
hold on;
plot(timeVec,sigVec);
plot(timeVec,filtSig);