function sigVec = SinExpDecayDTS(dataX,snr,tau,qcCoefs)
phaseVec = qcCoefs(1)*dataX;
sigVec = exp(-dataX/tau).*sin(2*pi*phaseVec);
% For exponential growth, replace - with + in exp(-dataX/tau).
sigVec = snr*sigVec/norm(sigVec);