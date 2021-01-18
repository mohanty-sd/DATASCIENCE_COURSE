%% Signals and audio
% Time domain signal: sum of two sinusoids with frequencies 5 Hz and 1 Hz
nSamples = 20480;
samplingFreq = 100;
t = (0:(nSamples-1))/samplingFreq;
st = sin(2*pi*2*t).*(sin(2*pi*5*t)+2*sin(2*5.5*pi*t));
soundsc(st);
audiowrite('SampleSoundSignal.wav',st,8192);