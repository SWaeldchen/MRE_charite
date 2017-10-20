function plot2dwaves(sig,key)
%
% plot 2d wave image
%


sig=real(sig);
    
si=size(sig);

fig=figure('name','2Dw','keypressfcn','keyfcn');

if length(si) == 4
    sig=reshape(sig,si(1),si(2),si(3)*si(4));
    si=size(sig);
    disp(['reshaped to size' num2str(si)])
end


if length(si) == 3
    
   col=ceil(sqrt(si(3)));
   row=ceil(si(3)/col);
   breit=1/col;
   hoch=1/row;
   
   set(fig,'name','3Dw','units','normalized','position',[0 0 1 0.9]);
   
   z=0;
   s=0;
   
    for k=1:si(3)

    ax=axes('units','normalized','position',[s*breit 1-hoch-z*hoch breit hoch]);
    h=image(sig(:,:,k),'Cdatamapping','scaled'); 
    axis image
    axis off
    colormap gray

    set(h,'buttondownfcn','buttonfcn','Tag','im1');

       s=s+1;
       if s==col s=0; z=z+1;

       end

            if nargin > 1
            for k=1:length(key)
            keyfcn(key(k));
            end
            end

    end

    
    set(gca,'visible','on','Ytick',[],'Xtick',[],'box','on','Ycolor','r','Xcolor','r');

     


else    % 3D
    
 h_imag=image(sig,'Cdatamapping','scaled'); 
 set(gca,'units','normalized','position',[0 0 1 1]);
 axis image
 axis off
 colormap gray
 
 
if nargin > 1
    
    for k=1:length(key)
        
        keyfcn(key(k));
        
    end
end

end % 3D


%% uimenus

h=uimenu(gcf,'Label','colormap');
h1=uimenu(h,'Label','MRE waves','callback','load cmp_uh; colormap(cmp_uh);');
h1=uimenu(h,'Label','MRE elastogram','callback','load cmp_elast; colormap(cmp2);');
h1=uimenu(h,'Label','hot','callback', 'colormap(hot);','separator','on');
h1=uimenu(h,'Label','cool','callback','colormap(cool);');
h1=uimenu(h,'Label','jet','callback','colormap(jet);');
h1=uimenu(h,'Label','gray','callback','colormap(gray);');
h1=uimenu(h,'Label','bone','callback','colormap(bone);');
h1=uimenu(h,'Label','hsv','callback','colormap(hsv);');
h1=uimenu(h,'Label','matlab default','callback','colormap default ;');

if sum(imag(sig)) > 0 set(gcf, 'name',[get(gcf,'name') ' real part' ]); end
