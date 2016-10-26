function [Y] = nl_means_2d(X, w, o)
%% 3D non local means denoising
if (nargin < 2) w = 5; end
if (nargin < 3) o = 3; end
means_image = conv2( X, (ones(w,w)./w^2), 'same');
means_vec = means_image(:);
Y = zeros(size(means_vec));
for n = 1:numel(X)
    if (mod(n,1000) == 0) display(n); end
    loc = means_image(n);
    weights = exp(-abs(means_vec-loc) / o^2);
    diffs = abs(means_vec-loc);
    Y(n) = sum(diffs.*weights) / sum(weights);
end
Y = reshape(Y, size(X));