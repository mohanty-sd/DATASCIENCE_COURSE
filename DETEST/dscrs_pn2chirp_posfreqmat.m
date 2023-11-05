function [freqMat,varargout] = dscrs_pn2chirp_posfreqmat(dataLen, posFreq, fMin, fMax)
%M = DSCRS__PN2CHIRP_POSFREQMAT(L,F,Fmin,Fmax)
%Generate the powers of normalized positive frequencies, F(k)/Fmin, required
%in the computation of the 2PN phase function (for zero time of arrival). F
%the vector of positive DFT frequencies.
%    M(j,k) = (F(k)/Fmin).^((-5+I(j))/3), for Fmin <= F(k) <= Fmax,
%where I is the index set [0,2,3,4]. For all other elements M(j,k)=0.
%
%[M,Il,Iu] = PN2CHIRP_POSFREQMAT(L,F,Fmin,Fmax)
%Returns the indices of Fmin and Fmax in Il and Iu.

%Soumya D. Mohanty, Nov'22
%Nov 5, 2023: Added the token 'dscrs_' to the function name as it was
%conflicting with the same function in MATLABCODES/signals. We are using a
%copy of the latter in DATASCIENCE_COURSE in order to not expose the
%private MATLABCODES when sharing DATASCIENCE_COURSE in the GW data
%analysis schools.

minCutIndx = ceil(fMin*dataLen);
maxCutIndx = floor(fMax*dataLen);
kNyq = length(posFreq);
freqMat = zeros(5,kNyq);
%Frequency vector powers (see Overleaf:"BINARIES User Manual /
%MathNote.tex")
indxSet = [0,2,3,4,8];
normPosFreq = zeros(1,kNyq);
normPosFreq(minCutIndx:maxCutIndx) = posFreq(minCutIndx:maxCutIndx)/fMin;
for lp = 1:4
    freqPwr = (-5+indxSet(lp))/3;
    freqMat(lp,minCutIndx:maxCutIndx) = normPosFreq(minCutIndx:maxCutIndx).^freqPwr;
end
%This is the frequency series for the term containing the linear
%combination of chirp times
freqMat(5,minCutIndx:maxCutIndx) = normPosFreq(minCutIndx:maxCutIndx);

if nargout > 1
    varargout{1} = minCutIndx;
    if nargout > 2
        varargout{2} = maxCutIndx;
    end
end

