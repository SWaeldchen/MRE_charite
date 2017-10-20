function G=gauss2D(si,T2,pot)
%
% G=gauss2D(si,T2)
%


if nargin < 3
    pot = 2;
end

[TH, R]=cart2pol(linspace(-1,1,si)'*ones(1,si),ones(si,1)*linspace(-1,1,si));
G=exp(-(R/T2).^pot);