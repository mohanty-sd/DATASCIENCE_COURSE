function sigVec = otherDTS_2(dataX,snr,sigma,mu,coefs)
phaseVec = coefs(1)*dataX + coefs(2)*dataX.^2 + coefs(3)*dataX.^3;
sigVec = exp(-(dataX-mu).^2/(2*sigma^2)).*sin(2*pi*phaseVec);
sigVec = snr*sigVec/norm(sigVec);