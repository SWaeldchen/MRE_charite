function testlfe(points, gamma, cf1,cf2)
%
% testlfe(points, gamma, cf1,cf2)
%

if nargin < 4
   help testlfe;
   points=256;
   gamma=8;
   cf1=4;
   cf2=16;
end


a=findobj(0,'tag','testlfe');
close(a);

figure('name', ['lfe ' num2str(points) ' ' num2str(gamma) ' ' num2str(cf1) ' ' num2str(cf2)] ,...
   'numbertitle','off','tag','testlfe');
subplot(2,2,1);

x=linspace(0,2*pi*gamma,points);
y=sin(x);

plot(y);

subplot(2,2,2);

freq=fftshift(fft(y));
if ~odd(points)
   f=-points/2:1:points/2-1;
else
   f=-(points-1)/2:1:(points-1)/2;
   end
   
freq(1:find(f == 0))=0;
f(find(f == 0))=0.00001;
%f(1:find(f == 0))=0;

plot(f,abs(freq));

subplot(2,2,3);

fac=cf2/cf1;
B=2*sqrt(2*log2(fac));
CB=4/(B^2 * log(2));
filter1=exp(-CB*(log(abs(f)/cf1)).^2);
filter2=exp(-CB*(log(abs(f)/cf2)).^2);
filter1(1:find(f == 0.00001))=0;
filter2(1:find(f == 0.00001))=0;

Q=sqrt(cf1*cf2)/max(f);
fratio=filter2./filter1 * Q;

plot(f,filter1,f,filter2,f,fratio);

subplot(2,2,4)

q1=fftshift(fft(filter1.*freq));
q1=fftshift(fft(q1));
q1=fftshift(fft(q1));

q2=fftshift(fft(filter2.*freq));
q2=fftshift(fft(q2));
q2=fftshift(fft(q2));


lferatio=q2./q1 * Q *max(f);

plot(real(lferatio));



