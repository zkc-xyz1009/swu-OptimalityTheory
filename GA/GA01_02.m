clear all;
close all;
clc;
 
%显示函数
x=-10:0.01:10;
y=-10:0.01:10;
N=size(x,2);
for i =1:N
    for j=1:N
        z(i,j)=func2(x(i),y(j));
    end
end
mesh(x,y,z)


iter_max = 10000;     %迭代次数
Pc = 0.8;    
Pm = 0.1;
num_g = 100;     %种群规模
len = 20;    %染色体长度(2*8,1(正负)+7（绝对值）)

xmax=10;
xmin=-10;
precision=(xmax-xmin)/(2^10);
% precision=1;
 
%产生初始种群
f = rand(num_g,len);%100行16列（0，1）
f = round(f);
%迭代      
for iter = 1:iter_max
    
    %将二进制转化为十进制数并计算适应度值
    for i = 1:num_g
        U = f(i,:);%i行所有值
        m1 = 0;
        m2 = 0;
        for j = 1:(len/2-1)
            m1 = (U(j)*2^(j-1))*precision+m1;
        end
        if U(len/2) == 1
            m1 = -m1;
        end
        x(i) = m1; 
        
        for j = (len/2+1):(len-1)
            m2 = (U(j)*2^(j-11))*precision+m2;
        end
        if U(len) == 1
            m2 = -m2;
        end
        y(i) = m2;
        
        Fit(i) = func2(x(i),y(i));
    end
  
        
    maxFit = max(Fit);
    minFit = min(Fit);
    loc= find(Fit==minFit);
    loc
    fBest = f(loc(1,1),:);
    xBest = x(loc(1,1));
    yBest = y(loc(1,1));
    Fit = (Fit-minFit)/(maxFit-minFit);
   
    %选择操作
    sum_Fit = sum(Fit);
    fitvalue = Fit./sum_Fit;%每个个体进入下一代的概率等于它的适应度值与整个种群中个体适应度值和的比例.
    fitvalue = cumsum(fitvalue);
    ms = sort(rand(num_g,1));
    fiti = 1;
    newi = 1;
    while newi<=num_g
        if (ms(newi))<fitvalue(fiti)%适应大
            nf(newi,:) = f(fiti,:);%给新的
            newi = newi+1;
        else
            fiti = fiti+1;
        end
    end     
    
    %交叉
    for i = 1:2:num_g       %遍历种群，i = 1,3,5.....NP
        if rand< Pc        %判断随机数p是否小于交叉概率
            q = randi(1,len);      %产生一个1行D列的矩阵q，q中的每个元素为0或1
            for j = 1:len
                if q(j) == 1     %遍历q中第j个元素，如果q(j)=1,就把种群中第i个染色体的第j位与第i+1个染色体第j位进行交换
                   %交叉操作
                    temp = nf(i+1,j);
                    nf(i+1,j) = nf(i,j);
                    nf(i,j) = temp;       
                end
            end
        end
    end
    
    %变异
    for i = 1:num_g
        for j = 1:len
            if rand<Pm          %如果p小于变异概率，则进行变异
                nf(i,j) = ~nf(i,j);    %%第i个染色体的第j位取反
            end
        end
    end
    
   
    f = nf;
    f(1,:) = fBest;
    
    %%Fit(i) = 10/(Fit(i)+10);
    %%maxFit = 10/maxFit-10;
    
    %%trace(gen) = maxFit;
    trace(iter) = minFit;
    
end

figure

plot(trace);
xlabel('迭代次数')
ylabel('目标函数值')
title({['最优的x1 = ', num2str(xBest), ',最优的x2 = ',num2str(yBest)],['最小值 = ',num2str(minFit)],'适应度进化曲线'})