function sigma = mad_est_2d(volume, mask)
if nargin < 2
    mask = ones(size(volume));
end
sz = size(volume);
[h0, h1, g0, g1] = daubf(3);
w = udwt2D(volume, 1, h0, h1);
w = crop_hipass(w, h0);
coef_cat = cell2cat(w{1});
mask = vec(mask);
mask = repmat(mask(:), [3 1]);
%disp(['coef ',num2str(numel(coef_cat)),' mask ',num2str(numel(mask_cat))])
volvec = coef_cat(:) .* mask;
% kill nan
volvec(isnan(volvec)) = 0;
% exclude zero
volvec_nonzero = volvec(volvec ~= 0);
volvec_median = median(real(volvec_nonzero));
sigma = 1.4826*median(abs(volvec_nonzero - volvec_median));

end

function w = crop_hipass(w, h0)
c_len = numel(h0)-1;
w{2} = w{2}(1:end-c_len, 1:end-c_len);
w{1}{1} = w{1}{1}(1:end-c_len,c_len+1:end);
w{1}{2} = w{1}{2}(c_len+1:end,1:end-c_len);
w{1}{3} = w{1}{3}(c_len+1:end,c_len+1:end);
end