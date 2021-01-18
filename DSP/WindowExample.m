%% Effect of windowing
% Box car window
s = [zeros(1,50),cos(2*pi*10*(0:99)/100),zeros(1,50)];
figure;
subplot(2,1,1)
plot((0:199)/100-1,s);
%boxcar
hold on;
plot((0:199)/100-1,[zeros(1,50),ones(1,100),zeros(1,50)],'LineWidth',2);
subplot(2,1,2)
plot(abs(fft(s)));
%%
% Hann window
w = hann(100);
s = [zeros(1,50),w'.*cos(2*pi*10*(0:99)/100),zeros(1,50)];
figure;
subplot(2,1,1)
plot((0:199)/100-1,s);
hold on;
plot((0:199)/100-1,[zeros(1,50),w',zeros(1,50)],'LineWidth',2);
subplot(2,1,2)
plot(abs(fft(s)))
%%
% Sum of sinusoids
s = [zeros(1,50),10*cos(2*pi*10*(0:99)/100)+cos(2*pi*15*(0:99)/100),zeros(1,50)];
figure;
subplot(2,1,1)
plot((0:199)/100-1,s);
hold on;
subplot(2,1,2)
plot(abs(fft(s)));
hold on;
s = [zeros(1,50),hann(100)'.*(10*cos(2*pi*10*(0:99)/100)+cos(2*pi*15*(0:99)/100)),zeros(1,50)];
subplot(2,1,1)
plot((0:199)/100-1,s);
subplot(2,1,2)
plot(abs(fft(s)))

