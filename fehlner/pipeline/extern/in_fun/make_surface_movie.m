function make_surface_movie(SIG,BW,y)

% make_surface_movie(SIG,BW)

SIG=SIG/max(max(max(SIG)))*10;
x=find(~BW);
load cmp_uh
for k=1:size(SIG,3) 
    TMP=SIG(:,:,k);
    TMP(x)=NaN;
figure    
surface(1:128,1:128,real(TMP),y,'edgecolor','none');
axis image; 
axis off; 
set(gca,'view',[20 -40],'Zlim',[-0.1 0.1],'Xlim',[28 100],'Ylim',[10 118]); 
%colormap(cmp_uh);
colormap gray
caxis([-20 20]);
caxis([0 10000])
end
