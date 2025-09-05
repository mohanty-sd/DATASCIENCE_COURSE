%% Generate a pure exp decay signal:

% Signal parameters
A = 15;
tau = 0.35;

% Time samples: Sample interval is directly chosen.
samplIntrvl = 0.04;
timeVec = 0:samplIntrvl:1.0;

% Number of samples
nSamples = length(timeVec);

% Generate the signal
sigVec = PureExpDecayDTS(timeVec,A,tau);

%Plot the signal 
figure;
plot(timeVec,sigVec,'Marker','.','MarkerSize',24);
xlabel('Time (sec)');
title('Sampled signal: Pure Exponential Decay');