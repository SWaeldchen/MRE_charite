function mu = full_wave_inversion(U, freqvec, spacing, diff_meth)

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
    [K_n, f_n] = build_single_frequency(U(:,:,:,:,n), freqvec(n), spacing, diff_meth);
    K = cat(1, K, K_n);
    f = cat(1, f, f_n);
end

% (1) Backslash approach
%tic
%mu = K \ f;
%mu = reshape(mu, [sz(1) sz(2) sz(3)]);
%toc

% (2) LSQR approach
%tic
% niter = 1000;
%[mu, flag, relres] = lsqr_eb(K, f, 1e-6, niter,[], [], []);
%toc
%disp(['Convergence flag: ',num2str(flag), ' residual ',num2str(relres)]);

% (3) TGV approach
%tic
%niter = 50;
%chk = 10;
%lam1 = .01;
%lam0 = .05;
%nvols = sz(4)*d5;
%[mu] = tgv_3d(f, lam1, lam0, niter, chk, K, sz(1), sz(2), sz(3), nvols);
%toc
%disp(['Convergence flag: ',num2str(flag), ' residual ',num2str(relres)]);

% (4) HQ approach
mu = HQ_Additive_2(zeros(sz(1), sz(2), sz(3)),f,K,'hub',1,1);

