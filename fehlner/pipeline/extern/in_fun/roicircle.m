function BW=roicircle(sektor)
%  BW=roiring(sektor)
%  sektor: number of sektors subdividing the ring

 if nargin == 0
     sektor = 1;
 end
 


% kreis
[x1,y1]=ginput(1);
hold on
plot(x1,y1,'om');
[x1r,y1r]=ginput(1);

r1=sqrt((x1-x1r)^2+(y1-y1r)^2);

t=linspace(0,2*pi,100);
X=sin(t)*r1+x1;
Y=cos(t)*r1+y1;
a1=plot(X,Y);




h=findobj(gca,'type','image');
Cdat=get(h(1),'Cdata');

    for k=1:sektor
    t=linspace(2*pi/sektor*(k-1),2*pi/sektor*k,round(100/sektor));
    X1=sin(t)*r1+x1;
    Y1=cos(t)*r1+y1;
   
    BW(:,:,k)=roipoly(Cdat,[x1; X1(:)],[y1; Y1(:)]);
    end

    
    
    
% pause(1)
% delete(a1)
% delete(a2)