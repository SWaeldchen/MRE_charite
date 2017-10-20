function [gradval val]=radial_gradient(w,BW,origin)


[r c]=find(BW);

if nargin < 3
plot2dwaves(BW)
set(gcf,'name','pick origin')
origin=ginput(1);
close gcf
end

c0=c-origin(1);
r0=r-origin(2);
[th R]=cart2pol(c0,r0);
ind=sub2ind(size(BW),r,c);

% BWth=double(BW);
% BWr=double(BW);
% BWr(ind)=R;
% BWth(ind)=th;
% plot2dwaves(cat(3,BWr,BWth))


trx=sortrows([th R ind],1);

% 16 segments for theta
%vec=1:round(length(th)/17):length(th);
vec=round(linspace(1,length(th),17));

% 6 increments of r
val=zeros(6,length(vec)-1);

for k=1:length(vec)-1
    
    thm(k)=mean(trx(vec(k):vec(k+1),1));
    rx=sortrows(trx(vec(k):vec(k+1),2:3),1);
    y=unwrap(w(rx(:,2)));
    val(:,k)=average_binwise(y,6)';
    
end

%val=wiener2(val,[3 3]);
gradval=gradient(val')';


% 
% figure
%   r=linspace(min(trx(:,2)),max(trx(:,2)),6);
%   imagesc(thm,r,val)
%   xlabel('theta')
%   ylabel('r')
%   colormap gray