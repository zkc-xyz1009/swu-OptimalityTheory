% SA 模拟退火: 求解函数y = 11*sin(x) + 7*cos(5*x)在[-3,3]内的最大值(动画演示）
tic
clear; clc

% 绘制函数的图形
% x = -3:0.1:3;
% y = 11*sin(x) + 7*cos(5*x);
% figure
% plot(x,y,'b-')
% hold on  % 不关闭图形，继续在上面画图

% 参数初始化
narvs = 60; % 变量个数
T0 = 300;   % 初始温度
T = T0; % 迭代中温度会发生改变，第一次迭代时温度就是T0
maxgen = 5000;  % 最大迭代次数
Lk = 10000;  % 每个温度下的迭代次数
alfa = 0.95;  % 温度衰减系数
xmin = -600; % x的下界
xmax = 600; % x的上界

%  随机生成一个初始解
xinit = zeros(1,narvs);
for i = 1: narvs
    xinit(i) = xmin + (xmax-xmin)*rand();    
end
y0 = func4(xinit); % 计算当前解的函数值

% h = scatter(xinit,y0,'*r');  % scatter是绘制二维散点图的函数（这里返回h是为了得到图形的句柄，未来我们对其位置进行更新）

% 定义一些保存中间过程的量，方便输出结果和画图
min_y = y0;     % 初始化找到的最佳的解对应的函数值为y0
MINY = zeros(maxgen,1); % 记录每一次外层循环结束后找到的miny (方便画图）

% 模拟退火过程
for iter = 1 : maxgen  % 外循环, 我这里采用的是指定最大迭代次数
    for i = 1 : Lk  % 内循环，在每个温度下开始迭代
        y = randn(1,narvs);  % 生成1行narvs列的N(0,1)随机数
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      z = y / sqrt(sum(y.^2)); % 根据新解的产生规则计算z
        x_new = xinit + z*T; % 根据新解的产生规则计算x_new的值
        % 如果这个新解的位置超出了定义域，就对其进行调整
        for j = 1: narvs
            if x_new(j) < xmin
                r = rand();
                x_new(j) = r*xmin+(1-r)*xinit(j);
            elseif x_new(j) > xmax
                r = rand();
                x_new(j) = r*xmax+(1-r)*xinit(j);
            end
        end
        x1 = x_new;    % 将调整后的x_new赋值给新解x1
        y1 = func4(x1);  % 计算新解的函数值
        if y1 < y0    % 如果新解函数值小于当前解的函数值
            xinit = x1; % 更新当前解为新解
            y0 = y1;
        else%如果找到比当前更差的解，以一定概率接受该解，并且这个概率会越来越小
            p = exp(-(y0 - y1)/T); % 根据Metropolis准则计算一个概率(T越大，p越大)
            if rand() < p   % 生成一个随机数和这个概率比较，如果该随机数小于这个概率
                xinit = x1; % 更新当前解为新解
                y0 = y1;
            end
        end
        % 判断是否要更新找到的最佳的解
        if y0 < min_y  % 如果当前解更好，则对其进行更新
            min_y = y0;  % 更新最大的y
            best_x = xinit;  % 更新找到的最好的x
        end
    end
    MINY(iter) = min_y; % 保存本轮外循环结束后找到的最大的y
    T = alfa*T;   % 温度下降
%     pause(0.01)  % 暂停一段时间(单位：秒)后再接着画图
%     h.XData = xinit;  % 更新散点图句柄的x轴的数据（此时解的位置在图上发生了变化）
%     h.YData = func3(xinit); % 更新散点图句柄的y轴的数据（此时解的位置在图上发生了变化）
end

disp('最佳的位置是：'); disp(best_x)
disp('此时最优值是：'); disp(min_y)



% 画出每次迭代后找到的最大y的图形
figure
plot(1:maxgen,MINY,'b-');
xlabel('迭代次数');
ylabel('y的值');
title({['最优的x1 = ', num2str(best_x(1)), ',最优的x2 = ',num2str(best_x(2))],['最小值 = ',num2str(min_y)],'适应度进化曲线'})
toc
