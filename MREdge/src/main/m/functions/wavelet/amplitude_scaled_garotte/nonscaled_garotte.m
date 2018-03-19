function v = nonscaled_garotte(coeffs, mask)
if nargin < 2
    mask = true(size(u));
end
lam = bayesshrink_eb(coeffs, mask);
v = nng(coeffs, lam);