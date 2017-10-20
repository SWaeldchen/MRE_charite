function C=prodmat3d(A,B)
%
% C=prodmat3d(A,B)
%

d1=size(A,1);
d2=size(A,2);
d3=size(B,3);

if size(B,3) ~= d2
    
    error('matrices A and B have different column numbers!');
end

C=zeros(d1,d2,d3);

for k = 1:d1
    
    
    C(k,:,:)=squeeze(B(k,1,:))*A(k,:);
    
end 