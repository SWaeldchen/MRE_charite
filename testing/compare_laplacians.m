function [lap1, lap2] = compare_laplacians(U, spacing)

%mu_sfwi includes all first and second order gradients
%mu_helm neglects all first gradients

% set constants
sz = size(U);

% create FD gradient functions
x_grad_kern = [1 -1]  / spacing(1);
y_grad_kern = [1; -1]  / spacing(2);
z_grad_kern = zeros(1,1,2); z_grad_kern(:) = [1 -1]  / spacing(3);

xgrad = @(v) convn(v, x_grad_kern, 'same');
ygrad = @(v) convn(v, y_grad_kern, 'same');
zgrad = @(v) convn(v, z_grad_kern, 'same');

lap1 = get_compact_laplacian(U, spacing, 0);
lap2 = xgrad(xgrad(U)) + ygrad(ygrad(U)) + zgrad(zgrad(U));
