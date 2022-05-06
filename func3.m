function result = func3(X)
%X要是1行N列
[row,col]=size(X);
if row>1
    error('输入的参数错误');
end
y1=1/4000*sum(X.^2);
y2=1;
for h=1:col
    y2=y2*cos(X(h)/sqrt(h));
end
y=y1-y2+1;
result=y;                                                                                                                                                                          
end
