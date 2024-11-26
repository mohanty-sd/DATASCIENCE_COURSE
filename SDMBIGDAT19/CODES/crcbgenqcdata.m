function [dataVec,sigVec] = crcbgenqcdata(dataX,snr,qcCoefs)
% Generate data containing a quadratic chirp signal
% [Y,S] = CRCBGENQCDATA(X,SNR,C)
% Generates a realization of data containing a quadratic chirp signal S
% embedded in white Gaussian noise with unit variance. X is the vector of
% time stamps at which the samples of data in Y are to be computed. SNR is
% the matched filtering signal-to-noise ratio of S and C is the vector of
% three coefficients [a1, a2, a3] that parametrize the signal phase, given
% by a1*t+a2*t^2+a3*t^3. 

%Soumya D. Mohanty, May 2018

nSamples = length(dataX);

sigVec = crcbgenqcsig(dataX,snr,qcCoefs);

dataVec = sigVec+randn(1,nSamples);

