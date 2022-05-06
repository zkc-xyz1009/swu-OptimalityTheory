function result = func2(x,y)
x1=0;
x2=0;
for i=1:5
    x1=x1+i*cos((i+1)*x+i);
    x2=x2+i*cos((i+1)*y+i);
end
fit=x1*x2;
result =fit;
end