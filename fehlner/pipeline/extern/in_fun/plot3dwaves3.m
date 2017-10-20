function fig=plot3dwaves3(SIG,axe,param,key)
% fig=plot3dwaves3(SIG,winkel,key)
% plot 3d waves for chox_3d
% uses one slice rotated with winkel around y axes
% gray scale
% SIG: 3D signal
% winkel: angle of rotation
% key: optional
%      'c' contrast enhancement
%      'C' lower contrast
%      'b' brighten
%      'B' darker

winkel=param(1);
if length(param) > 2
    shiftd3=param(2);
    shiftd2=param(3);
elseif length(param) > 1
    shiftd3=param(2);
    shiftd2=0.5;
else
    shiftd3=0.5;
    shiftd2=0.5;
end    

dim=size(SIG);
d1=dim(1);
d2=dim(2);
d3=dim(3);


fig=figure('name',['waves 3d a: ' num2str(winkel) '° s: ' num2str(shiftd3) 'xd3 ' num2str(shiftd2) 'xd2'],'numbertitle','off','units','normalized',...
    'position',[0.25 0.11 0.6*d2/d1 0.8],'keypressfcn','keyfcn');

ax=axes('units','normalized','position',[0 0 1 1]);



hs=surf(linspace(1,d2,100),linspace(1,d1,100),zeros(100,100)+d3*shiftd3);

if strcmp(axe,'y')
    
rotate(hs,[0 1 0],-winkel,[ d2*shiftd2 0 d3*shiftd3]);

elseif strcmp(axe,'x')
    
rotate(hs,[-1 0 0],-winkel,[0 d1*shiftd2 d3*shiftd3]); 

elseif strcmp(axe,'xy')

if length(param) < 4
    winkel2=winkel;
else
    winkel2=param(4);
end


rotate(hs,[-1 0 0],-winkel,[0 d1*shiftd2 d3*shiftd3]);
rotate(hs,[0 1 0],-winkel2,[ d2*shiftd2 0 d3*shiftd3]);

end


xd=get(hs,'Xdata');
yd=get(hs,'Ydata');
zd=get(hs,'Zdata');
delete(hs);

h=slice(SIG,xd,yd,zd);
set(h,'FaceColor','interp','Edgecolor','none','Diffusestrength',.8);

warning off
%set(ax,'View',[-90 90-winkel]);
set(ax,'View',[-180 90]);

axis off
axis image


cd=get(get(gca,'children'),'Cdata');
mi=min(min(cd));
ma=max(max(cd));

colormap gray;
caxis([mi, ma]);

if nargin == 4
    
    for k=1:length(key)
        
        keyfcn(key(k));
        
    end
end

        set(gca,'view',[90 winkel-90])
    
