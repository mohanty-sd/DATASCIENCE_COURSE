%% Generate a sinusoidal decay signal:

% Signal parameters
a1=7;
A = 15;
tau = 0.35;

% Time samples: Sample interval is directly chosen.
samplIntrvl = 0.007; 
timeVec = 0:samplIntrvl:1.0;

% Number of samples
nSamples = length(timeVec);

% Generate the signal
sigVec = SinExpDecayDTS(timeVec,A,tau,[a1]);

%Plot the signal 
figure;
plot(timeVec,sigVec,'Marker','.','MarkerSize',24);
xlabel('Time (sec)');
title('Sampled signal: Sinusoidal Decay');