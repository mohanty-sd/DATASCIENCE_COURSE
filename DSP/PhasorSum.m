%% Phasor sum in Fourier transform of Dirac comb
% Shows a sequence of phasors where each phasor advances over the previous
% one by a fixed angle.
nPhasors = 1500;
deltheta = 62*pi/180;%radians
figure;
hold on;
for lp = 1:nPhasors
    plot(cos(lp*deltheta),sin(lp*deltheta),'o');
    line([0,cos(lp*deltheta)],[0,sin(lp*deltheta)]);
end
axis equal
title(['\theta = ',num2str(deltheta*180/pi),' degrees; N=',num2str(nPhasors)]);