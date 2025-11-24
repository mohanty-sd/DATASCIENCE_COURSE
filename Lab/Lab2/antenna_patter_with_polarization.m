function [F_plus, F_cross] = antenna_patter_with_polarization(theta, phi, psi)

nx = [1,0,0];
ny = [0,1,0];
nz = [0,0,1];

n = [sin(phi)*cos(theta), sin(phi)*sin(theta), cos(theta)];
xhat = vec_cross_prod(nz, n);
xhat = xhat/norm(xhat);
yhat = vec_cross_prod(xhat, n);
X = xhat*cos(psi) + sin(psi)*yhat;
Y = -sin(psi)*xhat + cos(psi)*yhat;

eplus = X'*X - Y'*Y;
ecross = X'*Y + Y'*X;

D = 1/2*(nx'*nx - ny'*ny);

%Contraction
F_plus = sum(sum(D.*eplus));
F_cross = sum(sum(D.*ecross));


end