function [F_plus, F_cross] = antenna_patter(theta, phi)

%define
%detoctor frame
nx = [1,0,0];
ny = [0,1,0];
nz = [0,0,1];
F_plus = zeros(length(theta), length(phi));
F_cross = zeros(length(theta), length(phi));
%Detector tensor
D = 1/2*(nx'*nx - ny'*ny);
for j = 1: length(theta)
    for i = 1: length(phi)
        n = [cos(phi(i))*sin(theta(j)), sin(phi(i))*sin(theta(j)), cos(theta(j))];
        xhat = vec_cross_prod(nz, n);
        xhat = xhat/norm(xhat);
        yhat = vec_cross_prod(xhat, n);
        
        %Polarrization_tensor
        e_plus = xhat'*xhat - yhat'*yhat;
        e_cross = xhat'*yhat + yhat'*xhat;
        
        
        %Contraction
        F_plus(j, i) = sum(sum(D.*e_plus));
        F_cross(j, i) = sum(sum(D.*e_cross));
    end
end


end
