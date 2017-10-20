function showprofile(flag);
%
%
%
im=findobj(gca,'type','image','visible','on');
bdf=get(im,'ButtonDownFcn');
CD=get(im,'CData');
set(im,'ButtonDownFcn','');

fig_cur=gcf;
if nargin < 1
set(gcf,'pointer','crosshair');

   
   
waitforbuttonpress;
button=get(gcf,'selectiontype');
if strcmp(button,'extend')
   set(gcf,'pointer','arrow');
   set(im,'ButtonDownFcn',bdf);
   return
elseif strcmp(button,'alt')
    
    delete(findobj(gcf,'Tag','profileline'));
    set(gcf,'pointer','arrow');
    set(im,'ButtonDownFcn',bdf);
    return
end

Ylim=get(gca,'Ylim');
Xlim=get(gca,'Xlim');
    

cp=get(gca,'Currentpoint');

hold on

x(1)=cp(1,1);
y(1)=cp(1,2);

if x(1) < Xlim(1)
    x(1) = Xlim(1);
elseif x(1) > Xlim(2)
    x(1) = Xlim(2);
end
if y(1) < Ylim(1)
    y(1) = Ylim(1);
elseif y(1) > Ylim(2)
    y(1) = Ylim(2);
end

    
    
h=scatter(x,y);

set(h,'Sizedata',2,'MarkerEdgeColor','none','MarkerFaceColor',[1 0 0]);

waitforbuttonpress;

cp=get(gca,'Currentpoint');

x(2)=cp(1,1);
y(2)=cp(1,2);

if x(2) < Xlim(1)
    x(2) = Xlim(1);
elseif x(2) > Xlim(2)
    x(2) = Xlim(2);
end
if y(2) < Ylim(1)
    y(2) = Ylim(1);
elseif y(2) > Ylim(2)
    y(2) = Ylim(2);
end


delete(h);

%num=sum(abs([x(1) y(1)]-[x(2) y(2)]))
num=sqrt((x(1)-x(2))^2 + (y(1)-y(2))^2);

X=floor(linspace(x(1)+1,x(2),num*200));
Y=floor(linspace(y(1)+1,y(2),num*200));
X(X < 1) = [];
Y(Y < 1) = [];

    




h=plot([X(1) X(end)],[Y(1) Y(end)],'r');
set(h,'Tag','profileline','buttondownfcn','showprofile(1)');

else % flag
    
    x=get(gco,'Xdata');
    y=get(gco,'Ydata');
    
    num=sqrt((x(1)-x(2))^2 + (y(1)-y(2))^2);

X=floor(linspace(x(1),x(2),num*200));
Y=floor(linspace(y(1),y(2),num*200));
X(X < 1) = [];
Y(Y < 1) = [];



end % flag

ind=sub2ind(size(CD),Y,X);
d=diff(ind);
ind(d == 0)=[];
Y(d == 0)=[];


% smooth with spline
dat=CD(ind);
x=1:length(dat);
dat2=[dat(1:4:end-1) dat(end)];
x2=[x(1:4:end-1) x(end)];
dat2=interp1(x2,dat2,x,'spline');
%%%%



obj=findobj(0,'Tag','profile');

if isempty(obj)

figure('name','profile window','numbertitle','off','Tag','profile');

h=plot(x,dat,x,dat2,'--');
set(h,'Tag','profileline');
axis tight;

else

ax=get(obj,'children');
set(0,'currentfigure',obj);
co=get(ax,'colororder');
co=[co; co; co; co; co];
co=[co; co; co; co; co];


delete(findobj(ax,'linestyle','--'));
p=get(ax,'children');

hold on
h=plot(x,dat);
axis tight
if length(p) <= size(co,1)
set(h,'color',[co(length(p)+1,:)]);
end

end

kids=get(gca,'children');
pl=findobj(kids,'type','line');
%set(pl,'ButtonDownFcn','lfe_gauss_1D');
set(pl,'ButtonDownFcn','nowrap');
set(fig_cur,'pointer','arrow');
set(im,'ButtonDownFcn',bdf);


shg



