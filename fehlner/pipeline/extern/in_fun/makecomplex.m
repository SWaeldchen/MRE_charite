function Wc=makecomplex(W)
% Wc=makecomplex(W)
% makes complex wave image from real one
%

fW=fft(W,[],1);
fW(1:ceil(size(W,1)/2),:)=0;
Wc=ifft(fW);
