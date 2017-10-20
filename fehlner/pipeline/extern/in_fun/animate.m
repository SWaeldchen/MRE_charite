function SIG=animate(W,N,pm)
% SIG=animate(W,N,reverse_direction)
si=size(W);

if nargin < 2
    N = 16;
end


if nargin < 3
    pm=1;
else
    pm=-1;
end
SIG=reshape(W(:)*exp(pm*1i*linspace(2*pi/N,2*pi,N)),si(1),si(2),N);
