function [dataY,sigVec] = crcbgenbspldata(dataX,snr,brkPts)
% Generate a data realization containing a single B-spline signal
%[Y,S] = CRCBGENBSPLDATA(X,SNR,B)
%Generate a data realization containing a single B-spline function as the
%signal embedded in white Gaussian noise with unit variance. X is the 
%vector of time stamps of the data samples. SNR is the matched
%filtering signal-to-noise ratio of the signal. B is the vector
%of  breakpoints defining the B-spline.

%Soumya D. Mohanty, May 2018

nSamples = length(dataX);

sigVec = crcbgenbsplsig(dataX,snr,brkPts);

dataY = sigVec + randn(1,nSamples);

