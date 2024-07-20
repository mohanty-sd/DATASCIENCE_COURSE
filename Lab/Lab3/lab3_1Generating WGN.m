% 生成具有不同参数的白噪声序列

% 设置样本数
nSamples = 10000;

% 1. 𝜇 = 0, 𝜎 = 1
mu1 = 0;
sigma1 = 1;
WGN1 = mu1 + sigma1 * randn(nSamples, 1);

% 2. 𝜇 = 0, 𝜎 = 2
mu2 = 0;
sigma2 = 2;
WGN2 = mu2 + sigma2 * randn(nSamples, 1);

% 3. 𝜇 = 0, 𝜎^2 = 2 （𝜎 = sqrt(2)）
mu3 = 0;
sigma3 = sqrt(2);
WGN3 = mu3 + sigma3 * randn(nSamples, 1);

% 4. 𝜇 = 2, 𝜎^2 = 2 （𝜎 = sqrt(2)）
mu4 = 2;
sigma4 = sqrt(2);
WGN4 = mu4 + sigma4 * randn(nSamples, 1);
% 使用 histogram 函数绘制每个序列的直方图

figure;
subplot(2,2,1);
histogram(WGN1, 'Normalization', 'pdf');
title('𝜇 = 0, 𝜎 = 1');
xlabel('Value');
ylabel('Probability Density');

subplot(2,2,2);
histogram(WGN2, 'Normalization', 'pdf');
title('𝜇 = 0, 𝜎 = 2');
xlabel('Value');
ylabel('Probability Density');

subplot(2,2,3);
histogram(WGN3, 'Normalization', 'pdf');
title('𝜇 = 0, 𝜎^2 = 2');
xlabel('Value');
ylabel('Probability Density');

subplot(2,2,4);
histogram(WGN4, 'Normalization', 'pdf');
title('𝜇 = 2, 𝜎^2 = 2');
xlabel('Value');
ylabel('Probability Density');
% 计算每个序列的样本均值和标准差

mean1 = mean(WGN1);
std1 = std(WGN1);

mean2 = mean(WGN2);
std2 = std(WGN2);

mean3 = mean(WGN3);
std3 = std(WGN3);

mean4 = mean(WGN4);
std4 = std(WGN4);

% 输出结果
disp('𝜇 = 0, 𝜎 = 1');
disp(['Sample Mean: ', num2str(mean1)]);
disp(['Sample Std Dev: ', num2str(std1)]);

disp('𝜇 = 0, 𝜎 = 2');
disp(['Sample Mean: ', num2str(mean2)]);
disp(['Sample Std Dev: ', num2str(std2)]);

disp('𝜇 = 0, 𝜎^2 = 2');
disp(['Sample Mean: ', num2str(mean3)]);
disp(['Sample Std Dev: ', num2str(std3)]);

disp('𝜇 = 2, 𝜎^2 = 2');
disp(['Sample Mean: ', num2str(mean4)]);
disp(['Sample Std Dev: ', num2str(std4)]);
