function sigVec = GaussianDTS(dataX,snr,sigma,mu)
sigVec = exp(-(dataX-mu).^2/(2*sigma^2));
sigVec = snr*sigVec/norm(sigVec);