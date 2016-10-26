function [Y] = nl_means_3d(X, w, o)
%% 3D non local means denoising
if (nargin < 2) w = 5; end;
if (nargin < 3) o = 3; end;
means_image = convn( X, (ones(w,w,w)./w^3), 'same');
means_vec = means_image(:);
Y = zeros(size(means_vec));
for n = 1:numel(X)
    loc = means_image(n);
    weights = exp(-abs(means_vec-loc) / o^2);
    diffs = abs(means_vec-loc);
    Y(n) = sum(diffs.*weights) / sum(weights);
end
Y = reshape(Y, size(X));