%% Minimize the fitness function CRCBREGSPLFITFUNC using PSO
% Generate a data realization with:
% Number of samples
nSamples = 512;
% Sampling frequency
Fs = 512;
% Matched filtering signal-to-noise ratio of true signal
snr = 10;
% Breakpoints for true signal, which is a single B-spline
sigBrkPts = [0.3,0.4,0.45,0.5,0.55];

%%
% Number of breakpoints that PSO will adjust
nDim = 5;
% Range for the standardized parameters (clscheme) representing the
% breakpoints
rminVal = 0.0;
rmaxVal = 1.0;

%%
% Number of independent PSO runs
nRuns = 4;

%% Do not change below
% Generate data realization
dataX = (0:(nSamples-1))/Fs;
% Reset random number generator to generate the same noise realization,
% otherwise comment this line out
rng('default');
[dataY, sig] = crcbgenbspldata(dataX,snr,sigBrkPts);

%Input parameters
inParams = struct('dataX', dataX,...
                  'dataY', dataY,...
                  'nBrks',nDim,...
                  'rminVal',rminVal,...
                  'rmaxVal',rmaxVal);
                  
% CRCBREGSPLPSO runs PSO on the CRCBREGSPLFITFUNC fitness function. As an
% illustration of usage, we change one of the PSO parameters from its
% default value.
outStruct = crcbregsplpso(inParams,struct('maxSteps',200),nRuns);

%%
% Plots
figure;
hold on;
plot(dataX,dataY,'.');
plot(dataX,sig);
for lpruns = 1:nRuns
    plot(dataX,outStruct.allRunsOutput(lpruns).estSig,'Color',[51,255,153]/255,'LineWidth',4.0);
end
plot(dataX,outStruct.bestSig,'Color',[76,153,0]/255,'LineWidth',2.0);
plot(outStruct.bestBrks,zeros(1,nDim),'s');





