function y = nng(x,T)

y = ( x - T^2 ./ x ) .* (abs(x) > T);    
