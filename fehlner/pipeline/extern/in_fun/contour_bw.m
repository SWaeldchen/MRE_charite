function contour_bw(BW,col)
% contour_bw(BW,[col])
% plot countour of binary mask BW onto current axes

if nargin < 1
    
    [filename, pathname] = uigetfile('*_roi.mat', 'roi-mask for display');
     if filename == 0
         return
     else
         load([pathname filename])
     end
     
end

    

if nargin < 2
    
    col='r';
end


ax=findobj(gcf,'type','axes');

si=size(BW);
if length(si) == 2
    si=[si 1];
end


BW=flipdim(BW,3);


for k=1:length(ax)
    
    set(gcf,'currentaxes',ax(k))
    
    hold on
    ca=caxis;
    
    %for K=1:si(3)
warning off
    if size(BW,3) == length(ax)
        [tmp h]=contour(BW(:,:,k),[-1000 0.5]);
    else    
        [tmp h]=contour(BW(:,:,1),[-1000 0.5]);
    end
warning on
    set(h,'color',col)
    %set(h,'LineWidth', 1);
    %set(h,'LineStyle','--');
    %end
    caxis(ca)
    shg
    drawnow
end

