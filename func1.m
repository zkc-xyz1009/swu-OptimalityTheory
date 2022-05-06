
function result = func1(x,y)
fit=0.5+(sin(sqrt(x^2+y^2)).^2-0.5)./((1+0.001.*(x^2+y^2))^2);
% fit = (((sin((x^2+y^2)^0.5))^2 - 0.5)./(1+0.001*(x^2+y^2))^2) + 0.5;
result = fit;
end
