function mu = full_wave_inversion(U, freqvec, spacing)

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
    [K_n, f_n] = build_single_frequency_sandbox(U(:,:,:,:,n), freqvec(n), spacing);
    K = cat(1, K, K_n);
    f = cat(1, f, f_n);
end

tic

zeros_sz = size(K, 2);
lb = zeros(zeros_sz, 1);

tic
mu = K \ f;
toc

% add missing constants
RHO = 1050;
grid = spacing(1);
mu = reshape(mu, [sz(1) sz(2) sz(3)])*RHO*grid;