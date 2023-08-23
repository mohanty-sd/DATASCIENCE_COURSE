function mfltOutVec = mfltr(dataVec_fft,dataVecWhtTF,Fs,sigParams)
% Matched filtering for restricted 2PN inspiral signal
%O = MFLTR(Y, W, Fs, P)
%O is the matched filter output = sqrt(<d,q_0>^2 + <d,q_1>^2) where 'd' is
%the data time series and q_{0,1} is a quadrature template. Y is the FFT of
%the data, W is the whitening transfer function used for both positive and
%negative frequencies, Fs is the sampling frequency of the time series of
%Y, and P is a structure containing the template parameters. The fields of
%P are as given in the following example.
%   S.mass1 = 1.4; %Solar masses
%   S.mass2 = 1.4; %Solar masses
%   %Low frequency cutoff 
%   S.fMin = 35;%Hz
%   %Plunge cutoff
%   S.fMax = 700;%Hz
%   %Optional window in frequency domain (e.g. @bartlett)
%   S.winName = '';%@tukeywin;

%Soumya D. Mohanty, Mar 2023

%Complete negative frequencies in the transfer function
nSmpls = length(dataVec_fft);
dataVec_fft = reshape(dataVec_fft, [1, nSmpls]); %Ensure row vector
dataVecWhtTFFull = zeros(1, nSmpls);
dataVecWhtTF_nSmpls = length(dataVecWhtTF);
dataVecWhtTFFull(1:dataVecWhtTF_nSmpls) = dataVecWhtTF;
negFreqNsmpls = nSmpls - dataVecWhtTF_nSmpls;
dataVecWhtTFFull(end:-1:(end-negFreqNsmpls+1)) = dataVecWhtTF(2:(negFreqNsmpls+1));

%Get Fourier domain quadrature templates 
tmpltMat  = rstrct2pntmplt(nSmpls,Fs,sigParams);

%Whiten and normalize the templates.
%1/nSmpls needed in normalization because of the 1/N in inverse DFT:
%This makes sum(DFT[x].^2/N) = sum(x.^2)
tmpltMat(1,:) = tmpltMat(1,:).*dataVecWhtTFFull;
tmpltMat(2,:) = tmpltMat(2,:).*dataVecWhtTFFull;
tmpltMat(1,:) = tmpltMat(1,:)/sqrt(sum(tmpltMat(1,:)*tmpltMat(1,:)')/nSmpls);
tmpltMat(2,:) = tmpltMat(2,:)/sqrt(sum(tmpltMat(2,:)*tmpltMat(2,:)')/nSmpls);

%Get quadrature filtered outputs
mfltr_1 = ifft(dataVec_fft.*conj(tmpltMat(1,:)));
mfltr_2 = ifft(dataVec_fft.*conj(tmpltMat(2,:)));
mfltOutVec = sqrt(mfltr_1.^2 + mfltr_2.^2);
