function [b,p,q] = voxel_terms_eb(U,spacing)
% Evaluation of voxelwise integral terms, around a voxel indexed as 2:end-1,2:end-1,2:end-1.
%
% [b,p,q] = voxel_terms(2:end-1,2:end-1,2:end-1,freq,[dx,dy,dz])
%
% If u=(ux,uy,uz) represents the displacement field, then
%
% b = int_{voxel boundary} e(u)n   ds, where e(u) = sym(grad(u))
% p = int_{voxel volume}     u     dx
% q = int_{voxel boundary} div(u)n ds, where div(u) = dux/dx+duy/dy+duz/dz
%
%
% Remark: Remember that DUx is the gradient evaluated at
% staggered nodes, i.e., 
% DUx(2:end-1,2:end-1,2:end-1,:)) = [dUx/dx,dUx/dy,dUx/dz](2:end-1,2:end-1,2:end-1) 
% at freq 'f', where ijk is not the voxel center but 
% the right-upper-front node in the cube that represents 
% the voxel ijk.
%
% In 2D would be like this
%
%    (1:end-2,j) -----------------(2:end-1,j)         Physical coordinates
%       |                       |
%       |                       |           ^ +y(j)
%       |         [2:end-1,j]         |           |
%       |                       |           |
%       |                       |           +---> +x(i)
%    (1:end-2,1:end-2) ---------------(2:end-1,1:end-2)
%
% J. Mura (2017)

dx = spacing(1); dy = spacing(2); dz = spacing(3);

[DUx, Ux] = gradestim4d(U(:,:,:,1), spacing);
[DUy, Uy] = gradestim4d(U(:,:,:,2), spacing);
[DUz, Uz] = gradestim4d(U(:,:,:,3), spacing);

ijk  = @(x) x(2:end-1, 2:end-1, 2:end-1);
i1jk = @(x) x(1:end-2, 2:end-1, 2:end-1);
ij1k = @(x) x(2:end-1, 1:end-2, 2:end-1);
ijk1 = @(x) x(2:end-1, 2:end-1, 1:end-2);
i1j1k = @(x) x(1:end-2, 1:end-2, 2:end-1); 
ij1k1 = @(x) x(2:end-1, 1:end-2, 1:end-2);
i1jk1 = @(x) x(1:end-2, 2:end-1, 1:end-2);
i1j1k1 = @(x) x(1:end-2, 1:end-2, 1:end-2);


% Now we collect the information from the 8 vertices around
% the voxel [2:end-1,2:end-1,2:end-1]:


%% Derivatives at vertex (i,j,k)
dUxdx_ijk = squeeze(DUx(2:end-1,2:end-1,2:end-1,1));
dUydx_ijk = squeeze(DUy(2:end-1,2:end-1,2:end-1,1));
dUzdx_ijk = squeeze(DUz(2:end-1,2:end-1,2:end-1,1));
dUxdy_ijk = squeeze(DUx(2:end-1,2:end-1,2:end-1,2));
dUydy_ijk = squeeze(DUy(2:end-1,2:end-1,2:end-1,2));
dUzdy_ijk = squeeze(DUz(2:end-1,2:end-1,2:end-1,2));
dUxdz_ijk = squeeze(DUx(2:end-1,2:end-1,2:end-1,3));
dUydz_ijk = squeeze(DUy(2:end-1,2:end-1,2:end-1,3));
dUzdz_ijk = squeeze(DUz(2:end-1,2:end-1,2:end-1,3));
                
% Derivatives at vertex (i-1,j,k)
dUxdx_i1jk = squeeze(DUx(1:end-2,2:end-1,2:end-1,1));
dUydx_i1jk = squeeze(DUy(1:end-2,2:end-1,2:end-1,1));
dUzdx_i1jk = squeeze(DUz(1:end-2,2:end-1,2:end-1,1));
dUxdy_i1jk = squeeze(DUx(1:end-2,2:end-1,2:end-1,2));
dUydy_i1jk = squeeze(DUy(1:end-2,2:end-1,2:end-1,2));
dUzdy_i1jk = squeeze(DUz(1:end-2,2:end-1,2:end-1,2));
dUxdz_i1jk = squeeze(DUx(1:end-2,2:end-1,2:end-1,3));
dUydz_i1jk = squeeze(DUy(1:end-2,2:end-1,2:end-1,3));
dUzdz_i1jk = squeeze(DUz(1:end-2,2:end-1,2:end-1,3));
                
% Derivatives at vertex (i,j-1,k)
dUxdx_ij1k = squeeze(DUx(2:end-1,1:end-2,2:end-1,1));
dUydx_ij1k = squeeze(DUy(2:end-1,1:end-2,2:end-1,1));
dUzdx_ij1k = squeeze(DUz(2:end-1,1:end-2,2:end-1,1));
dUxdy_ij1k = squeeze(DUx(2:end-1,1:end-2,2:end-1,2));
dUydy_ij1k = squeeze(DUy(2:end-1,1:end-2,2:end-1,2));
dUzdy_ij1k = squeeze(DUz(2:end-1,1:end-2,2:end-1,2));
dUxdz_ij1k = squeeze(DUx(2:end-1,1:end-2,2:end-1,3));
dUydz_ij1k = squeeze(DUy(2:end-1,1:end-2,2:end-1,3));
dUzdz_ij1k = squeeze(DUz(2:end-1,1:end-2,2:end-1,3));
                
% Derivatives at vertex (i,j,k-1)
dUxdx_ijk1 = squeeze(DUx(2:end-1,2:end-1,1:end-2,1));
dUydx_ijk1 = squeeze(DUy(2:end-1,2:end-1,2:end-1,1));
dUzdx_ijk1 = squeeze(DUz(2:end-1,2:end-1,2:end-1,1));
dUxdy_ijk1 = squeeze(DUx(2:end-1,2:end-1,2:end-1,2));
dUydy_ijk1 = squeeze(DUy(2:end-1,2:end-1,2:end-1,2));
dUzdy_ijk1 = squeeze(DUz(2:end-1,2:end-1,2:end-1,2));
dUxdz_ijk1 = squeeze(DUx(2:end-1,2:end-1,2:end-1,3));
dUydz_ijk1 = squeeze(DUy(2:end-1,2:end-1,2:end-1,3));
dUzdz_ijk1 = squeeze(DUz(2:end-1,2:end-1,2:end-1,3));

% Derivatives at vertex (i-1,j-1,k)
dUxdx_i1j1k = squeeze(DUx(1:end-2,1:end-2,2:end-1,1));
dUydx_i1j1k = squeeze(DUy(1:end-2,1:end-2,2:end-1,1));
dUzdx_i1j1k = squeeze(DUz(1:end-2,1:end-2,2:end-1,1));
dUxdy_i1j1k = squeeze(DUx(1:end-2,1:end-2,2:end-1,2));
dUydy_i1j1k = squeeze(DUy(1:end-2,1:end-2,2:end-1,2));
dUzdy_i1j1k = squeeze(DUz(1:end-2,1:end-2,2:end-1,2));
dUxdz_i1j1k = squeeze(DUx(1:end-2,1:end-2,2:end-1,3));
dUydz_i1j1k = squeeze(DUy(1:end-2,1:end-2,2:end-1,3));
dUzdz_i1j1k = squeeze(DUz(1:end-2,1:end-2,2:end-1,3));

% Derivatives at vertex (i,j-1,k-1)
dUxdx_ij1k1 = squeeze(DUx(2:end-1,1:end-2,1:end-2,1));
dUydx_ij1k1 = squeeze(DUy(2:end-1,1:end-2,1:end-2,1));
dUzdx_ij1k1 = squeeze(DUz(2:end-1,1:end-2,1:end-2,1));
dUxdy_ij1k1 = squeeze(DUx(2:end-1,1:end-2,1:end-2,2));
dUydy_ij1k1 = squeeze(DUy(2:end-1,1:end-2,1:end-2,2));
dUzdy_ij1k1 = squeeze(DUz(2:end-1,1:end-2,1:end-2,2));
dUxdz_ij1k1 = squeeze(DUx(2:end-1,1:end-2,1:end-2,3));
dUydz_ij1k1 = squeeze(DUy(2:end-1,1:end-2,1:end-2,3));
dUzdz_ij1k1 = squeeze(DUz(2:end-1,1:end-2,1:end-2,3));

% Derivatives at vertex (i-1,j,k-1)
dUxdx_i1jk1 = squeeze(DUx(1:end-2,2:end-1,1:end-2,1));
dUydx_i1jk1 = squeeze(DUy(1:end-2,2:end-1,1:end-2,1));
dUzdx_i1jk1 = squeeze(DUz(1:end-2,2:end-1,1:end-2,1));
dUxdy_i1jk1 = squeeze(DUx(1:end-2,2:end-1,1:end-2,2));
dUydy_i1jk1 = squeeze(DUy(1:end-2,2:end-1,1:end-2,2));
dUzdy_i1jk1 = squeeze(DUz(1:end-2,2:end-1,1:end-2,2));
dUxdz_i1jk1 = squeeze(DUx(1:end-2,2:end-1,1:end-2,3));
dUydz_i1jk1 = squeeze(DUy(1:end-2,2:end-1,1:end-2,3));
dUzdz_i1jk1 = squeeze(DUz(1:end-2,2:end-1,1:end-2,3));

% Derivatives at vertex (i-1,j-1,k-1)
dUxdx_i1j1k1 = squeeze(DUx(1:end-2,1:end-2,1:end-2,1));
dUydx_i1j1k1 = squeeze(DUy(1:end-2,1:end-2,1:end-2,1));
dUzdx_i1j1k1 = squeeze(DUz(1:end-2,1:end-2,1:end-2,1));
dUxdy_i1j1k1 = squeeze(DUx(1:end-2,1:end-2,1:end-2,2));
dUydy_i1j1k1 = squeeze(DUy(1:end-2,1:end-2,1:end-2,2));
dUzdy_i1j1k1 = squeeze(DUz(1:end-2,1:end-2,1:end-2,2));
dUxdz_i1j1k1 = squeeze(DUx(1:end-2,1:end-2,1:end-2,3));
dUydz_i1j1k1 = squeeze(DUy(1:end-2,1:end-2,1:end-2,3));
dUzdz_i1j1k1 = squeeze(DUz(1:end-2,1:end-2,1:end-2,3));


%% Indices related to each face (numbered from 1 to 6)

% Now, perform the (approximate) integration around each voxel...

% face1 = [2:end-1,2:end-1,2:end-1;
%     2:end-1,1:end-2,k;
%     2:end-1,1:end-2,1:end-2;
%     2:end-1,2:end-1,2:end-1-1];
en11 = cat(4, dUxdx_ijk, 0.5*(dUxdy_ijk+dUydx_ijk), 0.5*(dUxdz_ijk+dUzdx_ijk));

en12 = cat(4, dUxdx_ij1k, 0.5*(dUxdy_ij1k+dUydx_ij1k), 0.5*(dUxdz_ij1k+dUzdx_ij1k));

en13 = cat(4, dUxdx_ij1k1, 0.5*(dUxdy_ij1k1+dUydx_ij1k1), 0.5*(dUxdz_ij1k1+dUzdx_ij1k1));

en14 = cat(4, dUxdx_ijk1, 0.5*(dUxdy_ijk1+dUydx_ijk1), 0.5*(dUxdz_ijk1+dUzdx_ijk1));

en1 = 0.25*(en11+en12+en13+en14)*dy*dz; % = int_face1 e(u)n ds


div11 = dUxdx_ijk + dUydy_ijk + dUzdz_ijk;
div12 = dUxdx_ij1k + dUydy_ij1k + dUzdz_ij1k;
div13 = dUxdx_ij1k1 + dUydy_ij1k1 + dUzdz_ij1k1;
div14 = dUxdx_ijk1 + dUydy_ijk1 + dUzdz_ijk1;

div1 = 0.25*(div11 + div12 + div13 + div14)*dy*dz; % recall that n1 = (1,0,0)


% face2 = [1:end-2,1:end-2,1:end-2;
%     1:end-2,1:end-2,k;
%     1:end-2,2:end-1,k;
%     1:end-2,2:end-1,1:end-2];
en21 = cat(4, dUxdx_i1j1k1, 0.5*(dUxdy_i1j1k1+dUydx_i1j1k1),0.5*(dUxdz_i1j1k1+dUzdx_i1j1k1));

en22 = cat(4, dUxdx_i1j1k, 0.5*(dUxdy_i1j1k+dUydx_i1j1k), 0.5*(dUxdz_i1j1k+dUzdx_i1j1k));

en23 = cat(4, dUxdx_i1jk, 0.5*(dUxdy_i1jk+dUydx_i1jk), 0.5*(dUxdz_i1jk+dUzdx_i1jk));

en24 = cat(4, dUxdx_i1jk1, 0.5*(dUxdy_i1jk1+dUydx_i1jk1), 0.5*(dUxdz_i1jk1+dUzdx_i1jk1));

en2 = -0.25*(en21+en22+en23+en24)*dy*dz; % = int_face2 e(u)n ds


div21 = dUxdx_i1j1k1 + dUydy_i1j1k1 + dUzdz_i1j1k1;
div22 = dUxdx_i1j1k + dUydy_i1j1k + dUzdz_i1j1k;
div23 = dUxdx_i1jk + dUydy_i1jk + dUzdz_i1jk;
div24 = dUxdx_i1jk1 + dUydy_i1jk1 + dUzdz_i1jk1;

div2 = 0.25*(div21 + div22 + div23 + div24)*dy*dz; % recall that n2=(-1,0,0)


% face3 = [2:end-1,2:end-1,2:end-1;
%     2:end-1,2:end-1,2:end-1-1;
%     1:end-2,2:end-1,1:end-2;
%     1:end-2,2:end-1,k);
en31 = cat(4, 0.5*(dUxdy_ijk+dUydx_ijk), dUydy_ijk, 0.5*(dUydz_ijk+dUzdy_ijk));

en32 = cat(4, 0.5*(dUxdy_ijk1+dUydx_ijk1), dUydy_ijk1, 0.5*(dUydz_ijk1+dUzdy_ijk1));

en33 = cat(4, 0.5*(dUxdy_i1jk1+dUydx_i1jk1), dUydy_i1jk1, 0.5*(dUydz_i1jk1+dUzdy_i1jk1));

en34 = cat(4, 0.5*(dUxdy_i1jk+dUydx_i1jk), dUydy_i1jk, 0.5*(dUydz_i1jk+dUzdy_i1jk));

en3 = 0.25*(en31+en32+en33+en34)*dx*dz; % = int_face3 e(u)n ds


div31 = dUxdx_ijk + dUydy_ijk + dUzdz_ijk;
div32 = dUxdx_ijk1 + dUydy_ijk1 + dUzdz_ijk1;
div33 = dUxdx_i1jk1 + dUydy_i1jk1 + dUzdz_i1jk1;
div34 = dUxdx_i1jk + dUydy_i1jk + dUzdz_i1jk;

div3 = 0.25*(div31 + div32 + div33 + div34)*dx*dz; % recall that n3=(0,1,0)



% face4 = [1:end-2,1:end-2,1:end-2;
%     2:end-1,1:end-2,1:end-2;
%     2:end-1,1:end-2,k;
%     1:end-2,1:end-2,k];
en41 = cat(4, 0.5*(dUxdy_i1j1k1+dUydx_i1j1k1), dUydy_i1j1k1, 0.5*(dUydz_i1j1k1+dUzdy_i1j1k1));

en42 = cat(4, 0.5*(dUxdy_ij1k1+dUydx_ij1k1), dUydy_ij1k1, 0.5*(dUydz_ij1k1+dUzdy_ij1k1));

en43 = cat(4, 0.5*(dUxdy_ij1k+dUydx_ij1k), dUydy_ij1k, 0.5*(dUydz_ij1k+dUzdy_ij1k));

en44 = cat(4, 0.5*(dUxdy_i1j1k+dUydx_i1j1k), dUydy_i1j1k, 0.5*(dUydz_i1j1k+dUzdy_i1j1k));

en4 = -0.25*(en41+en42+en43+en44)*dx*dz; % = int_face4 e(u)n ds


div41 = dUxdx_i1j1k1 + dUydy_i1j1k1 + dUzdz_i1j1k1;
div42 = dUxdx_ij1k1 + dUydy_ij1k1 + dUzdz_ij1k1;
div43 = dUxdx_ij1k + dUydy_ij1k + dUzdz_ij1k;
div44 = dUxdx_i1j1k + dUydy_i1j1k + dUzdz_i1j1k;

div4 = 0.25*(div41 + div42 + div43 + div44)*dx*dz; % recall that n4=(0,-1,0)


% face5 = [2:end-1,2:end-1,2:end-1;
%     1:end-2,2:end-1,k;
%     1:end-2,1:end-2,k;
%     2:end-1,1:end-2,k];
en51 = cat(4, 0.5*(dUxdz_ijk+dUzdx_ijk), 0.5*(dUydz_ijk+dUzdy_ijk), dUzdz_ijk);

en52 = cat(4, 0.5*(dUxdz_i1jk+dUzdx_i1jk), 0.5*(dUydz_i1jk+dUzdy_i1jk), dUzdz_i1jk);

en53 = cat(4, 0.5*(dUxdz_i1j1k+dUzdx_i1j1k), 0.5*(dUydz_i1j1k+dUzdy_i1j1k), dUzdz_i1j1k);

en54 = cat(4, 0.5*(dUxdz_ij1k+dUzdx_ij1k), 0.5*(dUydz_ij1k+dUzdy_ij1k), dUzdz_ij1k);

en5 = 0.25*(en51+en52+en53+en54)*dx*dy; % = int_face5 e(u)n ds


div51 = dUxdx_ijk + dUydy_ijk + dUzdz_ijk;
div52 = dUxdx_i1jk + dUydy_i1jk + dUzdz_i1jk;
div53 = dUxdx_i1j1k + dUydy_i1j1k + dUzdz_i1j1k;
div54 = dUxdx_ij1k + dUydy_ij1k + dUzdz_ij1k;

div5 = 0.25*(div51 + div52 + div53 + div54)*dx*dy; % recall n5=(0,0,1)


% face6 = [1:end-2,1:end-2,1:end-2;
%     1:end-2,2:end-1,1:end-2;
%     2:end-1,2:end-1,2:end-1-1;
%     2:end-1,1:end-2,1:end-2];
en61 = cat(4, 0.5*(dUxdz_i1j1k1+dUzdx_i1j1k1), 0.5*(dUydz_i1j1k1+dUzdy_i1j1k1), dUzdz_i1j1k1);

en62 = cat(4, 0.5*(dUxdz_i1jk1+dUzdx_i1jk1), 0.5*(dUydz_i1jk1+dUzdy_i1jk1), dUzdz_i1jk1);

en63 = cat(4, 0.5*(dUxdz_ijk1+dUzdx_ijk1), 0.5*(dUydz_ijk1+dUzdy_ijk1), dUzdz_ijk1);

en64 = cat(4, 0.5*(dUxdz_ij1k1+dUzdx_ij1k1), 0.5*(dUydz_ij1k1+dUzdy_ij1k1), dUzdz_ij1k1);

en6 = -0.25*(en61+en62+en63+en64)*dx*dy; % = int_face6 e(u)n ds


div61 = dUxdx_i1j1k1 + dUydy_i1j1k1 + dUzdz_i1j1k1;
div62 = dUxdx_i1jk1 + dUydy_i1jk1 + dUzdz_i1jk1;
div63 = dUxdx_ijk1 + dUydy_ijk1 + dUzdz_ijk1;
div64 = dUxdx_ij1k1 + dUydy_ij1k1 + dUzdz_ij1k1;

div6 = 0.25*(div61 + div62 + div63 + div64)*dx*dy; % recall that n6=(0,0,-1)




%% Composition of resulting vectors
b = en1 + en2 + en3 + en4 + en5 + en6;
p = cat(4, Ux(2:end-1,2:end-1,2:end-1)*dx*dy*dz, Uy(2:end-1,2:end-1,2:end-1)*dx*dy*dz, Uz(2:end-1,2:end-1,2:end-1)*dx*dy*dz);
q = cat(4, div1-div2, div3-div4, div5-div6);


return;


