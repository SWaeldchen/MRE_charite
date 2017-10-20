function plotmultax(X,Y,holdflag)

if nargin < 2
    Y=X;
    X=ones(size(Y,1),1)*(1:size(Y,2));
else
    if size(X,1) ~= size(Y,1)
        X=ones(size(Y,1),1)*X(1,:);
    end
end

si=size(Y);


if si(1) > 30
    error('zu viele Vektoren, vielleicht transponieren???')
end

if nargin > 2
    
fig=findobj(0,'name','multax');

if ~isempty(fig)
    ax=findobj(fig(1),'type','axes');
    
    if length(ax) == si(1)
        
        ax=flipud(ax);
        for k=1:si(1)
            
            set(fig(1),'currentaxes',ax(k))
            plot(X(k,:),Y(k,:));
        end
    end
end

else


fig=figure;


    
   col=ceil(sqrt(si(1)));
   row=ceil(si(1)/col);
   breit=1/col*0.9;
   hoch=1/row*0.9;
   
   set(fig,'name','multax','units','normalized','position',[0 0 1 0.9]);
   
   z=0;
   s=0;
   
    for k=1:si(1)

    ax=axes('units','normalized','position',[s*breit+0.05 0.95-hoch-z*hoch breit hoch]);
    plot(X(k,:),Y(k,:));
    hold on
   % axis off

       s=s+1;
       if s==col s=0; z=z+1;       end


    end
    


end % holdflag

