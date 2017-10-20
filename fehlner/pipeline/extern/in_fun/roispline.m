function roispline

[BW x y]=roipoly;
Y=[x(:)';y(:)'];
X=1:size(Y,2);
pp=spline(X,Y);
YY = ppval(pp, linspace(1,X(end),101));
hold on

plot(YY(1,:),YY(2,:));
