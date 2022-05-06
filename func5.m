function result = func5(X)
%X要是1行N列
[row,col]=size(X);
if row>1
    error('输入的参数错误');
end
for i=1:col-1
    y=sum(100*(X(i)^2-X(i+1))^2+(X(i)-1)^2);
end
result=y;

end