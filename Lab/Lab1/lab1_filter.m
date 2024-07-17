% 生成合成信号
fs = 1024;  % 采样频率
t = (0:2047) / fs;  % 时间向量

f1 = 100;            % 正弦波1的频率     
phi1 = 0;            % 正弦波1的相位
f2 = 200;            % 正弦波2的频率
phi2 = pi/6*180;     % 正弦波2的相位
f3 = 300;            % 正弦波3的频率
phi3 = pi/4*180;     % 正弦波3的相位
signal1 = sin(2*pi*f1*t + phi1);   % 正弦波1
signal2 = sin(2*pi*f2*t + phi2);   % 正弦波2
signal3 = sin(2*pi*f3*t + phi3);   % 正弦波3

n=48;  % order 阶数

combined_signal = signal1 + signal2 + signal3;  % 合成信号

% 归一化合成信号
combined_signal = combined_signal / max(abs(combined_signal));

% 设计并应用滤波器，并显示周期图
figure;

% 输入信号的周期图
subplot(4, 1, 1);
periodogram(signal1, [], [], fs);
title('正弦波1的周期图');

subplot(4, 1, 2);
periodogram(signal2, [], [], fs);
title('正弦波2的周期图');

subplot(4, 1, 3);
periodogram(signal3, [], [], fs);
title('正弦波3的周期图');

subplot(4, 1, 4);
periodogram(combined_signal, [], [], fs);
title('合成信号的周期图');

% 设计并应用滤波器，显示经过滤波后的周期图
figure;

% 滤波器1：通过正弦波1
lowpass_filter1 = fir1(n, f1/(fs/2), 'low');
filtered_signal1 = filter(lowpass_filter1, 1, combined_signal);

lowpass_filter1_ = fir1(n, f1/(fs/2), 'high');
filtered_signal1 = filter(lowpass_filter1_, 1, filtered_signal1);
% 归一化滤波后的信号
filtered_signal1 = filtered_signal1 / max(abs(filtered_signal1));

subplot(3, 1, 1);
periodogram(signal1, [], [], fs);
title('正弦波1的周期图');

subplot(3, 1, 2);
periodogram(combined_signal, [], [], fs);
title('合成信号的周期图');

subplot(3, 1, 3);
periodogram(filtered_signal1, [], [], fs);
title('经过滤波器1处理后的周期图');

% 滤波器2：通过正弦波2
lowpass_filter2 = fir1(n, f2/(fs/2), 'low');
filtered_signal2 = filter(lowpass_filter2, 1, combined_signal);

lowpass_filter2_ = fir1(n, f2/(fs/2), 'high');
filtered_signal2 = filter(lowpass_filter2_, 1, filtered_signal2);
% 归一化滤波后的信号
filtered_signal2 = filtered_signal2 / max(abs(filtered_signal2));

figure;
subplot(3, 1, 1);
periodogram(signal2, [], [], fs);
title('正弦波2的周期图');

subplot(3, 1, 2);
periodogram(combined_signal, [], [], fs);
title('合成信号的周期图');

subplot(3, 1, 3);
periodogram(filtered_signal2, [], [], fs);
title('经过滤波器2处理后的周期图');

% 滤波器3：通过正弦波3
lowpass_filter3 = fir1(n, f3/(fs/2), 'low');
filtered_signal3 = filter(lowpass_filter3, 1, combined_signal);

lowpass_filter3_ = fir1(n, f3/(fs/2), 'high');
filtered_signal3 = filter(lowpass_filter3_, 1, filtered_signal3);
% 归一化滤波后的信号
filtered_signal3 = filtered_signal3 / max(abs(filtered_signal3));

figure;
subplot(3, 1, 1);
periodogram(signal3, [], [], fs);
title('正弦波3的周期图');

subplot(3, 1, 2);
periodogram(combined_signal, [], [], fs);
title('合成信号的周期图');

subplot(3, 1, 3);
periodogram(filtered_signal3, [], [], fs);
title('经过滤波器3处理后的周期图');

