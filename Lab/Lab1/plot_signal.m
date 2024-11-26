a1=10;
a2=3;
a3=3;
A = 10;
%%Instantaneous frequency
max_freq = a1 + 2*a2 + 3*a3;
nyq_freq = 2 * max_freq;
sample_freq = 5 * nyq_freq;
sample_interval = 1/sample_freq;
dataX = 0: sample_interval: 1;
n_sample = length(dataX);

%%generate signal
signal = qcgensig(dataX, A, [a1, a2, a3])

%%plot graph
figure
plot(dataX, signal, 'Marker', '.', 'MarkerSize', 10)
xlabel("time(second)")
title("time_signal")
%%plot periogram

%%fft
fft_sig = fft(signal);
kNqy = floor(n_sample/2)+1;
datalen = dataX(end) -dataX(1);
pos_freq = (0: kNqy-1)*(1/datalen);
pos_val = fft_sig(1: kNqy);
%%plot periograph
figure
plot(pos_freq, abs(pos_val))
xlabel("freqency(Hz)")
ylabel("|FFT|")