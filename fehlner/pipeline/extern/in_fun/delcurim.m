function delcurim
%
% view menu
%
    
         ax=findobj(gcf,'type','axes');
         ax=flipdim(ax,1);
         axnum=find(gca == ax);
         
delete(gca)

        ax=findobj(gcf,'type','axes');
        ax=flipdim(ax,1);
        
                z=0;
                s=0;
    
                   col=ceil(sqrt(length(ax)));
                   row=ceil(length(ax)/col);
                   breit=1/col;
                   hoch=1/row;

        for k=1:length(ax)
                       
                set(ax(k),'position',[s*breit 1-hoch-z*hoch breit hoch]);
                
                s=s+1;
                if s==col s=0; z=z+1; end
                
        end
        
    UD=get(gcf,'userdata');
    if isfield(UD,'t')
        UD.t(axnum)=[];
    end
    if isfield(UD,'T')
        UD.T(axnum)=[];
    end
    
    
    set(gcf,'userdata',UD);
        
    set(gca,'visible','on','Ytick',[],'Xtick',[],'box','on','Ycolor','r','Xcolor','r');
