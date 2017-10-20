function showphaseprogress(W,x,y,str)
%
% showphaseprogress(W,x,y,str)
% W: 3D-wave matrix
% x,y: cordinates to cut image section
%      x = [x_1 x_end]
%      y = [y_1 y_end]
% str: plot flag according to plot2dwaves

if nargin < 4
    str=[];
end

dim=size(W);
    
    
    if x == 0
        plot2dwaves(W(:,:,1),str);
        set(gcf,'name','select area');
        xy=ginput(2);
        x=round(xy(:,2))';
        y=round(xy(:,1))';
        disp(['x=[' num2str(x) ']'] );
        disp(['y=[' num2str(y) ']'] );
        close(gcf);
    end
    
    x=sort(x);
    X=x(1):x(end);
    y=sort(y);
    Y=y(1):y(end);
    
    dat=[];
    
    if length(Y) > length(X)
        orientation=1;
    else
        orientation=2;
    end
    
        
    for k=1:dim(3)
                
        dat=cat(orientation,dat,W(X,Y,k));
               
    end
    
    plot2dwaves(dat,str)