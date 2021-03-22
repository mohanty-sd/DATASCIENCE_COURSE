function innProd = innerprodpsd(xVec,yVec,sampFreq,psdVals)
%P = INNERPRODPSD(X,Y,Fs,Sn)
%Calculates the inner product of vectors X and Y for the case of Gaussian
%stationary noise having a specified power spectral density. Sn is a vector
%containing PSD values at the positive frequencies in the DFT of X
%and Y. The sampling frequency of X and Y is Fs.

%Soumya D. Mohanty, Mar 2019

nSamples = length(xVec);
if length(yVec) ~= nSamples
    error('Vectors must be of the same length');
end
kNyq = floor(nSamples/2)+1;
if length(psdVals) ~= kNyq
    error('PSD values must be specified at positive DFT frequencies');
end

fftX = fft(xVec);
fftY = fft(yVec);
%We take care of even or odd number of samples when replicating PSD values
%for negative frequencies
negFStrt = 1-mod(nSamples,2);
psdVec4Norm = [psdVals,psdVals((kNyq-negFStrt):-1:2)];

dataLen = sampFreq*nSamples;
innProd = (1/dataLen)*(fftX./psdVec4Norm)*fftY';
innProd = real(innProd);