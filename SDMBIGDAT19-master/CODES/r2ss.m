function xVec = r2ss(rVec,rngMin,rngMax)
%Convert real coordinates to standardized ones using uniform range limits
%R = R2SS(X,R1,R2)
%Takes standardized coordinates in X (coordinates of one point per row) and
%returns real coordinates in R using the range limits R1 < R2.

%Soumya D. Mohanty
%May 2016

%Number of rows = number of points
%Number of columns = number of dimensions
[nrows,ncols]=size(rVec);
%Storage for real coordinates
xVec = zeros(nrows,ncols);
%Range for each coordinate dimension is the same
rmin = rngMin*ones(1,ncols);
rmax = rngMax*ones(1,ncols);
rngVec = rmax-rmin;
%Apply range to standardized coordinates and convert to real coordinates
for lp = 1:nrows
    xVec(lp,:) = (rVec(lp,:)-rmin)./rngVec;
end