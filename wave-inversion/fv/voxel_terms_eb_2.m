function [b,p,q] = voxel_terms_eb_2(U,spacing)
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
% J. Mura (2017) de-spaghettified by E. Barnhill (2017)

sz = size(U);
sz_adj = sz-3;
dx = spacing(1); dy = spacing(2); dz = spacing(3);

[DUx, Ux] = gradestim4d(U(:,:,:,1), spacing);
[DUy, Uy] = gradestim4d(U(:,:,:,2), spacing);
[DUz, Uz] = gradestim4d(U(:,:,:,3), spacing);

D = cat(5, DUx, DUy, DUz);

% vertex functions -- no need to repeat these over and over
ijk  = @(x) x(2:end-1, 2:end-1, 2:end-1);
i1jk = @(x) x(1:end-2, 2:end-1, 2:end-1);
ij1k = @(x) x(2:end-1, 1:end-2, 2:end-1);
ijk1 = @(x) x(2:end-1, 2:end-1, 1:end-2);
i1j1k = @(x) x(1:end-2, 1:end-2, 2:end-1); 
ij1k1 = @(x) x(2:end-1, 1:end-2, 1:end-2);
i1jk1 = @(x) x(1:end-2, 2:end-1, 1:end-2);
i1j1k1 = @(x) x(1:end-2, 1:end-2, 1:end-2);
vertex_fns = {ijk, i1jk, ij1k, ijk1, i1j1k, ij1k1, i1jk1, i1j1k1};
% call them below by string -- easier to read, better protect. against bugs
vertex_fn_strings = {'ijk', 'i1jk', 'ij1k', 'ijk1', 'i1j1k', 'ij1k1', 'i1jk1', 'i1j1k1'};
getv = @(s) vertex_fns{strcmp(vertex_fn_strings, s)};

% organization is: which VERTEX of which DERIVATIVE of which DIRECTION 
Ds = cell(3, 3, 8);

%% Derivatives at vertex (i,j,k)
for direc = 1:3
    for deriv = 1:3
        for vertex = 1:8
            df = vertex_fns{vertex};
            Ds{vertex, deriv, direc} = df(D(:,:,:,deriv, direc));
        end
    end
end

%% Indices related to each face (numbered from 1 to 6)

% set vertex functions for each face
vertices = {
    {getv('ijk'), getv('ij1k'), getv('ij1k1'), getv('ijk1')}, ... 
    {getv('i1j1k1'), getv('i1j1k'), getv('i1jk'), getv('i1jk1')}, ...
    {getv('ijk'), getv('ijk1'), getv('i1jk1'), getv('i1jk')}, ...
    {getv('i1j1k1'), getv('ij1k1'), getv('ij1k'), getv('i1j1k')}, ...
    {getv('ijk'), getv('i1jk'), getv('i1j1k'), getv('ij1k')}, ...
    {getv('i1j1k1'), getv('i1jk1'), getv('ijk1'), getv('ij1k1')} ...
      };

% set directions for each face
en_direcs = {
    {{1,1},{1,2},{1,3}}, ... %en1
    {{1,1},{1,2},{1,3}}, ... %en2
    {{1,2},{2,2},{2,3}}, ... %en3
    {{1,2},{2,2},{2,3}}, ... %en4
    {{1,3},{2,3},{3,3}}, ... %en5
    {{1,3},{2,3},{3,3}} ... %en6
        };

% set direction of derivative for each face
en_derivs = {
    {{1,1},{2,1},{3,1}}, ... %en1
    {{1,1},{2,1},{3,1}}, ... %en2
    {{2,1},{2,2},{3,2}}, ... %en3
    {{2,1},{2,2},{3,2}}, ... %en4
    {{3,1},{3,2},{3,3}}, ... %en5
    {{3,1},{3,2},{3,3}} ... %en6
    };

% set which differentials to use (e.g. 1 = spacing(1))
dims = {{2,3}, {2,3}, {1,3}, {1,3}, {1,2}, {1,2}};

en = cell(6,1);
div = cell(6,1);

en_edge = zeros(sz_adj(1), sz_adj(2), sz_adj(3), 3);

for face = 1:6
    en{face} = 0;
    div{face} = 0;
    for edge = 1:4
        vertex_fn = vertices{face}{edge};
        for e = 1:3
            en_edge(:,:,:,e) = ...
                0.5 * (vertex_fn(D(:,:,:,en_derivs{face}{e}{1},en_direcs{face}{e}{1})) + ...
                   vertex_fn(D(:,:,:,en_derivs{face}{e}{2},en_direcs{face}{e}{2})));
        end
        en{face} = en{face} + en_edge;
        div_edge = vertex_fn(D(:,:,:,1,1)) + vertex_fn(D(:,:,:,2,2)) + vertex_fn(D(:,:,:,3,3));
        div{face} = div{face} + div_edge;
    end
    en{face} = 0.25*en{face}*spacing(dims{face}{1})*spacing(dims{face}{2});
    if mod(face,2) == 0
        en{face} = -en{face};
    end
    div{face} = 0.25*div{face}*spacing(dims{face}{1})*spacing(dims{face}{2});
end

%% Composition of resulting vectors
b = en{1} + en{2} + en{3} + en{4} + en{5} + en{6};
p = cat(4, ijk(Ux)*dx*dy*dz, ijk(Uy)*dx*dy*dz, ijk(Uz)*dx*dy*dz);
q = cat(4, div{1}-div{2}, div{3}-div{4}, div{5}-div{6});

return;


