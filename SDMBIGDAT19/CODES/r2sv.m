function xVec = r2sv(rVec,params)
%Convert real coordinates to standardized ones.
%X = R2SV(R,P)
%Takes real coordinates in R (coordinates of one point per row) and returns
%standardized coordinates in X using the range limits defined in P.rmin and
%P.rmax. The range limits can be different for different dimensions. (If
%they are same for all dimensions, use R2SS instead.)

%Soumya D. Mohanty
%May 2016
[nrows,ncols] = size(rVec);
xVec = zeros(nrows,ncols);
rmin = params.rmin;
rmax = params.rmax;
rngVec = rmax-rmin;
%If rmin = rmax for any coordinate, its standardized value should be 0.
%For such a case, only compute the difference between the
%coordinate and the minimum value and don't divide by the range
rngVec(rngVec==0)=1;
for lp = 1:nrows
    xVec(lp,:) = (rVec(lp,:)-rmin)./rngVec;
end