function [C1 C2 C3 XX YY ZZ]=curl_wrapped_interleavedZ(X,Y,Z,dx,dy,dz,filt)
%
% [C1 C2 C3]=curl_wrapped(X,Y,Z,dx,dy,dz,filt)
%

si=size(X);

X1=X(:,:,1:2:end-1,:);
Y1=Y(:,:,1:2:end-1,:);
Z1=Z(:,:,1:2:end-1,:);

X2=X(:,:,2:2:end,:);
Y2=Y(:,:,2:2:end,:);
Z2=Z(:,:,2:2:end,:);

for ks=1:size(X,4)
    
if nargin < 7
fprintf('.')

phasX=angle(exp(i*X1(:,:,:,ks)));
phasY=angle(exp(i*Y1(:,:,:,ks)));
phasZ=angle(exp(i*Z1(:,:,:,ks)));

else
    fprintf('fa')
    phasX=angle(smooth3(exp(i*X1(:,:,:,ks)),'gaussian',filt));
    phasY=angle(smooth3(exp(i*Y1(:,:,:,ks)),'gaussian',filt));
    phasZ=angle(smooth3(exp(i*Z1(:,:,:,ks)),'gaussian',filt));
end

[XX XY XZ]=gradient(exp(i*phasX),dx,dy,dz*2);
[YX YY YZ]=gradient(exp(i*phasY),dx,dy,dz*2);
[ZX ZY ZZ]=gradient(exp(i*phasZ),dx,dy,dz*2);

C1a(:,:,:,ks)=imag(exp(-i*phasZ).*ZY)-imag(exp(-i*phasY).*YZ);
C2a(:,:,:,ks)=imag(exp(-i*phasX).*XZ)-imag(exp(-i*phasZ).*ZX);
C3a(:,:,:,ks)=imag(exp(-i*phasY).*YX)-imag(exp(-i*phasX).*XY);

XXa(:,:,:,ks)=imag(exp(-i*phasX).*XX);
YYa(:,:,:,ks)=imag(exp(-i*phasY).*YY);
ZZa(:,:,:,ks)=imag(exp(-i*phasZ).*ZZ);

%%%%%%%%%%%%%%%%%%%%%% b %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 7
fprintf('.')

phasX=angle(exp(i*X2(:,:,:,ks)));
phasY=angle(exp(i*Y2(:,:,:,ks)));
phasZ=angle(exp(i*Z2(:,:,:,ks)));

else
    fprintf('fb')
    phasX=angle(smooth3(exp(i*X2(:,:,:,ks)),'gaussian',filt));
    phasY=angle(smooth3(exp(i*Y2(:,:,:,ks)),'gaussian',filt));
    phasZ=angle(smooth3(exp(i*Z2(:,:,:,ks)),'gaussian',filt));
end

[XX XY XZ]=gradient(exp(i*phasX),dx,dy,dz*2);
[YX YY YZ]=gradient(exp(i*phasY),dx,dy,dz*2);
[ZX ZY ZZ]=gradient(exp(i*phasZ),dx,dy,dz*2);

C1b(:,:,:,ks)=imag(exp(-i*phasZ).*ZY)-imag(exp(-i*phasY).*YZ);
C2b(:,:,:,ks)=imag(exp(-i*phasX).*XZ)-imag(exp(-i*phasZ).*ZX);
C3b(:,:,:,ks)=imag(exp(-i*phasY).*YX)-imag(exp(-i*phasX).*XY);

XXb(:,:,:,ks)=imag(exp(-i*phasX).*XX);
YYb(:,:,:,ks)=imag(exp(-i*phasY).*YY);
ZZb(:,:,:,ks)=imag(exp(-i*phasZ).*ZZ);

end

XX=zeros(si);
YY=zeros(si);
ZZ=zeros(si);

XX(:,:,1:2:end-1,:)=XXa;
XX(:,:,2:2:end,:)=XXb;
YY(:,:,1:2:end-1,:)=YYa;
YY(:,:,2:2:end,:)=YYb;
ZZ(:,:,1:2:end-1,:)=ZZa;
ZZ(:,:,2:2:end,:)=ZZb;

% XX=(XXa + XXb)/2;
% YY=(YYa + YYb)/2;
% ZZ=(ZZa + ZZb)/2;

C1=(C1a + C1b)/2;
C2=(C2a + C2b)/2;
C3=(C3a + C3b)/2;
