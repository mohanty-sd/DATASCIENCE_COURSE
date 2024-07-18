function cVec = vcrossprod(aVec, bVec)
% Cross product of vectors
% C = VCROSSPROD(A,B)
% C = A X B
% If A and B are N-by-3 matrices, C is computed for each row of A and B.

[nVecs, ~] = size(aVec); 
cVec = zeros(nVecs, 3);
cVec(:, 1) = aVec(:, 2) .* bVec(:, 3) - aVec(:, 3) .* bVec(:, 2);
cVec(:, 2) = aVec(:, 3) .* bVec(:, 1) - aVec(:, 1) .* bVec(:, 3);
cVec(:, 3) = aVec(:, 1) .* bVec(:, 2) - aVec(:, 2) .* bVec(:, 1);
end


function [fPlus, fCross] = detframefpfc(polAngleTheta, polAnglePhi)
% Antenna pattern functions in detector local frame (arms at 90 degrees)
% [Fp, Fc] = DETFRAMEFPFC(T, P)
% Returns the antenna pattern function values Fp, Fc (corresponding to F_+
% and F_x respectively) for a given sky location in the local frame of a 
% 90 degree equal arm length interferometer. The X and Y axes of the frame
% point along the arms. T is the polar angle (0 radians on the Z axis) and P
% is the azimuthal angle (0 radians on the X axis). T and P can be vectors
% (equal lengths), in which case Fp and Fc are also vectors with Fp(i) and
% Fc(i) corresponding to T(i) and P(i).

% Number of sky locations requested
nLocs = length(polAngleTheta);
if length(polAnglePhi) ~= nLocs
    error('Number of theta and phi values must be the same');
end

% Obtain the components of the unit vector pointing to the source location
sinTheta = sin(polAngleTheta(:));
vec2Src = [sinTheta .* cos(polAnglePhi(:)),...
           sinTheta .* sin(polAnglePhi(:)),...
           cos(polAngleTheta(:))];
       
% Get the wave frame X and Y vector components (for multiple sky locations if needed)
xVec = vcrossprod(repmat([0, 0, 1], nLocs, 1), vec2Src);
yVec = vcrossprod(xVec, vec2Src);
% Normalize wave frame vectors
for lpl = 1:nLocs
    xVec(lpl, :) = xVec(lpl, :) / norm(xVec(lpl, :));
    yVec(lpl, :) = yVec(lpl, :) / norm(yVec(lpl, :));
end

% Rotation angle (example: rotate by 30 degrees)
theta_rotation = deg2rad(60);  % Example: rotate by 30 degrees

% Rotate X and Y vectors
xVec = xVec .* cos(theta_rotation) - yVec .* sin(theta_rotation);
yVec = xVec .* sin(theta_rotation) + yVec .* cos(theta_rotation);

% Detector tensor of a perpendicular arm interferometer 
detTensor = 0.5/（[1, 0, 0]' * [1, 0, 0] - [0, 1, 0]' * [0, 1, 0]）;
fPlus = zeros(1, nLocs);
fCross = zeros(1, nLocs);
% For each location ...
for lpl = 1:nLocs
    % ePlus contraction with detector tensor
    waveTensor = xVec(lpl, :)' * xVec(lpl, :) - yVec(lpl, :)' * yVec(lpl, :);
    fPlus(lpl) = sum(waveTensor(:) .* detTensor(:));
    % eCross contraction with detector tensor
    waveTensor = xVec(lpl, :)' * yVec(lpl, :) + yVec(lpl, :)' * xVec(lpl, :);
    fCross(lpl) = sum(waveTensor(:) .* detTensor(:));
end
end


% Polar and azimuthal angles for plotting
theta = 0:0.05:pi;
phi = 0:0.05:(2*pi);

% Convert to Cartesian coordinates
[A, D] = meshgrid(phi, theta);
X = sin(D) .* cos(A);
Y = sin(D) .* sin(A);
Z = cos(D);

% Calculate fPlus, fCross
fPlus = zeros(length(theta), length(phi));
fCross = zeros(length(theta), length(phi));
for lp1 = 1:length(phi)
    for lp2 = 1:length(theta)
        [fPlus(lp2, lp1), fCross(lp2, lp1)] = detframefpfc(theta(lp2), phi(lp1));
    end
end
length(theta)
length(phi)

% Plot rotated results
figure;
surf(rotated_X, rotated_Y, Z, abs(fPlus));
shading interp;
axis equal;
colorbar;
title('Antenna Pattern Function F+ after Rotation');

figure;
surf(rotated_X, rotated_Y, Z, abs(fCross));
shading interp;
axis equal;
colorbar;
title('Antenna Pattern Function Fx after Rotation');
