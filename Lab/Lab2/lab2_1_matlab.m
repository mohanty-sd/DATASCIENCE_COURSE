function [] = skyplot(alphaVec, deltaVec, fHandle)
    % skyplot(A,D,F) A是方位角向量，D是极角向量，F是一个函数句柄，表示需要在球面上
    % 绘制的函数
    
    % 生成由 alphaVec 和 deltaVec 组成的 2D 网格
    [A, D] = meshgrid(alphaVec, deltaVec);
    
    % X, Y, Z 分别表示单位球面上的点的坐标，使用极坐标转换为笛卡尔坐标
    X = sin(D) .* cos(A);
    Y = sin(D) .* sin(A);
    Z = cos(D);
    
    % 创建一个矩阵 fVals
    fVals = zeros(length(deltaVec), length(alphaVec));
    for lp1 = 1:length(alphaVec)
        for lp2 = 1:length(deltaVec)
            fVals(lp2, lp1) = fHandle(alphaVec(lp1), deltaVec(lp2));
        end
    end
    
    % 绘制图形
    surf(X, Y, Z, abs(fVals));
    shading interp;
end

% 设置两个方向角
alphaVec = 0:0.05:(2*pi);
deltaVec = 0:0.05:pi;

% 句柄函数的定义 1
fHandle1 = @(x, y) 0.5 * (1 + cos(y)^2) .* cos(2*x);

% 绘制第一幅图
figure;
skyplot(alphaVec, deltaVec, fHandle1);
title('Function 1: 0.5*(1 + cos(\delta)^2) * cos(2\alpha)');

% 句柄函数的定义 2
fHandle2 = @(x, y) 0.5 * sin(2*x) .* cos(y);

% 绘制第二幅图
figure;
skyplot(alphaVec, deltaVec, fHandle2);
title('Function 2: 0.5*sin(2\alpha) * cos(\delta)');