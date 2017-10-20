function [ux uy]=actuation(si,k,phi,alph,fac,wave_mode,plot_what)
%
% 2D-wave filed simulation
% actuation(si,k,phi,alph,fac,wave_mode,plot_what)
%
% si: number of pixels in 2D
% k: wave number
% phi: phase for cycling [deg]
% alph: rotation of wave excitation direction w.r.t. image plane
%
% -------> y
% |
% |
% |
% v x
%
% alph = 0  y-deflection
% alph = 90 x-deflection
% 
% fac: length of arrows (e.g. 0.5)
% wave_mode: either 'T' for transversal or 'L' for longitudinal
% plot_what:    1 - vector plot
%               2 - ux deflection image
%               3 - uy deflection image
%               4 - test of the curl and divergence operator
%
% actuation(20,2,0,45,0.5,'T',[1 2 3 4])

long = 1;

x=linspace(0,2*pi*k,si);
ky=x'*ones(1,si);
kx=ky';


a=alph*pi/180;
R=[cos(a) -sin(a); sin(a) cos(a)];
E=[1 0]*R;
E=E/norm(E);

for K=1:length(phi)

switch wave_mode
    case 'T' % 90° gedrehte Anregung
u=exp(-i*E(2)*kx+i*E(1)*ky-i*phi(K)*pi/180);
ux=real(E(2)*u);
uy=real(E(1)*u); 

    case 'L' % longitudinale Anregung
u=exp(-i*E(1)*kx-i*E(2)*ky-i*phi(K)*pi/180);
ux=real(E(2)*u);
uy=real(E(1)*u); 

    case 'E' % transversalwelle mit Reflexion (-90°)
u=exp(-i*E(2)*kx+i*E(1)*ky-i*phi(K)*pi/180);
ux=real(E(2)*u);
uy=real(E(1)*u);

a=-90*pi/180;
R=[cos(a) -sin(a); sin(a) cos(a)];
E=[1 0]*R;
E=E/norm(E);


u=exp(-i*E(2)*kx+i*E(1)*ky-i*phi(K)*pi/180);
ux=ux+real(E(2)*u);
uy=uy+real(E(1)*u); 
    otherwise
        error('only wave_mode ''T'' or ''L'' allowed!')
end




if ~isempty(find(plot_what == 1))

    figure('name',['phi ' num2str(round(phi(K)))]); 

    quiver(x,x,uy,ux);
    axis equal;axis off; 
    hold on
    plot(x,(ux'*fac+ky'),'k',(uy*fac+kx),x,'k',x,ky','k.')
end

  

if ~isempty(find(plot_what == 2))
    
figure('numbertitle','off','name','ux v');
a=imagesc(ux);
axis image
set(gca,'Ydir','normal')
set(gcf,'keypressfcn','keyfcn','units','normalized','position',[0.1078    0.0381    0.4375    0.4102])
colormap gray
caxis([-0.7 0.7])

end
if ~isempty(find(plot_what == 3))
figure('numbertitle','off','name','uy >');
a=imagesc(uy);
axis image
set(gca,'Ydir','normal')
set(gcf,'keypressfcn','keyfcn','units','normalized','position',[0.5500    0.0400    0.4375    0.4102])
colormap gray
caxis([-0.7 0.7])

end


end

if ~isempty(find(plot_what == 4))
plot2dwaves(cat(3,curl(uy,ux),divergence(uy,ux)))
end