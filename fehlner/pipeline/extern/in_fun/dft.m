function c=dft(f)
% c=dft(f)
% discrete fourier transform
% c=1/N W f;
% see N. Hungerbühler "Einführung in Partielle Differentialgleichungen"
% p. 36
%

f=f(:);
N=length(f);
r=exp(-i*2*pi/N);
k=linspace(0,N-1,N)'*ones(1,N);
l=ones(N,1)*linspace(0,N-1,N);

W=r.^(k.*l);

c=1/N*W*f;