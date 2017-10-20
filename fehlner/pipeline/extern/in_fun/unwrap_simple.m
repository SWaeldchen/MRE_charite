function u=unwrap_simple(u,flag)

if nargin < 2
    flag=0;
end


u0=u;
u=u/max(max(u))*2*pi;
u=unwrap(u,[],1);
%u1=u-(ones(size(u,1),1)*(mean(u,1)));

u1=u-(ones(size(u,1),1)*u(round(size(u,1)/2),:));

if flag == 2
u=rot90(u0);
u=u/max(max(u))*2*pi;
u=unwrap(u,[],1);
%u2=u-(ones(size(u,1),1)*(mean(u,1)));
u2=u-(ones(size(u,1),1)*u(round(size(u,1)/2),:));

u=rot90(u2,-1);

elseif flag == 3

u=rot90(u0);
u=u/max(max(u))*2*pi;
u=unwrap(u,[],1);
%u2=u-(ones(size(u,1),1)*(mean(u,1)));
u2=u-(ones(size(u,1),1)*u(round(size(u,1)/2),:));

u=(u1+rot90(u2,-1))/2;

else
    
    u=u1;
    
end