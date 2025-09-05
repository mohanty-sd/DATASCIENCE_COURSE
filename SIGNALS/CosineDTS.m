function sigVec = CosineDTS(dataX,snr,qcCoefs)
phaseVec = qcCoefs(1)*dataX
sigVec = cos(2*pi*phaseVec);
sigVec = snr*sigVec/norm(sigVec);