function [C1 C2 C3]=curl_wrapped_2D(X,Y,Z,dx,dy)
%
% [C1 C2 C3]=curl_wrapped_2D(X,Y,dx,dy)
%


[XX XY]=gradient(exp(i*X),dx,dy);
[YX YY]=gradient(exp(i*Y),dx,dy);
[ZX ZY]=gradient(exp(i*Z),dx,dy);

C1= imag(exp(-i*Z).*ZY);
C2=-imag(exp(-i*Z).*ZX);
C3=imag(exp(-i*Y).*YX)-imag(exp(-i*X).*XY);