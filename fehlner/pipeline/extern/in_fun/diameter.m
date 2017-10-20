function r=diameter
%  length of a line selected by two clicks




[x1,y1]=ginput(1);
hold on
plot(x1,y1,'om');
[x1r,y1r]=ginput(1);

r=sqrt((x1-x1r)^2+(y1-y1r)^2);
