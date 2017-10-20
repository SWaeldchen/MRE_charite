function fig=plot3dwaves2(SIG,axe,param,key,fac)
% fig=plot3dwaves2(SIG,axe,param,key,fac)
% plot 3d waves for chox_3d
% uses slice
%

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

if nargin < 5
    fac = 0;
end

if fac
    SIG=interp3(SIG,fac,'cubic');
end

dim=size(SIG);
d1=dim(1);
d2=dim(2);
d3=dim(3);


fig=figure('name',['waves 3d a: ' num2str(winkel) '° s: ' num2str(shiftd3) 'xd3 ' num2str(shiftd2) 'xd2'],'numbertitle','off','units','normalized',...
    'position',[0.2561 0.1134 0.6710 0.7813],'keypressfcn','keyfcn');

ax=axes;

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
hold on
hx=slice(SIG,d2,[],[]);
set(hx,'FaceColor','interp','Edgecolor','none');

hy=slice(SIG,[],d1,[]);
set(hy,'FaceColor','interp','Edgecolor','none');

hz=slice(SIG,[],[],1);
set(hz,'FaceColor','interp','Edgecolor','none');

hold off

axis tight;
camzoom(1.4)
camproj perspective;
set(ax,'View',[-37.5 30]);
box on
axis off
axis image
camlight left

cd=get(h,'Cdata');
mi=min(min(cd));
ma=max(max(cd));

caxis([mi, ma]);

if nargin > 3
    
    for k=1:length(key)
        
        keyfcn(key(k));
        
    end
end
