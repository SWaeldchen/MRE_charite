function mretest(f0,T2,amp,freq)
%
% mretest(f0,T2,amp,freq)
%


x=linspace(0,10,1000);
damp=exp(-x/T2);
x=linspace(0,2*pi,1000);

y=cos(x*f0).*damp;

subplot(2,2,1);
plot(x,y);
title(['FID ' num2str(T2) 'ms']);


fy=fftshift(fft(y));
fx=linspace(-5,5,1000);
subplot(2,2,2)
plot(fx,abs(fy));
title(['SPC ' num2str(T2) 'ms']);

osci=cos(x * freq);
osci_y=cos((x * f0) + osci ).*damp;

subplot(2,2,3)
plot(x,osci_y)
title(['FID ' num2str(T2) 'ms amp: ' num2str(amp) ' freq: ' num2str(freq)]);


fosci_y=fftshift(fft(osci_y));

subplot(2,2,4)
plot(fx,abs(fosci_y));
title(['SPC ' num2str(T2) 'ms amp: ' num2str(amp) ' freq: ' num2str(freq)]);

