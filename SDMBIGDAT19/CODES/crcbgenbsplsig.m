function sigVec = crcbgenbsplsig(dataX,snr,brkPts)
% Generate a single B-spline signal
%[Y,S] = CRCBGENBSPLSIG(X,SNR,B)
%Generate a single B-spline signal. X is the 
%vector of time stamps of the data samples. SNR is the matched
%filtering signal-to-noise ratio of the signal. B is the vector
%of  breakpoints defining the B-spline.

%Soumya D. Mohanty, May 2018

nSamples = length(dataX);

pp = bspline(brkPts);
indxFill = dataX>=brkPts(1) & dataX<=brkPts(end);

sigVec = zeros(1,nSamples);
sigVec(indxFill) = fnval(pp,dataX(indxFill));
sigVec = snr*sigVec/norm(sigVec);
