clc;clear

fc = @(phi_vec, theta_vec) cos(theta_vec).*sin(2*phi_vec);
phi_vec = 0: 0.01: 2*pi;
theta_vec = 0: 0.01: pi;
[P, T] = meshgrid(phi_vec, theta_vec);
X = sin(T).*cos(P);
Y = sin(T).*sin(P);
Z = cos(T);
f_val = zeros(length(theta_vec), length(phi_vec));
for i = 1: length(theta_vec)
    for j = 1: length(phi_vec)
        f_val(i, j) = fc(phi_vec(j), theta_vec(i));
    end
end
figure
surf(X, Y, Z, abs(f_val))
shading interp
xlabel("")

%plot another graph
fp = @(phi_vec, theta_vec) 1/2*(1+cos(theta_vec).^2).*cos(2*phi_vec);
f_val2 = zeros(length(theta_vec), length(phi_vec));
for i = 1: length(theta_vec)
    for j = 1: length(phi_vec)
        f_val2(i, j) = fp(phi_vec(j), theta_vec(i));
    end
end
figure
surf(X, Y, Z, abs(f_val2))
shading interp
