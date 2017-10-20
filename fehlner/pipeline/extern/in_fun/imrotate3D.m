function w3=imrotate3D(w,rotang,method)
%
%
%

if nargin < 3
    method = 'nearest';
end


D=size(w);

for k=1:D(2)
    
    w1(:,k,:)=imrotate(squeeze(w(:,k,:)),rotang(1),method);

end

D=size(w1);

for k=1:D(2)
    
    w2(k,:,:)=imrotate(squeeze(w1(k,:,:)),rotang(2),method);

end

D=size(w2);

for k=1:D(3)
    
    w3(:,:,k)=imrotate(squeeze(w2(:,:,k)),rotang(3),method);

end


