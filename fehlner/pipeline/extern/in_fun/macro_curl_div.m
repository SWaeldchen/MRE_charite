function [C1 C2 C3 D D1 D2 D3]=macro_curl_div(RO,PE,SS,x,y,z,BW)
% [C1 C2 C3]=macro_curl(RO,PE,SS,x,y,z)

if nargin > 6
f2=0.01;
f1=0.1;

for k=1:size(RO,3)
RO(:,:,k) = uh_filtspatio2d(RO(:,:,k).*BW(:,:,k),[x; y],1/f2,5,1/f1,50, 'bwbwband', 0);
PE(:,:,k) = uh_filtspatio2d(PE(:,:,k).*BW(:,:,k),[x; y],1/f2,5,1/f1,50, 'bwbwband', 0);
SS(:,:,k) = uh_filtspatio2d(SS(:,:,k).*BW(:,:,k),[x; y],1/f2,5,1/f1,50, 'bwbwband', 0);
end
end

[XX XY XZ]=gradient(RO,x,y,z);
[YX YY YZ]=gradient(PE,x,y,z);
[ZX ZY ZZ]=gradient(SS,x,y,z);

% Curl (divergence free)
C1=ZY-YZ;
C2=XZ-ZX;
C3=YX-XY;

% divergence
D=XX+YY+ZZ;

% grad div (curl free)

[D1 D2 D3]=gradient(D,x,y,z);