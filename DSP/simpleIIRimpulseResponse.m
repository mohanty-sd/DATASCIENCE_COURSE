%% Impulse response of a simple IIR filter

%IIR filter coefficients
a1 = 1;
a2 = -0.25;
a3 = 0.8;
b1 = 1;
b2 = 0.5;
b3 = 0.25;

%Impulse sequence
impSeq = zeros(1,256);
impSeq(64) = 1;

%Apply the filter using the "filter" function and plot the impulse response
figure;
plot(filter([b1,b2,b3],[a1,a2,a3],impSeq))
