function [u_den] = reverse_hard_thresh(u, J, mask)

if nargin < 4
    mask = ones(size(u,1), size(u,2), size(u,3));
end
% Dualtree complex denoising 
% with overlapping group sparsity thresholding

[h0, h1, g0, g1] = daubf(3);
w = udwt3D(u,J,h0,h1);
% loop thru scales
for j = 1:J
    % loop thru subbands
    MADs = zeros(6,1);
    for s = 2:7
        vol_crop = simplecrop(w{j}{s}, [size(u,1), size(u,2), size(u,3)]);
        MADs(s-1) = get_mad(vol_crop, mask);
    end
    MAD = mean(MADs);
    disp(['Threshing above ', num2str(2*MAD)]);
    pct_removed = numel(w{1}{s}(abs(w{1}{s}) > 2*MAD)) / numel(cell2cat(w{1}));
    w{1}{s}(abs(w{1}{s}) > 2*MAD) = 0;
    disp(['PCT of coefficients altered: ', num2str(pct_removed)]);
end

u_den = iudwt3D(w,J,g0,g1);

