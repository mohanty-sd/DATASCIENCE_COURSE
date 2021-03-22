function [normSigVec,normFac]=normsig4psd(sigVec, sampFreq, psdVec, snr)
% Normalize a given signal to have a specified SNR in specified noise PSD
% [NS,NF]=NORMSIG4PSD(S,Fs,Sn,SNR)
% S is the signal vector to be normalized to have signal to noise ratio SNR
% in noise with PSD specified by vector Sn. The PSD should be specified at
% the positive DFT frequencies corresponding to the length of S and
% sampling frequency Fs. The normalized signal vector is returned in NS and
% the normalization factor is returned in NF.

%Soumya D. Mohanty, Mar 2019

%PSD length must be commensurate with the length of the signal DFT 
nSamples = length(sigVec);
kNyq = floor(nSamples/2)+1;
if length(psdVec) ~= kNyq
    error('Length of PSD is not correct');
end

% Norm of signal squared is inner product of signal with itself
normSigSqrd = innerprodpsd(sigVec,sigVec,sampFreq,psdVec);
% Normalization factor
normFac = snr/sqrt(normSigSqrd);
% Normalize signal to specified SNR
normSigVec = normFac*sigVec;

