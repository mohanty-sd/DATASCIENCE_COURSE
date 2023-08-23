function tmpltFFTMat  = compLIGOdeglitch2pntmplt(nSmpls,Fs,sigParams)
%Restricted 2PN templates for matched filtering


%Solar mass in Kg
solMass = 1.9891e30; %Kg

%2PN restricted chirp parameters
mass1 = sigParams.mass1; %Solar masses
mass2 = sigParams.mass2; %Solar masses
%Low frequency cutoff 
fMin = sigParams.fMin;%Hz
%Plunge cutoff
fMax = sigParams.fMax;%Hz
%Initial phase
%phi0 = sigParams.phi0;
%Optional window in frequency domain (e.g. @bartlett)
winName = sigParams.winName;


chrpTimeVec = pn2chirp_mass2chtime(mass1*solMass, mass2*solMass, fMin);
sigLen = sum([1,1,-1,1].*chrpTimeVec);
disp(['Approximate signal length ',num2str(sigLen),' sec']);

%Generate positive DFT frequencies
dataLen = (nSmpls-1)/Fs;
kNyq = floor(nSmpls/2)+1;
posFreq = (0:(kNyq-1))/dataLen;

%Convert chirp times to alpha coefficients in the phase function
chrpAlphParams_prefac = pn2chirp_prefac_chtime2alph(fMin);

%Convert chirp times to alpha coefficients in the phase function
chrpAlphParams = pn2chirp_chtime2alph(chrpTimeVec,chrpAlphParams_prefac);

%Generate powers of frequency for the different terms in the phase function
%that will be multiplied by the alpha coefficients
[posFreqMat,fMinIndx,fMaxIndx] = pn2chirp_posfreqmat(dataLen, posFreq, fMin, fMax);

%Generate argument psi(f) of phase exp(-1i*psi(f))
%phaseFunc = pn2chirpfftphasefunc(posFreqMat, chrpAlphParams);
phaseArg = pn2chirpftphasearg(posFreqMat, chrpAlphParams);

%Generate signal DFT magnitude
magFunc = pnrstrctfftmag(posFreq,fMinIndx,fMaxIndx, winName);

%Generate signal DFT (two quadratures) for positive and negative frequencies 
%tmpltFFTMat = pnrstrctchirpfthchs(nSmpls,magFunc,phaseArg,-phi0);
tmpltFFTMat = pnrstrctchirpfthchs(nSmpls,magFunc,phaseArg);

%Inverse FFT and plot
%dataVec_sigVec = ifft(dataVec_fftSigVec(1,:));
% 
% figure;
% timeVec = (0:(dataVecWhtTF_full_nSmpls-1))/dataVec_fsmp;
% plot(timeVec,dataVec_sigVec);