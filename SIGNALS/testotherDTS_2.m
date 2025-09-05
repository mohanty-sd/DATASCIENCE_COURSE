%% Generate the other signal:

% Signal parameters
A = 10;
sigma = 0.2;
mu = 0.5;
a1 = 3;
a2 = 2;
a3 = 4;

% Time samples: Sample interval is directly chosen.
samplIntrvl = 0.01; 
timeVec = -0.2:samplIntrvl:1.2;

% Number of samples
nSamples = length(timeVec);

% Generate the signal
sigVec = otherDTS_2(timeVec,A,sigma,mu,[a1,a2,a3]);

%Plot the signal 
figure;
plot(timeVec,sigVec,'Marker','.','MarkerSize',24);
xlabel('Time (sec)');
title('Sampled signal');