function y = simple_mu_func(x)

xInd = x>-100;
y(xInd) = 1;

xInd = x>=0.5;
y(xInd) = 3;
