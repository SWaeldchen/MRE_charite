function [mu_sfwi, mu_helm] = sanchez_inversion_hq(U, freqvec, spacing, xyz_order)

%mu_sfwi includes all first and second order gradients
%mu_helm neglects all first gradients

% set constants
RHO = 1050;
sz = size(U);
if numel(sz) < 5
    nfreqs = 1;
else
    nfreqs = sz(5);
end
N = sz(1)*sz(2)*sz(3);
if nargin < 4
    xyz_order = [1 2 3];
end
y_diags = [0 1];
x_diags = [0 sz(1)];
z_diags = [0 sz(1)*sz(2)];
onevec = ones(N,1);

% set variable scope
f = [];
K1_helm = [];
K1_sfwi = [];

% create some functions that make the main loop really clean
x_grad_kern = [1 -1]  / spacing(1);
y_grad_kern = [1; -1]  / spacing(2);
z_grad_kern = zeros(1,1,2); z_grad_kern(:) = [1 -1]  / spacing(3);

xgrad = @(v) convn(cell2mat(v), x_grad_kern, 'same');
ygrad = @(v) convn(cell2mat(v), y_grad_kern, 'same');
zgrad = @(v) convn(cell2mat(v), z_grad_kern, 'same');

om = @(x) 2*pi*x;
spdiag = @(x) spdiags(x(:), 0, N, N);
spdiag_ = @(x) spdiags(vec(cell2mat(x)), 0, N, N);

% stack for n frequencies
for n = 1:nfreqs
    
    U_x = U(:,:,:,xyz_order(1),n);
    U_y = U(:,:,:,xyz_order(2),n);
    U_z = U(:,:,:,xyz_order(3),n);

    [x_x, x_y, x_z] = gradient(U_x, spacing(1), spacing(2), spacing(3));
    [y_x, y_y, y_z] = gradient(U_y, spacing(1), spacing(2), spacing(3));
    [z_x, z_y, z_z] = gradient(U_z, spacing(1), spacing(2), spacing(3));
    
    % INFINITESIMAL STRAIN TENSOR
    E = {   { x_x         }  {(x_y + y_x)/2}  {(x_z + z_x)/2}    ;   ...
            {(y_x + x_y)/2}  { y_y         }  {(y_z + z_y)/2}    ;   ...
            {(z_x + x_z)/2}  {(z_y + y_z)/2}  {z_z          }     };
        
    div_x = xgrad(E{1,1}) + ygrad(E{1,2}) + zgrad(E{1,3}); 
    div_y = xgrad(E{2,1}) + ygrad(E{2,2}) + zgrad(E{2,3}); 
    div_z = xgrad(E{3,1}) + ygrad(E{3,2}) + zgrad(E{3,3}); 
    
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
    
    f = cat(1, f, -RHO*om(freqvec(n)).^2.*[U_x(:); U_y(:); U_z(:)]);
end

% SFWI matrix K2 = [I; NablaX; NablaY; NablaZ]
% This is just the identity matrix in HELM

K2_helm = speye(N);
K2_sfwi = [  speye(N); ...
             spdiags([-onevec onevec]/spacing(1), x_diags, N, N); ...
             spdiags([-onevec onevec]/spacing(2), y_diags, N, N); ...
             spdiags([-onevec onevec]/spacing(3), z_diags, N, N); ];

K_helm = K1_helm*K2_helm;
K_sfwi = K1_sfwi*K2_sfwi;

% Ku = f . LSQR method is faster and much less memory intensive than
% backslash. You should get convergence before 1000.

%u_helm = lsqr(K_helm, f, 1e-15, 1000);
u_helm = HQ_Multiplicative(zeros(sz(1), sz(2), sz(3)),f,K_helm,'hub',0.3,10,1e-15,100);
mu_helm = reshape(u_helm, [sz(1) sz(2) sz(3)]);

%u_sfwi = lsqr(K_sfwi, f, 1e-15, 1000);
u_sfwi = HQ_Multiplicative(zeros(sz(1), sz(2), sz(3)),f,K_sfwi,'hub',0.3,10,1e-15,100);
mu_sfwi = reshape(u_sfwi, [sz(1) sz(2) sz(3)]);

end
