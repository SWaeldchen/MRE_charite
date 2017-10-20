function w2D=plot3Dslice(w,schicht,trans,rotang)


d1=size(w,1);
d2=size(w,2);
d3=size(w,3);

% translation entlang X:
trans(1)=-trans(1);
if trans(1) > 0
w=cat(2,w(:,trans(1)+1:end,:), w(:,1:trans(1),:)*0);
elseif trans(1) < 0
w=cat(2,w(:,1:abs(trans(1)),:)*0, w(:,1:end+trans(1),:));
end

% translation entlang Y:
if trans(2) > 0
w=cat(1,w(trans(2)+1:end,:,:), w(1:trans(2),:,:)*0);
elseif trans(2) < 0
w=cat(1,w(1:abs(trans(2)),:,:)*0, w(1:end+trans(2),:,:));
end

% translation entlang Z:
if trans(3) > 0
w=cat(3,w(:,:,trans(3)+1:end), w(:,:,1:trans(3))*0);
elseif trans(2) < 0
w=cat(3,w(:,:,1:abs(trans(3)))*0, w(:,:,1:end+trans(3)));
end

fig=figure('name','plot3Dslice','numbertitle','off');
hs=surf(1:d2,1:d1,zeros(d1,d2)+schicht);

rotate(hs,[1 0 0],rotang(1),[d2/2, d1/2, schicht]); % X-axis
rotate(hs,[0 1 0],rotang(2),[d2/2, d1/2, schicht]); % Y-axis
rotate(hs,[0 0 1],rotang(3),[d2/2, d1/2, schicht]); % Z-axis

xd=get(hs,'Xdata');
yd=get(hs,'Ydata');
zd=get(hs,'Zdata');

delete(hs)

h=slice(w,xd,yd,zd);
set(h,'FaceColor','interp','Edgecolor','none','Diffusestrength',.8);
set(gca,'Xlim',[1 d2],'Ylim',[1 d1],'Zlim',[1 d3],'PlotBoxAspectRatio',[1 1 1]);

w2D=get(h,'Cdata');
close(fig)
plot2dwaves(w2D)