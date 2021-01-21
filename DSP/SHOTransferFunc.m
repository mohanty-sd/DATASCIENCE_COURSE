%% Transfer function of SHO
f = 0:0.1:100;%frequency vector
k = 4*pi^2*25^2;
figure;
loglog(f,abs(1./(k-4*pi^2*f.^2)))
grid on
ylabel('|T(f)|','FontSize',14)
xlabel('f','FontSize',14)