function Wf=filt_temp(w,N)
%
%
%

si=size(w);
w=w(:);

phi=linspace(0,2*pi*10,N);
W=w*exp(-i*phi);
%W=reshape(W,si(1),si(2),N);

Wf=fftshift(fft(W,[],2),2);