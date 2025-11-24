function [result_signal] = AmFmGen(dataX, A, b, f0, f1)
original_signal = A*cos(2*pi*f1*dataX).*sin(2*pi*f0*dataX+ b*cos(2*pi*f1*dataX));
result_signal = original_signal/norm(original_signal);
end