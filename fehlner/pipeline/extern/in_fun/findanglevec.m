function ang=findanglevec(u1,u2)
% ang=findanglevec(u1,u2)
% find the angle (ang) between two vectors 
% u1, u2: nx3 matrices of the vectors


si = size(u1);

u1norm=sqrt(sum(abs(u1).^2,2));
u2norm=sqrt(sum(abs(u2).^2,2));
u1n=zeros(si);
u2n=zeros(si);

for m=1:si(1); 
        if u1norm(m) 
            u1n(m,:)=u1(m,:)./u1norm(m); 
        end; 
        if u2norm(m) 
            u2n(m,:)=u2(m,:)./u2norm(m); 
        end; 
   
end


ang=dot(u1n,u2n,2);
