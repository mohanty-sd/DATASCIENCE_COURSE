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
hold on;

%%
% Design FIR filter with T(f)= square root of target PSD
sqrtPSD = sqrt(psdVec);
 fltrOrdr = 500;
b = fir2(fltrOrdr,freqVec/(sampFreq/2),sqrt(psdVec));

% %%


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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%pwelch算出来的是两倍，要除以2
pxx = pxx/2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(f,pxx);
xlabel('Frequency (Hz)');
ylabel('PSD (Hz^{-1})');
legend('True', 'Trial(/2)')
title('PSD')
grid on;
hold off;

% Plot the colored noise realization
figure;
plot(timeVec,outNoise);
xlabel('Time(s)')
ylabel('Strain')
title('Out Noise')


