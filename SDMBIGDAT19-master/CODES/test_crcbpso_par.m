%% Test harness for CRCBPSO 
% The fitness function called is CRCBPSOTESTFUNC. 
ffparams = struct('rmin',-100,...
                     'rmax',100 ...
                  );
% Fitness function handle.
fitFuncHandle = @(x) crcbpsotestfunc(x,ffparams);
%%
% Dimensionality of the search space
nDim = 2;

% Call PSO and use best-of-M-runs
nRuns = 4; %Number of PSO runs
psoOut = struct('totalFuncEvals',[],...
                    'bestLocation',zeros(1,nDim),...
                    'bestFitness',[]);
%We need to have one psoOut struct for each run: make a struct array with
%each element initialized to be the same as the first
for lpruns = 2:nRuns
    psoOut(lpruns) = psoOut(1);
end
parfor lpruns = 1:nRuns
        %Reset random number generator for each worker such that the
        %pseudo-random sequence is different for them but they repeat
        %everytime this code is run
        rng(lpruns);
        %PSO run 
        psoOut(lpruns) = crcbpso(fitFuncHandle,nDim);
end
%Find best run
bestRun = 1;
for lpruns = 2:nRuns
    if psoOut(lpruns).bestFitness < psoOut(bestRun).bestFitness
        bestRun = lpruns;
    end
end
%% Estimated parameters
% Best standardized and real coordinates found.
stdCoord = psoOut(bestRun).bestLocation;
[~,realCoord] = fitFuncHandle(stdCoord);
disp(['Best run:',num2str(bestRun)]);
disp(['Best location:',num2str(realCoord)]);
disp(['Best fitness:', num2str(psoOut(bestRun).bestFitness)]);
disp('Info for all runs:');
for lpruns = 1:nRuns
    stdCoord = psoOut(lpruns).bestLocation;
    [~,realCoord] = fitFuncHandle(stdCoord);
    disp(['Best location for run ',num2str(lpruns),': ',num2str(realCoord)]);
    disp(['Best fitness for run ',num2str(lpruns),': ', num2str(psoOut(lpruns).bestFitness)]);
    disp('*****************');
end