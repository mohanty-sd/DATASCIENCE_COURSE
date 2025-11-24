function rVec = s2rv(xVec,params)
%Convert standardized coordinates to real using non-uniform range limits
%R = S2RV(X,P)
%Takes standardized coordinates in X (coordinates of one point per row) and
%returns real coordinates in R using the range limits defined in P.rmin and
%P.rmax. The range limits can be different for different dimensions. (If
%they are same for all dimensions, use S2RS instead.)

%Soumya D. Mohanty
%April 2012

[nrows,ncols] = size(xVec);
rVec = zeros(nrows,ncols);
rmin = params.rmin;
rmax = params.rmax;
rngVec = rmax-rmin;
for lp = 1:nrows
    rVec(lp,:) = xVec(lp,:).*rngVec+rmin;
end