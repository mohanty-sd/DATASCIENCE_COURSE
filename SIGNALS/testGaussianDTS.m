%% Generate a Gaussian signal:

% Signal parameters
A = 3;
sigma = 0.08;
mu = 0.5;

% Time samples: Sample interval is directly chosen.
samplIntrvl = 0.01; 
timeVec = 0:samplIntrvl:1.0;

% Number of samples
nSamples = length(timeVec);

% Generate the signal
sigVec = GaussianDTS(timeVec,A,sigma,mu);

%Plot the signal 
figure;
plot(timeVec,sigVec,'Marker','.','MarkerSize',24);
xlabel('Time (sec)');
title('Sampled signal: Gaussian Signal');