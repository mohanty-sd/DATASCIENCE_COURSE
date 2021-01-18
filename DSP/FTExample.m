%% Simple example of a signal and its Fourier transform
%%
% Time domain signal: sum of two sinusoids with frequencies 5 Hz and 1 Hz
nSamples = 20480;
samplingFreq = 100;
t = (0:(nSamples-1))/samplingFreq;
st = sin(2*pi*2*t).*(sin(2*pi*5*t)+2*sin(2*5.5*pi*t));
% soundsc(st);
% audiowrite('SampleSoundSignal.wav',st,8192);
%%
% Real and imaginary parts of its Discrete Fourier Transform
fftst = fft(st);
af=real(fftst);
bf=imag(fftst);
%%
% Unpack the positive and negative frequencies
df = 1/(t(end)-t(1));
kNyq = floor(nSamples/2);
freq=[(-(kNyq-1):-1)*df,(0:kNyq)*df];
%%
figure
subplot(2,1,1)
plot(t,st)
xlabel('Time (sec)','FontSize',14)
ylabel('s(t)','FontSize',14)
axis tight;
grid on;

subplot(2,1,2)
plot(freq,[af((kNyq+2):end),af(1:(kNyq+1))])
axis tight
hold on
plot(freq,[bf((kNyq+2):end),bf(1:(kNyq+1))])
plot(freq,[sqrt(af((kNyq+2):end).^2+bf((kNyq+2):end).^2),sqrt(af(1:(kNyq+1)).^2+bf(1:(kNyq+1)).^2)])
legend('real','imaginary','absolute value')
xlabel('Frequency (Hz)','FontSize',14)
title('Fourier transform','FontSize',14)
grid on
