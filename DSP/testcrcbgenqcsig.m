%% Plot the quadratic chirp signal
% Signal parameters
a1=10;
a2=3;
a3=3;
A = 10;
% Instantaneous frequency at end of signal
sigLen = 5; %second
maxFreq = a1+2*a2*sigLen+3*a3*sigLen^2;
samplFreq = 5*maxFreq;
samplIntrvl = 1/samplFreq;

% Time samples
timeVec = 0:samplIntrvl:sigLen;
% Number of samples
nSamples = length(timeVec);

% Generate the signal
sigVec = crcbgenqcsig(timeVec,A,[a1,a2,a3]);

%Plot the signal 
figure;
plot(timeVec,sigVec)

%% Periodogram 
%Length of data 
dataLen = timeVec(end)-timeVec(1);
%DFT sample corresponding to Nyquist frequency
kNyq = floor(nSamples/2)+1;
% Positive Fourier frequencies
posFreq = (0:(kNyq-1))*(1/dataLen);
% FFT of signal
fftSig = fft(sigVec);
% Discard negative frequencies
fftSig = fftSig(1:kNyq);

%Plot periodogram
figure;
hold on;
plot(posFreq,abs(fftSig));

