%% Demo for colored Gaussian noise generation
%Sampling frequency for noise realization
sampFreq = 1024; %Hz
%Number of samples to generate
nSamples = 16384;
%Time samples
timeVec = (0:(nSamples-1))/sampFreq;

%Target PSD given by the inline function handle
targetPSD = @(f) (f>=100 & f<=300).*(f-100).*(300-f)/10000;

%Plot PSD
freqVec = 0:0.1:512;
psdVec = targetPSD(freqVec);
plot(freqVec,psdVec);

%%
% Design FIR filter with T(f)= square root of target PSD
% sqrtPSD = sqrt(psdVec);
 fltrOrdr = 500;
% b = fir2(fltrOrdr,freqVec/(sampFreq/2),sqrt(psdVec));
% 
% %%
% % Generate a WGN realization and pass it through the designed filter
% % (Comment out the line below if new realizations of WGN are needed in each run of this script)
% rng('default'); 
% inNoise = randn(1,nSamples);
% outNoise = fftfilt(b,inNoise);

%% Generate noise realization
outNoise = statgaussnoisegen(nSamples,[freqVec(:),psdVec(:)],fltrOrdr,sampFreq);

%%
% Estimate the PSD
% figure;
% pwelch(outNoise, 512,[],[],sampFreq);
% hold on;
% pwelch(inNoise, 512, [], [], sampFreq);
%Pwelch plots in dB (= 10*log10(x)); plot on a linear scale
[pxx,f]=pwelch(outNoise, 256,[],[],sampFreq);
figure;
plot(f,pxx);
xlabel('Frequency (Hz)');
ylabel('PSD');
% Plot the colored noise realization
figure;
plot(timeVec,outNoise);


