function fig2jpg
% print(gcf, '-djpeg', 'tmp.jpg');

ax=gca;
fig=figure;
h=copyobj(ax,fig);
        set(h,'position','default','box','off');
        
        
        set(0,'currentfigure',fig)
        shg
shg
print(gcf, '-djpeg', 'tmp');