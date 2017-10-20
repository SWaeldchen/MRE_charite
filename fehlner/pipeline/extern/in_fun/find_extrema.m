function [x2, y2]=find_extrema(x, y)



%extrema=find(diff(sign(gradient(y))));
extrema=find(diff(sign(diff(y))));

x2=x(extrema+1);
y2=y(extrema+1);



