function [Wx Wy]=gradient2(W,dx,dy)

% [wx wy]=gradient2(w,dx,dy)
%
% gradient with two-pixel interval for difference
%

Wx=zeros(size(W));
Wy=zeros(size(W));

for k=1:size(W,3)

w=W(:,:,k);
wx=zeros(size(w));
y1=w(:,4:end)-w(:,1:end-3);
wx(:,1:end-3)=y1;
wx(:,4:end)=wx(:,4:end)+y1;
wx(:,4:end-3)=wx(:,4:end-3)/2;
wx=wx/3/dx;
Wx(:,:,k)=wx;

wy=zeros(size(w));
y1=w(4:end,:)-w(1:end-3,:);
wy(1:end-3,:)=y1;
wy(4:end,:)=wy(4:end,:)+y1;
wy(4:end-3,:)=wy(4:end-3,:)/2;
wy=wy/3/dy;
Wy(:,:,k)=wy;

end