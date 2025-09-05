function sigVec= PureExpDecayDTS(dataX,snr,tau)
sigVec = exp(-dataX/tau);
sigVec = snr*sigVec/norm(sigVec);