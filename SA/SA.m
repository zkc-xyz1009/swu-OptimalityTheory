% SA ģ���˻�: ��⺯��y = 11*sin(x) + 7*cos(5*x)��[-3,3]�ڵ����ֵ(������ʾ��
tic
clear; clc

% ���ƺ�����ͼ��
% x = -3:0.1:3;
% y = 11*sin(x) + 7*cos(5*x);
% figure
% plot(x,y,'b-')
% hold on  % ���ر�ͼ�Σ����������滭ͼ

% ������ʼ��
narvs = 60; % ��������
T0 = 300;   % ��ʼ�¶�
T = T0; % �������¶Ȼᷢ���ı䣬��һ�ε���ʱ�¶Ⱦ���T0
maxgen = 5000;  % ����������
Lk = 10000;  % ÿ���¶��µĵ�������
alfa = 0.95;  % �¶�˥��ϵ��
xmin = -600; % x���½�
xmax = 600; % x���Ͻ�

%  �������һ����ʼ��
xinit = zeros(1,narvs);
for i = 1: narvs
    xinit(i) = xmin + (xmax-xmin)*rand();    
end
y0 = func4(xinit); % ���㵱ǰ��ĺ���ֵ

% h = scatter(xinit,y0,'*r');  % scatter�ǻ��ƶ�άɢ��ͼ�ĺ��������ﷵ��h��Ϊ�˵õ�ͼ�εľ����δ�����Ƕ���λ�ý��и��£�

% ����һЩ�����м���̵����������������ͻ�ͼ
min_y = y0;     % ��ʼ���ҵ�����ѵĽ��Ӧ�ĺ���ֵΪy0
MINY = zeros(maxgen,1); % ��¼ÿһ�����ѭ���������ҵ���miny (���㻭ͼ��

% ģ���˻����
for iter = 1 : maxgen  % ��ѭ��, ��������õ���ָ������������
    for i = 1 : Lk  % ��ѭ������ÿ���¶��¿�ʼ����
        y = randn(1,narvs);  % ����1��narvs�е�N(0,1)�����
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      z = y / sqrt(sum(y.^2)); % �����½�Ĳ����������z
        x_new = xinit + z*T; % �����½�Ĳ����������x_new��ֵ
        % �������½��λ�ó����˶����򣬾Ͷ�����е���
        for j = 1: narvs
            if x_new(j) < xmin
                r = rand();
                x_new(j) = r*xmin+(1-r)*xinit(j);
            elseif x_new(j) > xmax
                r = rand();
                x_new(j) = r*xmax+(1-r)*xinit(j);
            end
        end
        x1 = x_new;    % ���������x_new��ֵ���½�x1
        y1 = func4(x1);  % �����½�ĺ���ֵ
        if y1 < y0    % ����½⺯��ֵС�ڵ�ǰ��ĺ���ֵ
            xinit = x1; % ���µ�ǰ��Ϊ�½�
            y0 = y1;
        else%����ҵ��ȵ�ǰ����Ľ⣬��һ�����ʽ��ܸý⣬����������ʻ�Խ��ԽС
            p = exp(-(y0 - y1)/T); % ����Metropolis׼�����һ������(TԽ��pԽ��)
            if rand() < p   % ����һ���������������ʱȽϣ�����������С���������
                xinit = x1; % ���µ�ǰ��Ϊ�½�
                y0 = y1;
            end
        end
        % �ж��Ƿ�Ҫ�����ҵ�����ѵĽ�
        if y0 < min_y  % �����ǰ����ã��������и���
            min_y = y0;  % ��������y
            best_x = xinit;  % �����ҵ�����õ�x
        end
    end
    MINY(iter) = min_y; % ���汾����ѭ���������ҵ�������y
    T = alfa*T;   % �¶��½�
%     pause(0.01)  % ��ͣһ��ʱ��(��λ����)���ٽ��Ż�ͼ
%     h.XData = xinit;  % ����ɢ��ͼ�����x������ݣ���ʱ���λ����ͼ�Ϸ����˱仯��
%     h.YData = func3(xinit); % ����ɢ��ͼ�����y������ݣ���ʱ���λ����ͼ�Ϸ����˱仯��
end

disp('��ѵ�λ���ǣ�'); disp(best_x)
disp('��ʱ����ֵ�ǣ�'); disp(min_y)



% ����ÿ�ε������ҵ������y��ͼ��
figure
plot(1:maxgen,MINY,'b-');
xlabel('��������');
ylabel('y��ֵ');
title({['���ŵ�x1 = ', num2str(best_x(1)), ',���ŵ�x2 = ',num2str(best_x(2))],['��Сֵ = ',num2str(min_y)],'��Ӧ�Ƚ�������'})
toc