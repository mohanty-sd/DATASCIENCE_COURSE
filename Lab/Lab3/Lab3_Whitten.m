function Whittened= Lab3_Whitten(nSamples,psdVals,fltrOrdr,sampFreq)

% Design FIR filter with T(f)= square root of target PSD
freqVec = psdVals(:,1);
sqrtPSD = sqrt(psdVals(:,2));
b = fir2(fltrOrdr,freqVec/(sampFreq/2),sqrtPSD);
b = b.^-1;

%%
% Generate a WGN realization and pass it through the designed filter
% (Comment out the line below if new realizations of WGN are needed in each run of this script)
% rng('default'); 
inNoise = randn(1,nSamples);
Whittened = sqrt(sampFreq)*fftfilt(b,inNoise);

