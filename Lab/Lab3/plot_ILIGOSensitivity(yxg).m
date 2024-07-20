filename = 'iLIGOSensitivity.txt';  % 替换为你的数据文件路径
data = importdata(filename);


x=data(:, 1);
y=data(:, 2);

% 绘制图像
figure;
plot(x, y, 'bo', 'MarkerSize', 5);
set(gca, 'YScale', 'log');  % 设置纵轴刻度为对数尺度
ylabel('$\sqrt{S_n(f)}$', 'Interpreter', 'latex');
xlabel('Frequency(Hz)');
%title('示例图像');
grid on;


xlim([0, 10000]);  
ylim([10^(-25), 10^5]); 


g(f > 700) = y(f=700);
g(f < 700) = y(f<700);
g(f < 50) = y(f=50);
g(f > 700) = y(f=700);
figure;
plot(x, g, 'bo', 'MarkerSize', 5);
set(gca, 'YScale', 'log');  % 设置纵轴刻度为对数尺度
ylabel('$\sqrt{S_n(f)}$', 'Interpreter', 'latex');
xlabel('Frequency(Hz)');
%title('示例图像');
grid on;


xlim([0, 10000]);  
glim([10^(-25), 10^5]);