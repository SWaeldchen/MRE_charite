function prof=pickprofile(im,N,x)
% prof=pickprofile(N)
% from 2D image

%im=get(findobj(gca,'type','image'),'Cdata');

plot2dwaves(im)
pos=ginput(2);
close
X=linspace(pos(1,1),pos(2,1),N);
Y=linspace(pos(1,2),pos(2,2),N);

if X(1) < 1 X(1)=1; end
if X(end) > size(im,2) X(end)=size(im,2); end

if Y(1) < 1 Y(1)=1; end
if Y(end) > size(im,1) Y(end)=size(im,1); end

prof=interp2(im,X(:),Y(:),'cubic');
hold on
if nargin > 2
plot(x,prof)
else
    plot(prof)
end
shg