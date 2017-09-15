function [mu_sfwi] = sfwi_super_3(U, freqvec, spacing, xyz_order, kern_ord)

%mu_sfwi includes all first and second order gradients
%mu_helm neglects all first gradients
%U = mir(U);
% set constants
RHO = 1000;
sz = size(U);
if numel(sz) < 5
    nfreqs = 1;
else
    nfreqs = sz(5);
end
N = sz(1)*sz(2)*sz(3)*8;
if nargin < 5
    nohelm = 0;
    if nargin < 4
        xyz_order = [1 2 3];
    end
end
y_diags = [0 1];
x_diags = [0 sz(1)];
z_diags = [0 sz(1)*sz(2)];
onevec = ones(N,1);
% set variable scope
f = [];
K1_helm = [];
K1_sfwi = [];

% create FD gradient functions
if nargin < 6
    kern = [0.5 0 -0.5];
else
    switch kern_ord
        case 1
             kern = [1 -1];
        case 2
            kern = [0.5 0 -0.5];
        case 3
            kern = [1/12 -2/3 0 2/3 -1/12];
    end
end
x_grad_kern = kern  / spacing(1);
y_grad_kern = kern'  / spacing(2);
z_grad_kern = zeros(1,1,numel(kern)); z_grad_kern(:) = kern  / spacing(3);

xgrad_ = @(v) convn(cell2mat(v), x_grad_kern, 'same');
ygrad_ = @(v) convn(cell2mat(v), y_grad_kern, 'same');
zgrad_ = @(v) convn(cell2mat(v), z_grad_kern, 'same');

% create some other functions
om = @(x) 2*pi*x;
spdiag = @(x) spdiags(x(:), 0, N, N);
spdiag_ = @(x) spdiags(vec(cell2mat(x)), 0, N, N);
s = spacing; % for clarity of formulas

% stack for n frequencies
for n = 1:nfreqs
    
    U_x = double(U(:,:,:,xyz_order(1),n)); %nifti complex format is single
    U_y = double(U(:,:,:,xyz_order(2),n));
    U_z = double(U(:,:,:,xyz_order(3),n));
    
    x_x = xgrad(U_x,s); x_y = ygrad(U_x,s); x_z = zgrad(U_x,s);
    y_x = xgrad(U_y,s); y_y = ygrad(U_y,s); y_z = zgrad(U_y,s);
    z_x = xgrad(U_z,s); z_y = ygrad(U_z,s); z_z = zgrad(U_z,s);

    % INFINITESIMAL STRAIN TENSOR
    %E = {   { 2*x_x         }  {(x_y + y_x)}  {(x_z + z_x)}    ;   ...
    %        {(y_x + x_y)}  { 2*y_y         }  {(y_z + z_y)}    ;   ...
    %        {(z_x + x_z)}  {(z_y + y_z)}  {2*z_z          }     };
    
    E = {   { x_x         }  {(x_y + y_x)/2}  {(x_z + z_x)/2}    ;   ...
            {(y_x + x_y)/2}  { y_y         }  {(y_z + z_y)/2}    ;   ...
            {(z_x + x_z)/2}  {(z_y + y_z)/2}  {z_z          }     };
        
        
    div_x = xgrad_(E{1,1}) + ygrad_(E{1,2}) + zgrad_(E{1,3}); 
    div_y = xgrad_(E{2,1}) + ygrad_(E{2,2}) + zgrad_(E{2,3}); 
    div_z = xgrad_(E{3,1}) + ygrad_(E{3,2}) + zgrad_(E{3,3}); 
    
    % Helmholtz inversion: [ DIVGRAD_E ]
    K1_helm_n = [ spdiag(div_x);  ...
                  spdiag(div_y);  ...
                  spdiag(div_z) ]; 
             
    % SFWI inversion: [ DIVGRAD_E E ]
    K1_sfwi_n = [ spdiag(div_x)    spdiag_(E{1,1})  spdiag_(E{1,2})  spdiag_(E{1,3}); ...
                  spdiag(div_y)    spdiag_(E{2,1})  spdiag_(E{2,2})  spdiag_(E{2,3}); ...
                  spdiag(div_z)    spdiag_(E{3,1})  spdiag_(E{3,2})  spdiag_(E{3,3})  ];
        
    K1_helm = cat(1, K1_helm, K1_helm_n);
    K1_sfwi = cat(1, K1_sfwi, K1_sfwi_n);
    
    %f = cat(1, f, -RHO*om(freqvec(n)).^2.*[U_x(:); U_y(:); U_z(:)]);
    f = cat(1, f, -RHO*om(freqvec(n)).^2.*[vec(interp_3d(U_x,2)); vec(interp_3d(U_y,2)); vec(interp_3d(U_z,2))]);
end

% SFWI matrix K2 = [I; NablaX; NablaY; NablaZ]
% This is just the identity matrix in HELM

K2_helm = spdiag(onevec);
K2_sfwi = [  spdiag(onevec); ...
             spdiags([-onevec onevec]/spacing(1), x_diags, N, N); ...
             spdiags([-onevec onevec]/spacing(2), y_diags, N, N); ...
             spdiags([-onevec onevec]/spacing(3), z_diags, N, N); ];

K_helm = K1_helm*K2_helm;
K_sfwi = K1_sfwi*K2_sfwi;

% Ku = f . LSQR method is faster and less memory intensive than
% backslash. User should get convergence before 1000.

%u_helm = K_helm \ f;
%{
if (nohelm == 0)
    u_helm = lsqr(K_helm, f, 1e-15, 100000);
    mu_helm = reshape(u_helm, [sz(1) sz(2) sz(3)]);
    %mu_helm = mircrop(reshape(u_helm, [sz(1) sz(2) sz(3)]));
end
%}
%u_sfwi = K_sfwi \ f;
u_sfwi = lsqr(K_sfwi, f, 1e-15, 100000);
%mu_sfwi = mircrop(reshape(u_sfwi, [sz(1) sz(2) sz(3)]));
mu_sfwi = reshape(u_sfwi, [sz(1) sz(2) sz(3)]*2);

end

function u_y = ygrad(u, spacing)

    if iscell(u)
        u = cell2mat(u);
    end

    kern_even = [1/12 -2/3 0 2/3 -1/12];
    kern_odd = [1/24 -9/8 0 9/8 -1/24];

    y_grad_kern_even = kern_even'  / spacing(1);
    y_grad_kern_odd = kern_odd'  / spacing(1);

    evens = convn(u, y_grad_kern_even, 'same');
    odds = convn(u, y_grad_kern_odd, 'same');

    u_y = zeros(size(u)*2);
    u_y(1:2:end,   1:2:end, 1:2:end) = evens;
    u_y(2:2:end,   1:2:end, 1:2:end) = odds;
    u_y(:,         2:2:end-2, 1:2:end) = (u_y(:, 1:2:end-3, 1:2:end) + u_y(:, 3:2:end, 1:2:end))/2;
    u_y(:,:,2:2:end-2) = (u_y(:,:,1:2:end-3) + u_y(:,:,3:2:end));
    
end

function u_x = xgrad(u, spacing)

    if iscell(u)
        u = cell2mat(u);
    end

    kern_even = [1/12 -2/3 0 2/3 -1/12];
    kern_odd = [1/24 -9/8 0 9/8 -1/24];

    x_grad_kern_even = kern_even  / spacing(1);
    x_grad_kern_odd = kern_odd  / spacing(1);

    evens = convn(u, x_grad_kern_even, 'same');
    odds = convn(u, x_grad_kern_odd, 'same');

    u_x = zeros(size(u)*2);
    u_x(1:2:end,     1:2:end,   1:2:end) = evens;
    u_x(1:2:end,     2:2:end,   1:2:end) = odds;
    u_x(2:2:end-2,   :,         1:2:end) = (u_x(1:2:end-3,:,1:2:end) + u_x(3:2:end,:,1:2:end))/2;
    u_x(:,:,2:2:end-2) = (u_x(:,:,1:2:end-3) + u_x(:,:,3:2:end))/2;
    
end

function u_z = zgrad(u, spacing)

    if iscell(u)
        u = cell2mat(u);
    end

    kern_even = [1/12 -2/3 0 2/3 -1/12];
    kern_odd = [1/24 -9/8 0 9/8 -1/24];
    
    z_grad_kern_even = zeros(1,1,numel(kern_even)); 
    z_grad_kern_even(:) = kern_even  / spacing(3);
    z_grad_kern_odd = zeros(1,1,numel(kern_odd)); 
    z_grad_kern_odd(:) = kern_odd  / spacing(3);

    evens = convn(u, z_grad_kern_even, 'same');
    odds = convn(u, z_grad_kern_odd, 'same');

    u_z = zeros(size(u)*2);
    u_z(1:2:end,     1:2:end, 1:2:end) = evens;
    u_z(1:2:end,     1:2:end, 2:2:end) = odds;
    u_z(2:2:end-2,   1:2:end, :) = (u_z(1:2:end-3,1:2:end,:) + u_z(3:2:end,1:2:end,:))/2;
    u_z(:,2:2:end-2,:) = (u_z(:,1:2:end-3,:) + u_z(:,3:2:end,:))/2;
    
end
