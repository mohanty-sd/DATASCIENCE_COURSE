function sigVec = LinearChirpDTS(dataX,snr,qcCoefs)
phaseVec = qcCoefs(1)*dataX + qcCoefs(2)*dataX.^2;
sigVec = sin(2*pi*phaseVec);
sigVec = snr*sigVec/norm(sigVec); 