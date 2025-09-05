%% Generate a quadratic chirp signal:

% Signal parameters
a1=7;
a2=5;
a3=4;
A = 15;

% Time samples: Sample interval is directly chosen.
samplIntrvl = 0.004; 
timeVec = 0:samplIntrvl:1.0;

% Number of samples
nSamples = length(timeVec);

% Generate the signal
sigVec = QuadChirpDTS(timeVec,A,[a1,a2,a3]);

%Plot the signal 
figure;
plot(timeVec,sigVec,'Marker','.','MarkerSize',24);
xlabel('Time (sec)');
title('Sampled signal: Quadratic Chirp');