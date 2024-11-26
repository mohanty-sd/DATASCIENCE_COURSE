function outResults = crcbregsplpso(inParams, psoParams, nRuns)
%PSO based regression spline
%O = CRCBREGSPLPSO(I,P,N)
%Regression spline with PSO-based breakpoint optimization. I is the input
%struct with the fields given below.  P is the PSO parameter struct (see
%CRCBPSO). N is the number of independent PSO runs to pick the best result
%from. The output is returned in the struct O.
%The fields of I are:
% 'dataY': The data vector (a uniformly sampled time series).
% 'dataX': The time stamps of the data samples.
% 'nBrks': The number of breakpoints to optimize.
% 'rminVal','rmaxVal': The minimum and maximum values for the standardized
%                      representation of each breakpoint.
%The fields of O are:
% 'allRunsOutput': An N element struct array containing results from each PSO
%              run. The fields of this struct are:
%                 'fitVal': The fitness value.
%                 'bsplCoeffs': The B-spline coefficients.
%                 'brkPts': The breakpoints.
%                 'estSig': The estimated signal.
%                 'totalFuncEvals': The total number of fitness
%                                   evaluations.
% 'bestRun': The best run.
% 'bestFitness': The best fitness from the best run.
% 'bestSig' : The signal estimated by the best run.
% 'bestBrks' : The breakpoints found in the best run.

%Soumya D. Mohanty, May 2018

dataX = inParams.dataX;
dataY = inParams.dataY;
nbrks4Srch = inParams.nBrks;
nIntBrks = nbrks4Srch - 2;
nBsplines = nIntBrks - 2;
rminVal = inParams.rminVal;
rmaxVal = inParams.rmaxVal;

nSamples = length(dataY);

%Parameters for fitness function
nDim = nbrks4Srch;
rmin = rminVal*ones(1,nDim);
rmax = rmaxVal*ones(1,nDim);

params = struct('dataY',dataY,'dataX',dataX,...
                'rmin',rmin, 'rmax', rmax);

fHandle = @(x) crcbregsplfitfunc(x,params);

outStruct = struct('totalFuncEvals',[],...
                   'bestLocation',[],...
                   'bestFitness',[]);
outResults = struct('allRunsOutput',struct('fitVal', [],...
                                           'brkPts',zeros(1,nbrks4Srch),...
                                           'bsplCoeffs',zeros(1,nbrks4Srch),...
                                           'estSig',zeros(1,nSamples),...
                                           'totalFuncEvals',[]),...
                    'bestRun',[],...
                    'bestFitness',[],...
                    'bestSig', zeros(1,nSamples),...
                    'bestBrks',zeros(1,nbrks4Srch));
                
%Allocate storage for outputs: results from all runs are stored
for lpruns = 2:nRuns
    outStruct(lpruns) = outStruct(1);
    outResults.allRunsOutput(lpruns) = outResults.allRunsOutput(1);
end

%Independent runs of PSO in parallel. Change 'parfor' to 'for' if the
%parallel computing toolbox is not available.
parfor lpruns = 1:nRuns
    rng(lpruns);
    outStruct(lpruns) = crcbpso(fHandle,nDim,psoParams);
end

%Prepare output
fitVal = zeros(1,nRuns);
estSig = zeros(nRuns,nSamples);
brkPts = zeros(nRuns,nbrks4Srch);
bsplCoeffs = zeros(nRuns,nBsplines);
for lpruns = 1:nRuns
    fitVal(lpruns) = outStruct(lpruns).bestFitness;
    [~,brkPts(lpruns,:),bsplCoeffs(lpruns,:),estSig(lpruns,:)] = fHandle(outStruct(lpruns).bestLocation);
    outResults.allRunsOutput(lpruns).fitVal = fitVal(lpruns);
    outResults.allRunsOutput(lpruns).brkPts = brkPts(lpruns,:);
    outResults.allRunsOutput(lpruns).bsplCoeffs = bsplCoeffs(lpruns,:);
    outResults.allRunsOutput(lpruns).estSig = estSig(lpruns,:);
    outResults.allRunsOutput(lpruns).totalFuncEvals = outStruct(lpruns).totalFuncEvals;
end
%Find the best run
[~,bestRun] = min(fitVal(:));
outResults.bestRun = bestRun;
outResults.bestFitness = outResults.allRunsOutput(bestRun).fitVal;
outResults.bestSig = outResults.allRunsOutput(bestRun).estSig;
outResults.bestBrks = outResults.allRunsOutput(bestRun).brkPts;



