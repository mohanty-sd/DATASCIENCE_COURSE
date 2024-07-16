function [result_signal] = qcgensig(dataX, snr, coef)
%UNTITLED3 此处提供此函数的摘要
%   此处提供详细说明
phi = coef(1)*dataX + coef(2)*(dataX.^2) + coef(3)*(dataX.^2);
original_signal = sin(phi*2*pi);
result_signal = snr*original_signal/norm(original_signal);
end