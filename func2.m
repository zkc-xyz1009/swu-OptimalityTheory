function result = func2(x)
x1=0;
x2=0;
for i=1:5
    x1=x1+i*cos((i+1)*x(1)+i);
    x2=x2+i*cos((i+1)*x(2)+i);
end
fit=x1*x2;
result =fit;
end
