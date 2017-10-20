function A=A_ellipse
%  A of an ellipse selected by two clicks




[x1,y1]=ginput(1);
hold on
plot(x1,y1,'om');
[x1r,y1r]=ginput(1);
plot([x1, x1r],[y1 y1r],'m')
r1=sqrt((x1-x1r)^2+(y1-y1r)^2)/2;
[x1,y1]=ginput(1);
hold on
plot(x1,y1,'or');
[x1r,y1r]=ginput(1);
plot([x1, x1r],[y1 y1r],'r')
r2=sqrt((x1-x1r)^2+(y1-y1r)^2)/2;
A=pi*r1*r2;