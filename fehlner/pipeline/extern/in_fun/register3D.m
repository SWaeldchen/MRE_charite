function wei=register3D(A,B,ax,ay,az)

A_org=A;
B_org=B;


wei=zeros(length(ax),length(ay),length(az));

for kx=1:length(ax)
    for ky=1:length(ay)
        for kz=1:length(az)
            
    B=imrotate3D(B_org,[ax(kx), ay(ky), az(kz)]);
    
if size(A,1) > size(B,1)
    
    ds=size(A,1)-size(B,1);
    B(end+1:end+ds,:,:)=0;
elseif size(A,1) < size(B,1)
    ds=size(B,1)-size(A,1);
    A(end+1:end+ds,:,:)=0;
end


if size(A,2) > size(B,2)
    
    ds=size(A,2)-size(B,2);
    B(:,end+1:end+ds,:)=0;
elseif size(A,2) < size(B,2)
    ds=size(B,2)-size(A,2);
    A(:,end+1:end+ds,:)=0;
end

if size(A,3) > size(B,3)
    
    ds=size(A,3)-size(B,3);
    B(:,:,end+1:end+ds)=0;
elseif size(A,3) < size(B,3)
    ds=size(B,3)-size(A,3);
    A(:,:,end+1:end+ds)=0;
end

wei(kx,ky,kz)=sum(sum(sum(abs(A-B))));

A=A_org;

end
end
end
