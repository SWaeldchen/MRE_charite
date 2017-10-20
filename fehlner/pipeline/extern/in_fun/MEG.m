function MEG(fv,fg,ng,Ag,Ainit)
%MEG(fv,fg,ng)
%fv=5.5;fg=10;ng=5; 

figure
t=linspace(0,ng/fg,1000); 
subplot(2,1,1)
plot(t,sin(t*2*pi*fg),t,sin(t*2*pi*fv));

theta=linspace(0,2*pi,100);
dt=t(2)-t(1);
for k=1:100 
    S(k)=sum(sin(t*2*pi*fg).*sin(t*2*pi*fv+theta(k)))*dt;  
    
end; 


opti_theta=pi*ng*(1-fv/fg);

offset=floor(opti_theta/pi);
opti_theta=opti_theta-offset*pi;

x1=find(theta > opti_theta);
x2=find(theta < opti_theta);
opti_S=S(round(mean([x1(1) x2(end)])));

subplot(2,1,2)
plot(theta,S,opti_theta,opti_S,'o');

title(['best theta: ' num2str(round(opti_theta/pi*100)/100) ' x pi'] )


max(S)
%halbe integration
half_integral=sum(sin(t*2*pi*fg/2).*sin(t*2*pi*fv/2))*dt

if nargin > 4
g=2*pi*42.5*10^3; % gyromagnetisches Verhältnis relativ zu mT/m
phase=g*Ag*Ainit*half_integral;
disp(['phase: ' num2str(phase) '   for nv = 1'])
end