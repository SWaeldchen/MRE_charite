function lam = bayesshrink_eb(u, mask, sighat)
if nargin < 2
    mask = true(size(u));
end
mask = logical(mask);
u_masked = u(mask);
u_len = numel(u_masked);
if nargin < 3
    sighat = median(abs(u_masked)) / 0.6745;
end

sigHat = simplemad(u(mask)) / 0.6745;

sig2y = sum(u_masked.^2) / u_len;
sigx = sqrt(max(sig2y - sighat.^2, 0));
if sigx == 0 
    lam = max(abs(u(:)));
else
    lam = sighat.^2 / sigx;
end

