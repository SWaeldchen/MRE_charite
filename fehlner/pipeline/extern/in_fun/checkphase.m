function checkphase(W,wo,tol)
%
% W: 3D wave image from makewave
% 
dim=size(W);


if nargin < 2
    wo=[];
end

if nargin < 3
    tol=[];
end

if isempty(wo)

    if isempty(findobj(0,'tag','checkphase'))

        [FX, FY]=gradient(1./W(:,:,1));
        plot2dwaves(FX+FY);
        clear caxis
        caxis([-3 3])

    else
    set(0,'currentfigure',findobj(0,'tag','checkphase'));
end   
    
set(gcf,'pointer','crosshair');
im=get(gca,'children');
im=findobj(im,'type','image');
CD=get(im,'CData');
bdf=get(im,'ButtonDownFcn');
set(im,'ButtonDownFcn','');
   
txt=text(1,1,'select 1st amplitude','color','red');
   
waitforbuttonpress;
delete(txt);
button=get(gcf,'selectiontype');
if strcmp(button,'extend')
   set(gcf,'pointer','arrow');
   return
elseif strcmp(button,'alt')
    
    delete(findobj(gca,'Tag','checkphase'));
    set(gcf,'pointer','arrow');
    return
end
cp1=get(gca,'Currentpoint');

x1=cp1(1,1);
y1=cp1(1,2);

if x1 < 1
    x1 = 1;
elseif x1 > dim(1)
    x1 = dim(1);
end
if y1 > dim(2)
    y1 = dim(2);
elseif y1 < 1
    y1 = 1;
end

x1=round(x1);
y1=round(y1);

hold on 
h=scatter(x1,y1);
set(h,'markersize',2,'MarkerEdgeColor','none','MarkerFaceColor',[1 0.5 0.2],'tag','firstpoint');
disp(['x1: ' num2str(x1) ' y1: ' num2str(y1)]);

%%%% 2nd point %%%%%

set(gcf,'pointer','crosshair');
im=get(gca,'children');
im=findobj(im,'type','image');
CD=get(im,'CData');
bdf=get(im,'ButtonDownFcn');
set(im,'ButtonDownFcn','');
   
txt=text(1,1,'select 2nd amplitude','color','red');
   
waitforbuttonpress;
delete(txt);
button=get(gcf,'selectiontype');
if strcmp(button,'extend')
   set(gcf,'pointer','arrow');
   return
elseif strcmp(button,'alt')
    
    delete(findobj(gca,'Tag','90degree'));
    set(gcf,'pointer','arrow');
    return
end

Ylim=get(gca,'Ylim');
Xlim=get(gca,'Xlim');
    

cp2=get(gca,'Currentpoint');

x2=cp2(1,1);
y2=cp2(1,2);

if x2 < 1
    x2 = 1;
elseif x2 > dim(1)
    x2 = dim(1);
end
if y2 > dim(2)
    y2 = dim(2);
elseif y2 < 1
    y2 = 1;
end    

h=scatter(x2,y2);
set(h,'markersize',2,'MarkerEdgeColor','none','MarkerFaceColor',[1 0 0],'tag','secondpoint');
set(gcf,'pointer','arrow','keypressfcn','keyfcn');

x2=round(x2(1));
y2=round(y1+(y2-y1)/4);

h=scatter(x2,y2);
set(h,'markersize',3,'MarkerEdgeColor','white','MarkerFaceColor',[0 0 1],'tag','90degree');
set(gcf,'pointer','arrow','keypressfcn','keyfcn','tag','checkphase');

disp(['x2: ' num2str(x2) ' y2: ' num2str(y2)]);


else % wo
    
    x1=wo(1,1);
    y1=wo(1,2);
    x2=wo(2,1);
    y2=wo(2,2);

    set(0,'currentfigure',findobj(0,'tag','checkphase'));
    
    
hold on 
h=scatter(x1,y1);
set(h,'markersize',2,'MarkerEdgeColor','none','MarkerFaceColor',[1 0.5 0.2],'tag','firstpoint');
h=scatter(x2,y2);
set(h,'markersize',3,'MarkerEdgeColor','white','MarkerFaceColor',[0 0 1],'tag','90degree');
hold off
end

    
%%%%%check phase%%%%%%%%%%%%%%%%%%%%%%%%%


p1=squeeze(W(y1,x1,:));
p1=p1-min(p1);
p1=(p1/max(p1)*2)-1;

p2=squeeze(W(y2,x2,:));
p2=p2-min(p2);
p2=(p2/max(p2)*2)-1;

tp=findobj('tag','timeprofile');

if isempty(tp)
fig=figure('name','time profile','numbertitle','off','tag','timeprofile');
else
    
set(0,'currentfigure',tp);
end

hold on
a=plot(unwrap(atan2(p1,p2)));

kids=get(gca,'children');
pl=findobj(kids,'type','line');
set(pl,'ButtonDownFcn','setcolor');

hold off

if ~isempty(tol)
    
    nowrap(pl(1),tol);
end

shg;
    
    




