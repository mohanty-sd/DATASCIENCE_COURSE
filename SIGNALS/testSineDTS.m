%% Generate a sinusoidal signal:

% Signal parameters
a1=10;
A = 15;

% Time samples: Sample interval is directly chosen.
samplIntrvl = 0.004;
timeVec = 0:samplIntrvl:1.0;

% Number of samples
nSamples = length(timeVec);

% Generate the signal
sigVec = SineDTS(timeVec,A,[a1]);

%Plot the signal 
figure;
plot(timeVec,sigVec,'Marker','.','MarkerSize',24);
xlabel('Time (sec)');
title('Sampled signal: Sine Wave');