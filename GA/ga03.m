clear all;
close all;
clc;
 



iter_max = 5000;     %迭代次数
Pc = 0.9;    %交叉
Pm = 0.1;   %变异
num_g = 500;     %种群规模
dim=2;%维度
len = 16;
xmax=2.048;
xmin=-2.048;
%显示图像
X=[ -10:0.1 : 10 ];
Y =[ -10 :0.1 : 10 ];
[m,n] = meshgrid(X,Y);
[row,col] = size(n);
for  l = 1 :col
     for  h = 1 :row
        z(h,l) = func3([m(h,l),n(h,l)]);
    end
end
mesh(m,n,z)

 
 
 
%产生初始种群
f = rand(num_g,len*dim);%100行16列（0，1）
f = round(f);%（0，1
%迭代      
for iter = 1:iter_max%每一代
    %将二进制转化为十进制数并计算适应度值
    for i = 1:num_g%一代的每一个个体
        for j=1:dim%y一个个体的维度
            y(j)=0;
            for k=1:len%一个维度的大小转为10进制
                y(j)=y(j)+f(i,j*len-k+1)*2^(k-1);
%                 y(j)=y(j)+f(i,(j-1)*len+k)*2^(k*(j-1)-1);
            end
            x(j)=xmin+(xmax-xmin)*y(j)/(2^len);%转为范围内十进制
        end
        Fit(i) = func3(x);
    end
    Fit
    maxFit = max(Fit);
    minFit = min(Fit);
    minFit
    loc= find(Fit==minFit);
    fBest = f(loc,:)
    Fit = (Fit-minFit)/(maxFit-minFit);

   
    %选择操作
    sum_Fit = sum(Fit);
    fitvalue = Fit./sum_Fit;%每个个体进入下一代的概率等于它的适应度值与整个种群中个体适应度值和的比例.
    fitvalue = cumsum(fitvalue);%1行100列
%     [x,y]=size(fitvalue);
    ms = sort(rand(1,num_g));
%     [m,n]=size(ms);
    fiti = 1;
    newi = 1;
    while newi<=num_g
      if ms(newi)<fitvalue(fiti)
          nf(newi,:) = f(fiti,:);%给新的
          newi = newi+1;
      else
          fiti = fiti+1;
      end
   end   
%     while newi<=num_g
%        if ms(newi)<fitvalue(fiti)
%            nf(newi,:) = f(fiti,:);%给新的
%            newi = newi+1;
%        else
%            fiti = fiti+1;
%        end
%     end     
    
    %交叉
    for i = 1:2:num_g       %遍历种群，i = 1,3,5.....NP
        if rand< Pc        %判断随机数p是否小于交叉概率
            q = randi(1,len*dim);      %产生一个1行D列的矩阵q，q中的每个元素为0或1
            for j = 1:len*dim
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
        for j = 1:len*dim
            if rand<Pm          %如果p小于变异概率，则进行变异
                nf(i,j) = ~nf(i,j);    %%第i个染色体的第j位取反
            end
        end
    end
    
   
    f = nf;
    f(1,:) = fBest;       
    trace(iter) = minFit;
end

for j=1:dim%y一个个体的维度
    y(j)=0;
    for k=1:len%一个维度的大小转为10进制
        y(j)=y(j)+f(i,j*len-k+1)*2^(k-1);
%         y(j)=y(j)+(fBest(1,(j-1)*len+k))*2^(k*(j-1)-1);
    end
    x(j)=xmin+(xmax-xmin)*y(j)/(2^(len));%转为范围内十进制
end
 figure

plot(trace);
xlabel('迭代次数')
ylabel('目标函数值')
% title({['最优的x1 = ', num2str(x(1)), ',最优的x2 = ',num2str(x(2))],['最小值 = ',num2str(minFit)],'适应度进化曲线'})
title({['最小值 = ',num2str(minFit)],[num2str(minFit)],'适应度进化曲线'})