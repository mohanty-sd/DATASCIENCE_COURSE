function [h_plus, h_cross] = strain_signal_sinusoid_gen(A, B, f0, phi0)
t_plus = 0: 1/(floor((2*f0))+1): 1;
t_cross = t_plus;

h_plus = A*sin(2*pi*f0*t_plus);
h_cross = B*sin(2*pi*f0*t_cross+phi0);






end