function text2allaxes(in,col)



ax=findobj(gcf,'type','axes');



ax=flipud(ax);


for k=1:length(ax)
    
    set(gcf,'currentaxes',ax(k));
    
    h=text(2,7,num2str(in(:,k)));
    if nargin > 1
        set(h,'color',col)
    end
    
end

    