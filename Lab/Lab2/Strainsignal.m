function sigVec = genqcsig(dataX,snr,f)
%计算相位
phaseVec = f*dataX;
sigVec = sin(2*pi*phaseVec);
sigVec = snr*sin(2*pi*phaseVec);
end

function sigVec2 = genqcsig2(dataX,snr,f)
%计算相位
phaseVec = f*dataX+(pi/4);
sigVec2 = snr*sin(2*pi*f*dataX+(pi/4));
end

%signal parameter
f=10;
A=10;
maxFreq = f;
nyqFreq = 2*f;

%采样频率
samplFreq = 5*nyqFreq;
%采样间隔
samplInterv = 1/samplFreq;
%时间向量
timeVec = 0:samplInterv:1;
%产生的信号
sigVec = genqcsig(timeVec,A,f);
%画出信号图
figure;
plot(timeVec,sigVec,'marker','.','MarkerSize',24);
xlabel('Time(sec)');
title('hplus signal');

phi = pi/4;
sigVec2 = genqcsig2(timeVec,A,f);
figure;
plot(timeVec,sigVec2,'marker','.','MarkerSize',24);
xlabel('Time(sec)');
title('hcross signal');
