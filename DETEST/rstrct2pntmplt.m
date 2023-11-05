function tmpltFFTMat  = rstrct2pntmplt(nSmpls,Fs,sigParams)
%Restricted 2PN templates for matched filtering

%2PN restricted chirp parameters
mass1 = sigParams.mass1; %Solar masses
mass2 = sigParams.mass2; %Solar masses
%Low frequency cutoff 
fMin = sigParams.fMin;%Hz
%Plunge cutoff
fMax = sigParams.fMax;%Hz

chrpTimeVec = dscrs_pn2chirp_mass2chtime(mass1, mass2, fMin);
sigLen = sum([1,1,-1,1].*chrpTimeVec);
disp(['Approximate signal length ',num2str(sigLen),' sec']);

%Generate positive DFT frequencies
dataLen = (nSmpls-1)/Fs;
kNyq = floor(nSmpls/2)+1;
posFreq = (0:(kNyq-1))/dataLen;

%Convert chirp times to alpha coefficients in the phase function
chrpAlphParams_prefac = 2*pi*fMin*[0.6, 1, -1.5, 3, 1];

%Convert chirp times to alpha coefficients in the phase function
chrpAlphParams = zeros(size(chrpAlphParams_prefac));
chrpAlphParams(1:(end-1)) = chrpAlphParams_prefac(1:(end-1)).*chrpTimeVec;
%Special term containing the linear combination of chirp times
chrpAlphParams(end) = chrpAlphParams_prefac(end)*sum([1,1,-1,1].*chrpTimeVec);
%chrpAlphParams = pn2chirp_chtime2alph(chrpTimeVec,chrpAlphParams_prefac);

%Generate powers of frequency for the different terms in the phase function
%that will be multiplied by the alpha coefficients
[posFreqMat,fMinIndx,fMaxIndx] = dscrs_pn2chirp_posfreqmat(dataLen, posFreq, fMin, fMax);

%Generate argument psi(f) of phase exp(-1i*psi(f))
phaseArg = chrpAlphParams*posFreqMat;

%Generate signal DFT magnitude
magFunc = zeros(size(posFreq));
magFunc(fMinIndx:fMaxIndx) = posFreq(fMinIndx:fMaxIndx).^(-7/6);

%Generate signal DFT (two quadratures) for positive and negative frequencies 
tmpltFFTMat = zeros(1,nSmpls);
nPosFreq = length(magFunc);
%Cosine quadrature (h_c)
tmpltFFTMat(1,1:nPosFreq) = magFunc.*exp(-1i * phaseArg);
%Sine quadrature (h_s) is cosine quadrature times exp(i*pi/2) = i
tmpltFFTMat(2,1:nPosFreq) = tmpltFFTMat(1, 1:nPosFreq)*(1i);
%Fill negative frequencies
if ~mod(nSmpls,2)
    %Even
    tmpltFFTMat(:,(1+nPosFreq):end) = conj(tmpltFFTMat(:,(nPosFreq-1):-1:2));
else
    %Odd
    tmpltFFTMat(:,(1+nPosFreq):end) = conj(tmpltFFTMat(:,nPosFreq:-1:2));
end

%Inverse FFT and plot
%dataVec_sigVec = ifft(dataVec_fftSigVec(1,:));
% 
% figure;
% timeVec = (0:(dataVecWhtTF_full_nSmpls-1))/dataVec_fsmp;
% plot(timeVec,dataVec_sigVec);