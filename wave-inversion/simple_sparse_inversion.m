function mu = simple_sparse_inversion(U, freqvec, spacing)

sz = size(U);
N = sz(1)*sz(2)*sz(3);
RHO = 1050;
spdiag = @(x) spdiags(x(:), 0, N, N);
om = @(x) 2*pi*x;
K = [];
f = [];

for n = 1:sz(5)
    U_n = U(:,:,:,:,n);
    U_lap = get_compact_laplacian(U_n, spacing, 0);
    K_n = [spdiag(U_lap(:,:,:,1)); spdiag(U_lap(:,:,:,2)); spdiag(U_lap(:,:,:,3))];
    K = cat(1, K, K_n);  
    f = cat(1, f, -RHO.*om(freqvec(n)).^2.*U_n(:));
end

u = lsqr(K, f, 1e-6, 1000);
mu = reshape(u, sz(1), sz(2), sz(3));
    
