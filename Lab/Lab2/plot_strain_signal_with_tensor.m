f0 = 50;
%[h_plus, h_cross] = strain_signal_sinusoid_gen(10, 20, f0, 30/180*pi);
t = 0: 1/(floor(2*f0)+1): 1;
%plot(t, h_plus)

%theta = 10/180*pi;
%phi = 20/180*pi;
theta = 0: 0.01: pi;
phi = 0: 0.01: 2*pi;
[F_plus, F_cross] = antenna_patter(theta, phi);

[P, T] = meshgrid(phi, theta);
%plot a circle
X = sin(T).*cos(P);
Y = sin(T).*sin(P);
Z = cos(T);

figure
surf(X, Y, Z, abs(F_plus))
axis equal
shading interp
colorbar
title("FPlus")

figure
surf(X, Y, Z, abs(F_cross))
axis equal
shading interp
colorbar
title("FCross")