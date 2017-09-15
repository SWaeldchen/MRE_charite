function [u_lo, u_hi] = denoise_separate_volume_2D(u, K, lambda, J)

% Dualtree complex denoising 
% with overlapping group sparsity thresholding

pad1 = nextpwr2(size(u,1));
pad2 = nextpwr2(size(u,2));
u_pad = simplepad(u, [pad1, pad2]);
SCALES = 2;
s = SLgetShearletSystem2D(0, pad1, pad2, nScales);
% loop thru scales
dec = SLsheardec2D(u_pad, s);
