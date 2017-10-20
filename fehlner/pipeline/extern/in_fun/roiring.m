function [BW r1, r2]=roiring(sektor,phas)
%  [BW r1, r2]=roiring(sektor)
%  sektor: number of sektors subdividing the ring

 if nargin == 0
     sektor = 1;
 end
 
 phas=phas*pi/180;
 
 button='normal';
while ~strcmp(button,'alt')
% kreis 1
[x1,y1]=ginput(1);
hold on
plot(x1,y1,'om');
[x1r,y1r]=ginput(1);

r1=sqrt((x1-x1r)^2+(y1-y1r)^2);

t=linspace(0,2*pi,100);
X=sin(t)*r1+x1;
Y=cos(t)*r1+y1;
a1=plot(X,Y);



% kreis 2
% [x2,y2]=ginput(1);
% plot(x2,y2,'xm');

x2=x1; y2=y1;
[x2r,y2r]=ginput(1);

r2=sqrt((x2-x2r)^2+(y2-y2r)^2);

X=sin(t)*r2+x2;
Y=cos(t)*r2+y2;
a2=plot(X,Y);

h=findobj(gca,'type','image');
Cdat=get(h(1),'Cdata');

    for k=1:sektor
    t=linspace(2*pi/sektor*(k-1),2*pi/sektor*k,round(100/sektor))+phas;
    X1=sin(t)*r1+x1;
    Y1=cos(t)*r1+y1;
   
    X2=sin(t)*r2+x2;
    Y2=cos(t)*r2+y2;
    BW(:,:,k)=roipoly(Cdat,[X1(:); flipud(X2(:))],[Y1(:); flipud(Y2(:))]);
    end
    waitforbuttonpress
    button=get(gcf,'selectiontype');
    
end

 for k=1:sektor
     
     [tmp h]=contour(BW(:,:,k),[-1000 0.5]);
     set(h,'color','m')
     
 end
    
    
% pause(1)
% delete(a1)
% delete(a2)