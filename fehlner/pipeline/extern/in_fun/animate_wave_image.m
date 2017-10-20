function animate_wave_image(bild,waves)
% function animate_wave_image(bild,waves)

si=size(bild);

if nargin < 2
    x=linspace(0,2*pi*2,si(1));
    waves=sin(x)'*ones(1,si(2)) + i*cos(x)'*ones(1,si(2));    
end

W=real(reshape(waves(:)*exp(i*linspace(0,2*pi-pi/5,10)),si(1),si(2),10));

for k=1:10
   figure 
   h=surf(1:si(2),1:si(1),W(:,:,k),double(bild));
   set(h,'Edgecolor','none')
   colormap gray
   axis off
   set(gca,'view',[10 -80]);shg
end