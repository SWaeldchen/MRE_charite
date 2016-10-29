mu_grad = cell(6);
mu_diff = cell(6);
mu_wavelet = cell(6);
freqvec = [18 20 22];
spacing = [.002 .002 .002];
den_fac = .006:.002:.02;
for n = 1:numel(den_fac)
    [mu_grad{n}, mu_diff{n}, mu_wavelet{n}] = sfwi_deriv_tester(firstHarmCorr(:,:,:,:,:,n), freqvec, spacing, 0, 0, den_fac(n));
end


