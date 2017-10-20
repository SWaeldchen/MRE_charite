function im2surf

ax=findobj(gcf,'type','axes');

Zlim=caxis;
Xlim=get(gca,'Xlim');
Ylim=get(gca,'Ylim');

   prompt={'view:'};
   name='input for surfplots';
   numlines=1;
   defaultanswer={'-42 20'};
 
   answer=inputdlg(prompt,name,numlines,defaultanswer);
    if ~isempty(answer)
        VW=str2num(answer{1});
    else
        return
    end
    
   
%VW=VW=linspace(-37.5,-37.5+180-9,length(ax));

for k=1:length(ax)
    
    set(gcf,'currentaxes',ax(k));
    
    y=get(findobj(gca,'type','image'),'Cdata');
    if ~isempty(y)
    surfl(1:size(y,2),1:size(y,1),y);
    set(findobj(gca,'type','surf'),'edgecolor','none','tag','surfplot');
    shading interp
    set(gca,'Zlim',Zlim,'Ylim',Ylim,'Xlim',Xlim,'view',VW);
    axis off;
    shg;
    drawnow
    end 
    
end
