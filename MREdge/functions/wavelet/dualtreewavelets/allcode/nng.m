function y = nng(x,T)

 y = ( x - T^2 ./ conj(x) ) .* (abs(x) > T);
