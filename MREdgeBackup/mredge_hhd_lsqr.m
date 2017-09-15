function curl_comps = mredge_hhd_lsqr(comps, prefs)
tic;

Fx = double(comps{1});
Fy = double(comps{2});
Fz = double(comps{3});

dx = 1;
dy = 1;
dz = 1;
 
szx = size(Fx,2);
szy = size(Fx,1);
szz = size(Fz,3);

%derivatives------------------

dyy=zeros(szy,1); dlyy=-1*ones(szy,1); duyy=1*ones(szy,1);
dyy(1) = -2;  dyy(end) = 2; dlyy(end-1) = -2; duyy(2) = 2;
grady1 = spdiags([dlyy, dyy, duyy]/(2*dy), -1:1, szy, szy);
   
dxx=zeros(szx,1); dlxx=-1*ones(szx,1); duxx=1*ones(szx,1);
dxx(1) = -2;  dxx(end) = 2; dlxx(end-1) = -2; duxx(2) = 2;
gradx1 = spdiags([dlxx, dxx, duxx]/(2*dx), -1:1, szx, szx);

dzz = zeros(szz,1); dlzz=-1*ones(szz,1); duzz=1*ones(szz,1);
dzz(1) = -2; dzz(end) = 2; dlzz(end-1) = -2; duzz(2) = 2;
gradz1 = spdiags([dlzz, dzz, duzz]/(2*dz), -1:1, szz, szz);

grady2 = kron(speye(szx),grady1);
grady3 = kron(speye(szz),grady2);

gradx2 = kron(gradx1,speye(szy));
gradx3 = kron(speye(szz), gradx2);

gradz2 = kron(speye(szx), speye(szy));
gradz3 = kron(gradz1, gradz2);

r = spalloc(size(gradx3,1),size(gradx3,2),0);
I = speye(size(gradx3,1),size(gradx3,2));

s1 = 1e-8*I;
W1 = 1; W2 = 1; W3 = 10;
A =[W1*[r -gradz3 +grady3 s1 r r];W1*[+gradz3 r -gradx3 r s1 r];W1*[-grady3 +gradx3 r r r s1];W2*[s1 s1 s1 +gradx3 +grady3 +gradz3];W3*[I r r I r r];W3*[r I r r I r];W3*[r r I r r I]];
%A =[[r -gradz3 +grady3 r r r];[+gradz3 r -gradx3 r r r];[-grady3 +gradx3 r r r r];[r r r +gradx3 +grady3 +gradz3];[I r r I r r];[r I r r I r];[r r I r r I]];
%A =[2*[r -gradz3 +grady3 r r r];2*[+gradz3 r -gradx3 r r r];2*[-grady3 +gradx3 r r r r];[r r r +gradx3 +grady3 +gradz3];10*[I r r I r r];10*[r I r r I r];10*[r r I r r I]];
r =zeros(szy*szx*szz,1);
b =[r;r;r;r;Fx(:);Fy(:);Fz(:)];

x=lsqr_eb(A,b,10^-3,prefs.lsq_curl_settings.num_iter);
l = length(x)/6;
R = size(Fx);
 
%FIRx = reshape(x(0*l+1:1:l), R);
%FIRy = reshape(x(1*l+1:2*l), R);
%FIRz = reshape(x(2*l+1:3*l), R);
curl_comps{1} = reshape(x(3*l+1:4*l), R);
curl_comps{2} = reshape(x(4*l+1:5*l), R);
curl_comps{3} = reshape(x(5*l+1:6*l), R);

toc;
