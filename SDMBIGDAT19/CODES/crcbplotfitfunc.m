%% Make surface plot of a fitness function
%Settings for surface plot (min, max, step size for 2D grid)
plotRmin = -5;
plotRmax = 5;
plotStpSz = 0.01;

% The fitness function called is CRCBPSOTESTFUNC. 
ffparams = struct('rmin',plotRmin,...
                     'rmax',plotRmax ...
                  );
% Fitness function handle.
fitFuncHandle = @(x) crcbpsotestfunc(x,ffparams);


%%Surface plot
figure;
%Range of each coordinate
xRng = plotRmax - plotRmin;
%Generate grid in XY plane
[x1,x2] = meshgrid(plotRmin:plotStpSz:plotRmax,plotRmin:plotStpSz:plotRmax);
%Standardize the coordinates before feeding to the fitness function
sx1 = (x1-plotRmin)/xRng;
sx2 = (x2-plotRmin)/xRng;
%Evaluate fitness values on the grid: each grid point's coordinates occupy
%one row
fVal = fitFuncHandle([sx1(:),sx2(:)]);
%Reshape to turn into a matrix (like the 2D grid)
fVal = reshape(fVal,[length(x2(:,1)),length(x1(1,:))]);
%Make surface plot
surf(x1,x2,fVal)
xlabel('x');
ylabel('y');
zlabel('Fitness value');
shading interp;

%%Contour plot
figure;
contourf(x1,x2,fVal);
xlabel('x');
ylabel('y');
