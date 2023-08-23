function injSigVec = injsig(toa, nSmpls, Fs, sigParams, whtTF)
%Generate unit norm zero initial phase whitened signal for injection
%S = INJSIG(TOA,N,Fs,P,W)
%S is the unit norm zero initial phase whitened signal shifted to the right
%by TOA (sec). N is the number of samples in the signal, Fs is the sampling
%frequency, P is a struct containing restricted 2PN parameters, W is the
%whitening transfer function (should have length N and cover both positive
%and negative frequencies).

%Soumya D. Mohanty, Mar 2023

sigVec_fftMat = rstrct2pntmplt(nSmpls, Fs, sigParams);
%Whiten the signal
injSigVec = sigVec_fftMat(1,:).*whtTF;
%Normalize 
injSigVec = injSigVec/sqrt(sum(injSigVec*injSigVec')/nSmpls);
%Time series
injSigVec = circshift(ifft(injSigVec),floor(toa * Fs));