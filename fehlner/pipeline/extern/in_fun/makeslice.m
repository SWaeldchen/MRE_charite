function [xd, yd, zd]=makeslice(dim,axe,param)
%
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

d1=dim(1);
d2=dim(2);
d3=dim(3);



%hs=surf(linspace(-d2,d2,2),linspace(1,d1,2),zeros(2,2)+d3*shiftd3);
hs=surf(linspace(1,d2,2),linspace(1,d1,2),zeros(2,2)+d3*shiftd3);

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
