function sigVec = otherDTS_1(dataX,snr,tau,qcCoefs)
phaseVec = qcCoefs(1)*dataX;
sigVec = exp(-abs(dataX)/tau).*cos(2*pi*phaseVec);
sigVec = snr*sigVec/norm(sigVec);