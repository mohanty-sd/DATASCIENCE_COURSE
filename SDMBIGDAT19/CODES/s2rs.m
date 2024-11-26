function rVec = s2rs(xVec,rngMin,rngMax)
%Convert standardized coordinates to real using uniform range limits
%R = S2RS(X,R1,R2)
%Takes standardized coordinates in X (coordinates of one point per row) and
%returns real coordinates in R using the range limits R1 < R2.

%Soumya D. Mohanty
%April 2012

%Number of rows = number of points
%Number of columns = number of dimensions
[nrows,ncols]=size(xVec);
%Storage for real coordinates
rVec = zeros(nrows,ncols);
%Range for each coordinate dimension is the same
rmin = rngMin*ones(1,ncols);
rmax = rngMax*ones(1,ncols);
rngVec = rmax-rmin;
%Apply range to standardized coordinates and convert to real coordinates
for lp = 1:nrows
    rVec(lp,:) = xVec(lp,:).*rngVec+rmin;
end
