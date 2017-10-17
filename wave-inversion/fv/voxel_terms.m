function [b,p,q] = voxel_terms(i,j,k,f,dd)
% Evaluation of voxelwise integral terms, around a voxel indexed as i,j,k.
%
% [b,p,q] = voxel_terms(i,j,k,freq,[dx,dy,dz])
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
% DUx(i,j,k,:,f)) = [dUx/dx,dUx/dy,dUx/dz](i,j,k) 
% at freq 'f', where ijk is not the voxel center but 
% the right-upper-front node in the cube that represents 
% the voxel ijk.
%
% In 2D would be like this
%
%    (i-1,j) -----------------(i,j)         Physical coordinates
%       |                       |
%       |                       |           ^ +y(j)
%       |         [i,j]         |           |
%       |                       |           |
%       |                       |           +---> +x(i)
%    (i-1,j-1) ---------------(i,j-1)
%
% J. Mura (2017)


global Ux Uy Uz DUx DUy DUz; % shares memory... I know, it is not a well-practice for programmers, but there is no pointers in Matlab.

dx = dd(1); dy = dd(2); dz = dd(3);


% Now we collect the information from the 8 vertices around
% the voxel [i,j,k]:


%% Derivatives at vertex (i,j,k)
dUxdx_ijk = squeeze(DUx(i,j,k,1,f));
dUydx_ijk = squeeze(DUy(i,j,k,1,f));
dUzdx_ijk = squeeze(DUz(i,j,k,1,f));
dUxdy_ijk = squeeze(DUx(i,j,k,2,f));
dUydy_ijk = squeeze(DUy(i,j,k,2,f));
dUzdy_ijk = squeeze(DUz(i,j,k,2,f));
dUxdz_ijk = squeeze(DUx(i,j,k,3,f));
dUydz_ijk = squeeze(DUy(i,j,k,3,f));
dUzdz_ijk = squeeze(DUz(i,j,k,3,f));
                
% Derivatives at vertex (i-1,j,k)
dUxdx_i1jk = squeeze(DUx(i-1,j,k,1,f));
dUydx_i1jk = squeeze(DUy(i-1,j,k,1,f));
dUzdx_i1jk = squeeze(DUz(i-1,j,k,1,f));
dUxdy_i1jk = squeeze(DUx(i-1,j,k,2,f));
dUydy_i1jk = squeeze(DUy(i-1,j,k,2,f));
dUzdy_i1jk = squeeze(DUz(i-1,j,k,2,f));
dUxdz_i1jk = squeeze(DUx(i-1,j,k,3,f));
dUydz_i1jk = squeeze(DUy(i-1,j,k,3,f));
dUzdz_i1jk = squeeze(DUz(i-1,j,k,3,f));
                
% Derivatives at vertex (i,j-1,k)
dUxdx_ij1k = squeeze(DUx(i,j-1,k,1,f));
dUydx_ij1k = squeeze(DUy(i,j-1,k,1,f));
dUzdx_ij1k = squeeze(DUz(i,j-1,k,1,f));
dUxdy_ij1k = squeeze(DUx(i,j-1,k,2,f));
dUydy_ij1k = squeeze(DUy(i,j-1,k,2,f));
dUzdy_ij1k = squeeze(DUz(i,j-1,k,2,f));
dUxdz_ij1k = squeeze(DUx(i,j-1,k,3,f));
dUydz_ij1k = squeeze(DUy(i,j-1,k,3,f));
dUzdz_ij1k = squeeze(DUz(i,j-1,k,3,f));
                
% Derivatives at vertex (i,j,k-1)
dUxdx_ijk1 = squeeze(DUx(i,j,k-1,1,f));
dUydx_ijk1 = squeeze(DUy(i,j,k-1,1,f));
dUzdx_ijk1 = squeeze(DUz(i,j,k-1,1,f));
dUxdy_ijk1 = squeeze(DUx(i,j,k-1,2,f));
dUydy_ijk1 = squeeze(DUy(i,j,k-1,2,f));
dUzdy_ijk1 = squeeze(DUz(i,j,k-1,2,f));
dUxdz_ijk1 = squeeze(DUx(i,j,k-1,3,f));
dUydz_ijk1 = squeeze(DUy(i,j,k-1,3,f));
dUzdz_ijk1 = squeeze(DUz(i,j,k-1,3,f));

% Derivatives at vertex (i-1,j-1,k)
dUxdx_i1j1k = squeeze(DUx(i-1,j-1,k,1,f));
dUydx_i1j1k = squeeze(DUy(i-1,j-1,k,1,f));
dUzdx_i1j1k = squeeze(DUz(i-1,j-1,k,1,f));
dUxdy_i1j1k = squeeze(DUx(i-1,j-1,k,2,f));
dUydy_i1j1k = squeeze(DUy(i-1,j-1,k,2,f));
dUzdy_i1j1k = squeeze(DUz(i-1,j-1,k,2,f));
dUxdz_i1j1k = squeeze(DUx(i-1,j-1,k,3,f));
dUydz_i1j1k = squeeze(DUy(i-1,j-1,k,3,f));
dUzdz_i1j1k = squeeze(DUz(i-1,j-1,k,3,f));

% Derivatives at vertex (i,j-1,k-1)
dUxdx_ij1k1 = squeeze(DUx(i,j-1,k-1,1,f));
dUydx_ij1k1 = squeeze(DUy(i,j-1,k-1,1,f));
dUzdx_ij1k1 = squeeze(DUz(i,j-1,k-1,1,f));
dUxdy_ij1k1 = squeeze(DUx(i,j-1,k-1,2,f));
dUydy_ij1k1 = squeeze(DUy(i,j-1,k-1,2,f));
dUzdy_ij1k1 = squeeze(DUz(i,j-1,k-1,2,f));
dUxdz_ij1k1 = squeeze(DUx(i,j-1,k-1,3,f));
dUydz_ij1k1 = squeeze(DUy(i,j-1,k-1,3,f));
dUzdz_ij1k1 = squeeze(DUz(i,j-1,k-1,3,f));

% Derivatives at vertex (i-1,j,k-1)
dUxdx_i1jk1 = squeeze(DUx(i-1,j,k-1,1,f));
dUydx_i1jk1 = squeeze(DUy(i-1,j,k-1,1,f));
dUzdx_i1jk1 = squeeze(DUz(i-1,j,k-1,1,f));
dUxdy_i1jk1 = squeeze(DUx(i-1,j,k-1,2,f));
dUydy_i1jk1 = squeeze(DUy(i-1,j,k-1,2,f));
dUzdy_i1jk1 = squeeze(DUz(i-1,j,k-1,2,f));
dUxdz_i1jk1 = squeeze(DUx(i-1,j,k-1,3,f));
dUydz_i1jk1 = squeeze(DUy(i-1,j,k-1,3,f));
dUzdz_i1jk1 = squeeze(DUz(i-1,j,k-1,3,f));

% Derivatives at vertex (i-1,j-1,k-1)
dUxdx_i1j1k1 = squeeze(DUx(i-1,j-1,k-1,1,f));
dUydx_i1j1k1 = squeeze(DUy(i-1,j-1,k-1,1,f));
dUzdx_i1j1k1 = squeeze(DUz(i-1,j-1,k-1,1,f));
dUxdy_i1j1k1 = squeeze(DUx(i-1,j-1,k-1,2,f));
dUydy_i1j1k1 = squeeze(DUy(i-1,j-1,k-1,2,f));
dUzdy_i1j1k1 = squeeze(DUz(i-1,j-1,k-1,2,f));
dUxdz_i1j1k1 = squeeze(DUx(i-1,j-1,k-1,3,f));
dUydz_i1j1k1 = squeeze(DUy(i-1,j-1,k-1,3,f));
dUzdz_i1j1k1 = squeeze(DUz(i-1,j-1,k-1,3,f));


%% Indices related to each face (numbered from 1 to 6)

% Now, perform the (approximate) integration around each voxel...

% face1 = [i,j,k;
%     i,j-1,k;
%     i,j-1,k-1;
%     i,j,k-1];
en11 = [dUxdx_ijk;
    0.5*(dUxdy_ijk+dUydx_ijk);
    0.5*(dUxdz_ijk+dUzdx_ijk)];

en12 = [dUxdx_ij1k;
    0.5*(dUxdy_ij1k+dUydx_ij1k);
    0.5*(dUxdz_ij1k+dUzdx_ij1k)];

en13 = [dUxdx_ij1k1;
    0.5*(dUxdy_ij1k1+dUydx_ij1k1);
    0.5*(dUxdz_ij1k1+dUzdx_ij1k1)];

en14 = [dUxdx_ijk1;
    0.5*(dUxdy_ijk1+dUydx_ijk1);
    0.5*(dUxdz_ijk1+dUzdx_ijk1)];

en1 = 0.25*(en11+en12+en13+en14)*dy*dz; % = int_face1 e(u)n ds


div11 = dUxdx_ijk + dUydy_ijk + dUzdz_ijk;
div12 = dUxdx_ij1k + dUydy_ij1k + dUzdz_ij1k;
div13 = dUxdx_ij1k1 + dUydy_ij1k1 + dUzdz_ij1k1;
div14 = dUxdx_ijk1 + dUydy_ijk1 + dUzdz_ijk1;

div1 = 0.25*(div11 + div12 + div13 + div14)*dy*dz; % recall that n1 = (1,0,0)


% face2 = [i-1,j-1,k-1;
%     i-1,j-1,k;
%     i-1,j,k;
%     i-1,j,k-1];
en21 = [dUxdx_i1j1k1;
    0.5*(dUxdy_i1j1k1+dUydx_i1j1k1);
    0.5*(dUxdz_i1j1k1+dUzdx_i1j1k1)];

en22 = [dUxdx_i1j1k;
    0.5*(dUxdy_i1j1k+dUydx_i1j1k);
    0.5*(dUxdz_i1j1k+dUzdx_i1j1k)];

en23 = [dUxdx_i1jk;
    0.5*(dUxdy_i1jk+dUydx_i1jk);
    0.5*(dUxdz_i1jk+dUzdx_i1jk)];

en24 = [dUxdx_i1jk1;
    0.5*(dUxdy_i1jk1+dUydx_i1jk1);
    0.5*(dUxdz_i1jk1+dUzdx_i1jk1)];

en2 = -0.25*(en21+en22+en23+en24)*dy*dz; % = int_face2 e(u)n ds


div21 = dUxdx_i1j1k1 + dUydy_i1j1k1 + dUzdz_i1j1k1;
div22 = dUxdx_i1j1k + dUydy_i1j1k + dUzdz_i1j1k;
div23 = dUxdx_i1jk + dUydy_i1jk + dUzdz_i1jk;
div24 = dUxdx_i1jk1 + dUydy_i1jk1 + dUzdz_i1jk1;

div2 = 0.25*(div21 + div22 + div23 + div24)*dy*dz; % recall that n2=(-1,0,0)


% face3 = [i,j,k;
%     i,j,k-1;
%     i-1,j,k-1;
%     i-1,j,k];
en31 = [0.5*(dUxdy_ijk+dUydx_ijk);
    dUydy_ijk;
    0.5*(dUydz_ijk+dUzdy_ijk)];

en32 = [0.5*(dUxdy_ijk1+dUydx_ijk1);
    dUydy_ijk1;
    0.5*(dUydz_ijk1+dUzdy_ijk1)];

en33 = [0.5*(dUxdy_i1jk1+dUydx_i1jk1);
    dUydy_i1jk1;
    0.5*(dUydz_i1jk1+dUzdy_i1jk1)];

en34 = [0.5*(dUxdy_i1jk+dUydx_i1jk);
    dUydy_i1jk;
    0.5*(dUydz_i1jk+dUzdy_i1jk)];

en3 = 0.25*(en31+en32+en33+en34)*dx*dz; % = int_face3 e(u)n ds


div31 = dUxdx_ijk + dUydy_ijk + dUzdz_ijk;
div32 = dUxdx_ijk1 + dUydy_ijk1 + dUzdz_ijk1;
div33 = dUxdx_i1jk1 + dUydy_i1jk1 + dUzdz_i1jk1;
div34 = dUxdx_i1jk + dUydy_i1jk + dUzdz_i1jk;

div3 = 0.25*(div31 + div32 + div33 + div34)*dx*dz; % recall that n3=(0,1,0)



% face4 = [i-1,j-1,k-1;
%     i,j-1,k-1;
%     i,j-1,k;
%     i-1,j-1,k];
en41 = [0.5*(dUxdy_i1j1k1+dUydx_i1j1k1);
    dUydy_i1j1k1;
    0.5*(dUydz_i1j1k1+dUzdy_i1j1k1)];

en42 = [0.5*(dUxdy_ij1k1+dUydx_ij1k1);
    dUydy_ij1k1;
    0.5*(dUydz_ij1k1+dUzdy_ij1k1)];

en43 = [0.5*(dUxdy_ij1k+dUydx_ij1k);
    dUydy_ij1k;
    0.5*(dUydz_ij1k+dUzdy_ij1k)];

en44 = [0.5*(dUxdy_i1j1k+dUydx_i1j1k);
    dUydy_i1j1k;
    0.5*(dUydz_i1j1k+dUzdy_i1j1k)];

en4 = -0.25*(en41+en42+en43+en44)*dx*dz; % = int_face4 e(u)n ds


div41 = dUxdx_i1j1k1 + dUydy_i1j1k1 + dUzdz_i1j1k1;
div42 = dUxdx_ij1k1 + dUydy_ij1k1 + dUzdz_ij1k1;
div43 = dUxdx_ij1k + dUydy_ij1k + dUzdz_ij1k;
div44 = dUxdx_i1j1k + dUydy_i1j1k + dUzdz_i1j1k;

div4 = 0.25*(div41 + div42 + div43 + div44)*dx*dz; % recall that n4=(0,-1,0)


% face5 = [i,j,k;
%     i-1,j,k;
%     i-1,j-1,k;
%     i,j-1,k];
en51 = [0.5*(dUxdz_ijk+dUzdx_ijk);
    0.5*(dUydz_ijk+dUzdy_ijk);
    dUzdz_ijk];

en52 = [0.5*(dUxdz_i1jk+dUzdx_i1jk);
    0.5*(dUydz_i1jk+dUzdy_i1jk);
    dUzdz_i1jk];

en53 = [0.5*(dUxdz_i1j1k+dUzdx_i1j1k);
    0.5*(dUydz_i1j1k+dUzdy_i1j1k);
    dUzdz_i1j1k];

en54 = [0.5*(dUxdz_ij1k+dUzdx_ij1k);
    0.5*(dUydz_ij1k+dUzdy_ij1k);
    dUzdz_ij1k];

en5 = 0.25*(en51+en52+en53+en54)*dx*dy; % = int_face5 e(u)n ds


div51 = dUxdx_ijk + dUydy_ijk + dUzdz_ijk;
div52 = dUxdx_i1jk + dUydy_i1jk + dUzdz_i1jk;
div53 = dUxdx_i1j1k + dUydy_i1j1k + dUzdz_i1j1k;
div54 = dUxdx_ij1k + dUydy_ij1k + dUzdz_ij1k;

div5 = 0.25*(div51 + div52 + div53 + div54)*dx*dy; % recall n5=(0,0,1)


% face6 = [i-1,j-1,k-1;
%     i-1,j,k-1;
%     i,j,k-1;
%     i,j-1,k-1];
en61 = [0.5*(dUxdz_i1j1k1+dUzdx_i1j1k1);
    0.5*(dUydz_i1j1k1+dUzdy_i1j1k1);
    dUzdz_i1j1k1];

en62 = [0.5*(dUxdz_i1jk1+dUzdx_i1jk1);
    0.5*(dUydz_i1jk1+dUzdy_i1jk1);
    dUzdz_i1jk1];

en63 = [0.5*(dUxdz_ijk1+dUzdx_ijk1);
    0.5*(dUydz_ijk1+dUzdy_ijk1);
    dUzdz_ijk1];

en64 = [0.5*(dUxdz_ij1k1+dUzdx_ij1k1);
    0.5*(dUydz_ij1k1+dUzdy_ij1k1);
    dUzdz_ij1k1];

en6 = -0.25*(en61+en62+en63+en64)*dx*dy; % = int_face6 e(u)n ds


div61 = dUxdx_i1j1k1 + dUydy_i1j1k1 + dUzdz_i1j1k1;
div62 = dUxdx_i1jk1 + dUydy_i1jk1 + dUzdz_i1jk1;
div63 = dUxdx_ijk1 + dUydy_ijk1 + dUzdz_ijk1;
div64 = dUxdx_ij1k1 + dUydy_ij1k1 + dUzdz_ij1k1;

div6 = 0.25*(div61 + div62 + div63 + div64)*dx*dy; % recall that n6=(0,0,-1)




%% Composition of resulting vectors
b = en1 + en2 + en3 + en4 + en5 + en6;
p = [Ux(i,j,k,f)*dx*dy*dz; Uy(i,j,k,f)*dx*dy*dz; Uz(i,j,k,f)*dx*dy*dz];
q = [div1-div2;div3-div4;div5-div6];


return;


