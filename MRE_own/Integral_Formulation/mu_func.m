function y = mu_func(x)

xInd = x>-100;
y(xInd) = 1;

xInd = x>=0.1 & x<0.2;
y(xInd) = 2;

xInd = x>=0.2 & x<0.3;
y(xInd) = 3;

xInd = x>=0.8 & x<0.9;
y(xInd) = 2;

for i = 0.4:0.02:0.6
    xInd = x>=i & x<=i+0.01;
    y(xInd) = 1.3;
end
