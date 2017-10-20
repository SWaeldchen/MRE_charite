function wb=rotateimage(wa,ang,ax)




si=size(wa);
x=ones(si(1),1) *(1:si(2));
y=(1:si(1))'*ones(1,si(2));

a=ang*pi/180; 
R=[cos(a) -sin(a); sin(a) cos(a)];

XY=R*([x(:)'-ax(1); y(:)'-ax(2)]);

wb=interp2(wa,reshape(XY(1,:)+ax(1),si(1),si(2)),reshape(XY(2,:)+ax(2),si(1),si(2)),'cubic');
%wb=interp2(wa,reshape(XY(1,:),si(1),si(2)),reshape(XY(2,:),si(1),si(2)),'cubic');

wb(isnan(wb))=0;