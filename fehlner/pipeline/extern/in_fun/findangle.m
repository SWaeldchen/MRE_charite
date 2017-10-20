function [ang, vec]=findangle(u1,u2)
% [ang, vec]=findangle(u1,u2)
% find the angle (ang) between two vector fields
% find the othogonal vector to the plane spanned by the two vector fields

si = size(u1);

u1norm=sqrt(sum(abs(u1).^2,3));
u2norm=sqrt(sum(abs(u2).^2,3));
u1n=zeros(si);
u2n=zeros(si);

for m=1:si(1); 
    for n=1:si(2) 
        if u1norm(m,n) 
            u1n(m,n,:)=u1(m,n,:)./u1norm(m,n); 
        end; 
        if u2norm(m,n) 
            u2n(m,n,:)=u2(m,n,:)./u2norm(m,n); 
        end; 
    end;
end


ang=dot(u1n,u2n,3);
%vec=cross(u1n,u2n,3);
vec=[];