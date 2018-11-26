function y = mu(x)
if x <= -4
    y = 3;
elseif -4 < x & x <= -3
    y = -4*x - 13;
elseif -3 < x & x <= 0
    y = x^2 + 6*x + 8;
else
    y = 8;
end
    
if x == 5
    y = 33;
    
end