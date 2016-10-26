function [mags_full, mags_trunc] = run_gabor_test(noiseLevel)

if (nargin == 0) 
    noiseLevel = 0;
end

u = make_spatial_frequency_vectors(noiseLevel);
mags_full = zeros(128);
mags_trunc = zeros(128);

for m = 3:128
    for n = 3:128
        [full, trunc] = gabor1d(n);
        mags_full(m,n) = sum(abs(conv(u(m,:), full)));
        mags_trunc(m,n) = sum(abs(conv(u(m,:), trunc)));
    end
end
mags_full = mags_full(3:end,3:end);
mags_trunc = mags_trunc(3:end,3:end);
