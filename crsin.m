function sigVec = crsin(timeVec, A, f0, c0)
    % timeVec: 时间向量，表示信号的时间轴
    % A: 振幅
    % f0: 初始频率
    % c0: 初始相位

    % 生成正弦信号
    sigVec = A * sin(2 * pi * f0 * timeVec + c0);
end