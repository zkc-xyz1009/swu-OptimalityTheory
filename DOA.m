

function DOA()
 
 
popsize=5;    % 种群规模
Iteration=500;     % 迭代次数
xmin = -5.12;     
xmax = 5.12; 
dim = 60;  % 维度
 
P= 0.9;  % 猎杀
Q= 0.9;  % 围攻追捕?
beta1= -2 + 4* rand();  % -2 < beta < 2     
beta2= -1 + 2* rand();  % -1 < beta2 < 1    
naIni= 2; % minimum number of dingoes that will attack
naEnd= popsize /naIni; % maximum number of dingoes that will attack
na= round(naIni + (naEnd-naIni) * rand()); % number of dingoes that will attack
 
%初始化
Positions=xmin + (xmax - xmin).*rand(popsize, dim);

for i=1:size(Positions,1)
    Fitness(i)=func5(Positions(i,:)); 
end
[best_score, minIdx]= min(Fitness);  
best_x= Positions(minIdx,:); 
[worst_score, ~]= max(Fitness);
curve=zeros(1,Iteration);
 
%计算生存率
for i=1:size(Fitness,2)
    survival(i)= (worst_score-Fitness(i))/(worst_score - best_score);
end
 
%开始迭代
for t=1:Iteration
    for r=1:popsize%每只狗
        if rand() < P  % 猎杀时刻
            sumatory=0;
            c=1;
            vAttack=[];
            while(c<=na)
                idx =round( 1+ (popsize-1) * rand());%idx号狗
 
                band= 0;
                for i=1:size(vAttack, 2)
                    if idx== vAttack(i)
                        band=1;
                        break;
                    end
 
                end
 
                if ~band
                    vAttack(c) = idx;
                    c=c+1;
                end
            end
 
            for j=1:size(vAttack,2)
                sumatory= sumatory + Positions(vAttack(j),:)- Positions(r,:);
            end
            sumatory=sumatory/na;
 
            if rand() < Q  % 群体攻击
                v(r,:)=  beta1 * sumatory-best_x; 
            else  %  追捕
                r1= round(1+ (popsize-1)* rand()); 
                v(r,:)= best_x + beta1*(exp(beta2))*((Positions(r1,:)-Positions(r,:))); % 
            end
        else % 食府
            r1= round(1+ (popsize-1)* rand());
            if rand() < 0.5
                val= 0;
            else
                val=1;
            end
 
            v(r,:)=   (exp(beta2)* Positions(r1,:)-((-1)^val)*Positions(r,:))/2; % 
        end
        if survival(r) <= 0.9999  % 生存行为
            band=1;
            while band
                r1= round(1+ (popsize-1)* rand());
                r2= round(1+ (popsize-1)* rand());
                if r1 ~= r2
                    band=0;
                end
            end
            if rand() < 0.5
                val= 0;
            else
                val=1;
            end
            v(r,:)=   best_x + (Positions(r1,:)-((-1)^val)*Positions(r2,:))/2; 
        end
        %限制范围
        for j=1:dim
			if v(r,j)>xmax
				v(r,j)=xmax;
			elseif v(r,j)<-xmax
				v(r,j)=-xmax;
            end
        end
        
        Fnew= func5(v(r,:));
        
        if Fnew <= Fitness(r)
            Positions(r,:)= v(r,:);
            Fitness(r)= Fnew;
        end
        if Fnew <= best_score
            best_x= v(r,:);
            best_score= Fnew;
        end
    end
    curve(t)= best_score;
    [worst_score, ~]= max(Fitness);
    for i=1:size(Fitness,2)
        survival(i)= (worst_score-Fitness(i))/(worst_score - best_score);
    end
 
end
 
 

 
figure
plot(curve)
title('收敛曲线')
title(['最小值', num2str(best_score)])
xlabel('迭代次数');
ylabel('最佳适应度');
% axis tight
legend('DOA')
 
 
display(['最优解 ', num2str(best_x)]);
display(['最小值', num2str(best_score)]);
 
end