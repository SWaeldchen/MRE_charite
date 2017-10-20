function scroll
% scroll up and down through 3D images in ax
% use + and -


fig=gcf;
key=get(gcf,'CurrentCharacter');

ud=get(gcf,'userdata');
c=colormap;

if ~isfield(ud,'num')
    return
end

ax=ud.all_ax;

ca=caxis;
fac=(max(max(ca))-min(min(ca)))/10;


switch key

case '+'
    
    num=ud.num+1;
    if num > length(ax)
        num=1;
    end
    
    delete(findobj(fig,'type','axes'))
    ax2=copyobj(ax(num),fig);
    set(ax2,'position','default');
    colormap(c)

    ud.num=num;
    set(fig,'userdata',ud,'name',['ax num: ' num2str(num)])

 case '-' 

    
    num=ud.num-1;
    if num < 1
        num=length(ax);
    end
    
     delete(findobj(fig,'type','axes'))
     ax2=copyobj(ax(num),fig);
    set(ax2,'position','default');
    colormap(c)

    ud.num=num;
    set(fig,'userdata',ud,'name',['ax num: ' num2str(num)])

case 'c'
caxis(ca*0.9);

case 'C'
caxis(ca*1.1);
    
case 'b'
caxis(ca-fac);

case 'B'
caxis(ca+fac);

case 's'
    
    segment;
    
    case 'p'
   
   fig=gcf;
   showprofile;
   set(fig,'pointer','arrow');
 
    case 'T'
        
    im2surf
        
    case 'd'
        
    contour_bw
    
    case 'R'
        
        here=pwd;
        [n p]=uigetfile('*_3Droi.mat','load 3D roi-file');
        cd(here);

        if n
        load([p n]);
        else
        im=get(findobj(gca,'type','image'),'Cdata');
        BW=zeros(size(im,1),size(im,2),length(ax));
        end

if sum(sum(BW(:,:,ud.num))) ~= 0
hold on
[tmp h]=contour(BW(:,:,ud.num),[-1000 0.5]);
set(h,'color','g');
drawnow


num=menu('how to proceed with last ROI?','AND','OR','XOR','DELETE','CANCEL');

switch num
    case 1
        BW2=roipoly;
        BW2=BW(:,:,ud.num) & BW2;
    case 2
        BW2=roipoly;
        BW2=BW(:,:,ud.num) | BW2;
    case 3
        BW2=roipoly;
        BW2=xor(BW(:,:,ud.num),BW2);
    case 4
        BW2=BW(:,:,ud.num)*0;
    case 5
        return
end

else

     BW2=roipoly;
     
end
BW(:,:,ud.num)=BW2;



if n
    save([p n],'BW')
else
    [n p]=uiputfile('*_3Droi.mat','save 3D roi-file');
if n
    save([p n],'BW')
else
    return
end

end



delete(gcf)
delete(findobj(ax,'type','hggroup','color','g'))
contour_bw(BW,'g')

end

    
    



