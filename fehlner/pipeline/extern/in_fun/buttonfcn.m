function buttonfcn(button)
%
% left mouse click: changes frame to the current axes
%

if nargin < 1
    
    button = get(gcf,'Selectiontype');
    
end

switch button
    
case 'normal'
    
   kids=get(gcf,'children');
   ax=findobj(kids,'type','axes');
   set(ax,'visible','off');
   set(gca,'visible','on','Ytick',[],'Xtick',[],'box','on','Ycolor','r','Xcolor','r');

case 'alt'
   
    kids=get(gcf,'children');
    ax=findobj(kids,'type','axes');
        global tmp_w;
        im=findobj(gca,'type','image');
        
        if ~isempty(im)
            tmp_w=get(im(end),'Cdata');
            disp('new data on tmp_w')
            disp(get(im(end),'userdata'))  
        end
       
        
    
end

   