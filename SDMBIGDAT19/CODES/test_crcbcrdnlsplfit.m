%% Cardinal B-spline fit to data
% Generate a data realization with:
% Number of samples
nSamples = 512;
% Sampling frequency
Fs = 512;
% Matched filtering signal-to-noise ratio of true signal
snr = 10;
% Breakpoints for true signal, which is a single B-spline
sigBrkPts = [0.3,0.4,0.45,0.5,0.55];
% Number of interior breakpoints to use for the fit
nIntBrks = 5;

%% Do not change below
% Generate data realization (comment out next line to generate different
% noise realizations on each call)
rng('default')
dataX = (0:(nSamples-1))/Fs;
[dataY, sig] = crcbgenbspldata(dataX,snr,sigBrkPts);

                  
outStruct = crcbcrdnlsplfit(dataX,dataY,nIntBrks);

%%
% Plots
figure;
hold on;
plot(dataX,dataY,'.');
plot(dataX,sig);
plot(dataX,outStruct.estSig,'Color',[76,153,0]/255,'LineWidth',2.0);
plot(outStruct.brkPts,zeros(1,nIntBrks+2),'s');





