function mu = full_wave_inversion_2d(U, freqvec, spacing, diff_meth, inv_meth)
sz = size(U);
if nargin < 5
    inv_meth = 2;
    if nargin < 4
        diff_meth = 1;
    end
end

K = [];
f = [];
for n = sz(3)
    [K_n, f_n] = build_single_frequency_2d(U(:,:,n), freqvec(n), spacing);
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
    mu = reshape(mu, [sz(1) sz(2)]);
    
elseif inv_meth == 2
    % LSQR
    
    niter = 700;
     % + TEST EB
    
    % f = real(f);
    % - TEST EB
    [mu, flag, relres] = lsqr(K, f, 1e-6, niter,[], [], []);
    
    disp(['Convergence flag: ',num2str(flag), ' residual ',num2str(relres)])
    mu = reshape(mu, [sz(1) sz(2)]);
elseif inv_meth == 3
    % HQ - reshape in method
    mu = HQ_Multiplicative(zeros(sz(1), sz(2)),f,K,'hub',0.1,1);
end
% DE-PAD


