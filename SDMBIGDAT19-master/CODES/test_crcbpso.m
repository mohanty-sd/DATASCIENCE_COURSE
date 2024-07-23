%% Test harness for CRCBPSO 
% The fitness function called is CRCBPSOTESTFUNC. 
rmin = -10;% lower bound of search space coordinate
rmax = 10; %Upper bound of search space coordinate
ffparams = struct('rmin',rmin,...
                     'rmax',rmax ...
                  );
% Fitness function handle.
fitFuncHandle = @(x) crcbpsotestfunc(x,ffparams);
%%
% Call PSO.
rng('default')
psoOut = crcbpso(fitFuncHandle,2);

%% Estimated parameters
% Best standardized and real coordinates found.
stdCoord = psoOut.bestLocation;
[~,realCoord] = fitFuncHandle(stdCoord);
disp(['Best location:',num2str(realCoord)]);
disp(['Best fitness:', num2str(psoOut.bestFitness)]);

%%
% Call PSO with optional inputs
rng('default');
psoParams = struct('maxSteps',500);
psoOut = crcbpso(fitFuncHandle,2,psoParams,2);
%Plot the trajectory of the best particle
figure;
hold on;
%Contour plot of the fitness function
%=======================
%X and Y grids
xGrid = linspace(rmin,rmax,500);
yGrid = linspace(rmin,rmax,500);
[X,Y] = meshgrid(xGrid,yGrid);
%Standardize
Xstd = (X-rmin)/(rmax - rmin);
Ystd = (Y-rmin)/(rmax - rmin);
%Get fitness values
fitVal4plot = fitFuncHandle([Xstd(:),Ystd(:)]);
%Reshape array of fitness values
fitVal4plot = reshape(fitVal4plot,size(X));
contour((xGrid-rmin)/(rmax-rmin), (yGrid - rmin)/(rmax - rmin), fitVal4plot);
%========================
plot(psoOut.allBestLoc(:,1),psoOut.allBestLoc(:,2),'.-');
title('Trajectory of the best particle');
figure;
title('Plot of fitness function');
surf(X,Y,fitVal4plot); shading interp;
figure;
plot(psoOut.allBestFit);
stdCoord = psoOut.bestLocation;
[~,realCoord] = fitFuncHandle(stdCoord);
disp(['Number of iterations changed from the default value to ',...
      num2str(psoParams.maxSteps)]);
disp(['Best location:',num2str(realCoord)]);
disp(['Best fitness:', num2str(psoOut.bestFitness)]);
