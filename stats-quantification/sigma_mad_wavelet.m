function sigma = sigma_mad_wavelet(volume, mask)
if nargin < 2
    mask = ones(size(vec(volume)));
end
sz = size(volume);
[h0, h1, g0, g1] = daubf(3);
af = [h0 h1];
w = conv(volume(:), h1, 'same');
w_masked = w(logical(mask));
sigma = mad_eb(w_masked) / 0.6745;