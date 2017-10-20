function w2gif(w,ca)
%
% w2gif(w,ca)
% 
    
close all; 
    imagesc(w(:,:,1));
    colormap gray; 
    caxis(ca); 
    %axis image; 
    axis off; 
    f= getframe(gca);
    [tmp,map] = rgb2ind(f.cdata,256,'nodither');

    im=zeros(size(tmp,1),size(tmp,2),size(tmp,3),size(w,3));
map = gray;    
for k=1:size(w,3) 
    close all; 
    imagesc(w(:,:,k));
    colormap gray; 
    caxis(ca); 
    %axis image; 
    axis off; 
    f= getframe(gca);
    im(:,:,:,k)= rgb2ind(f.cdata,gray,'nodither');
end
close gcf
 imwrite(im,map,'tmp.gif','DelayTime',0,'LoopCount',inf)