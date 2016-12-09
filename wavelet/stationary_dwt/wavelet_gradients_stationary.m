function [u_x, u_y, u_z] = wavelet_gradients_stationary(U, J, spacing)

if nargin > 3
    spacing = [1 1 1];
end
sz = size(U);

% Dualtree complex denoising 
% with overlapping group sparsity thresholding

%[Faf, Fsf] = FSfarras;
%[af, sf] = dualfilt1;
[af, sf] = farras;

mirrorpad = @(U, padding) cat(3, U(:,:,padding+1:-1:2), U, U(:,:,end-1:-1:(end-padding)));
demirrorpad = @(U, padding) cat(3, U(:,:,padding+1:1:end-padding));


%L = size(af{1}, 1);
L = 10;
padding = round(L/2);

if nargin < 2
	J = 1;
end
U_mirror = mirrorpad(U, padding);
sz_mir = size(U_mirror);
w = dwt3D_u(U_mirror,J,af);
w_x = w;
w_y = w;
w_z = w;
w_lo = w{J+1};
%w_y_lo = w_y{J+1};
%w_z_lo = w_z{J+1};
%diff_y = diff(w_y_lo, 1, 1);
%diff_y = cat(1, diff_y, diff_y(end,:,:));
%diff_x = diff(w_x_lo, 1, 2);
%diff_x = cat(2, diff_x, diff_x(:,end,:));
%diff_z = diff(w_z_lo, 1, 3);
%diff_z = cat(3, diff_z, diff_z(:,:,end));
%w_x{J+1} = diff_x;
%w_y{J+1} = diff_y;
%w_z{J+1} = diff_z;
[w_x{J+1}, w_y{J+1}, w_z{J+1}] = gradient(w_lo);
u_x = demirrorpad(simplecrop(idwt3D_u(w_x,J,sf), sz_mir),padding) ./ spacing(1);
u_y = demirrorpad(simplecrop(idwt3D_u(w_y,J,sf), sz_mir),padding) ./ spacing(2);
u_z = demirrorpad(simplecrop(idwt3D_u(w_z,J,sf), sz_mir),padding) ./ spacing(3);

