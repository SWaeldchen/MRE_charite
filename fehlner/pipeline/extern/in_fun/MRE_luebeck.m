function MRE_luebeck(freq)


%%%%%%%%%%%%%%%%MRE Lübeck%%%%%%%%%%%%%%%%%%%%
%gradient
t=linspace(0,4/freq,400);
G=sin(t*freq*2*pi);
G(151:250)=0;

figure
plot(t*1000,G);
pause
close gcf

% freq
f=1:100;
%phase
phi=linspace(0,2*pi,100);

for k=1:100
    for L=1:100
        v=sin(t*f(k)*2*pi+phi(L));
        A1(k,L)=sum((G.*v))/100;
    end
end

%%%%%%%%%%%%%%%Vergleich MRE Berlin%%%%%%%%%%%


t=linspace(0,4/freq,400);
G=sin(t*freq*2*pi);

% freq
f=1:100;
%phase
phi=linspace(0,2*pi,100);

for k=1:100
    for L=1:100
        v=sin(t*f(k)*2*pi+phi(L));
        A2(k,L)=sum((G.*v))/100;
    end
end

tmp=max(A1');
plot(1:100,max(A1'),1:100,max(A2'),'--',[25 37 50 62],tmp([25 37 50 62]),'o')
legend('MRE Lübeck','MRE Berlin','Mehrfrequenz-MRE Berlin')
ylabel('rel. Kodiereffizienz')
xlabel('freq [Hz]')
