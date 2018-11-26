function mu  = mu_func_2D(x, y)
%MU_FUNC_2D Summary of this function goes here
%   Detailed explanation goes here

xInd = x>-100;
yInd = y>-100;
mu(xInd, yInd) = 1;

xInd = x>=0.1 & x<0.4;
yInd = y>=0.2 & y<0.5;
mu(xInd, yInd) = 2;


xInd = x>=0.6 & x<0.9;
yInd = y>=0.6 & y<0.9;
mu(xInd, yInd) = 3;


end

