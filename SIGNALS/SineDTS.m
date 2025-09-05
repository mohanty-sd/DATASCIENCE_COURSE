function sigVec = SineDTS(dataX,snr,qcCoefs)
phaseVec = qcCoefs(1)*dataX
sigVec = sin(2*pi*phaseVec);
sigVec = snr*sigVec/norm(sigVec);