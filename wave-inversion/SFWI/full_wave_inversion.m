function mu = full_wave_inversion(U, freqvec, spacing, diff_meth, inv_meth)

if nargin < 5
    inv_meth = 1;
    if nargin < 4
        diff_meth = 1;
    end
end

sz = size(U);
if numel(sz) < 5
    d5 = 1;
else
    d5 = sz(5);
end

if sz(4) ~= 3 || d5 ~= numel(freqvec)
    disp('data not valid');
    return
end

K = [];
f = [];
for n = 1:d5
    [K_n, f_n, ord_vec, sz_pad] = build_single_frequency(U(:,:,:,:,n), freqvec(n), spacing, diff_meth);
    %[K_n, f_n] = build_single_frequency_sandbox(U(:,:,:,:,n), freqvec(n), spacing, diff_meth);
    K = cat(1, K, K_n);
    f = cat(1, f, f_n);
end
clear K_n f_n


if inv_meth == 1
    % backslash / L2
    
    % + TEST EB
    % f = real(f);
    % - TEST EB

    mu = K \ f; 
    mu = reshape(mu, [sz_pad(1) sz_pad(2) sz_pad(3)]);
    
elseif inv_meth == 2
    % LSQR
    
    niter = 700;
     % + TEST EB
    % f = real(f);
    % - TEST EB
    [mu, flag, relres] = lsqr_eb(K, f, 1e-6, niter,[], [], []);
    
    disp(['Convergence flag: ',num2str(flag), ' residual ',num2str(relres)])
    mu = reshape(mu, [sz_pad(1) sz_pad(2) sz_pad(3)]);
elseif inv_meth == 3
    % HQ - reshape in method
    mu = HQ_Additive_2(zeros(sz_pad(1), sz_pad(2), sz_pad(3)),f,K,'hub',0.1,1);
end
% DE-PAD
firsts = find(ord_vec == 1);
mu = mu(:,:,firsts(1):firsts(1)+sz(3)-1);
mu = simplecrop(mu, sz);


