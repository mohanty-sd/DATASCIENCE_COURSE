function [result_signal] = AmFmGen(dataX, A, b, f0, f1)
%UNTITLED3 此处提供此函数的摘要
%   此处提供详细说明
original_signal = A*cos(2*pi*f1*dataX).*sin(2*pi*f0*dataX+ b*cos(2*pi*f1*dataX));
result_signal = original_signal/norm(original_signal);
end