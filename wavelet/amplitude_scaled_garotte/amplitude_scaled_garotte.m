function v = amplitude_scaled_garotte(coeffs, amp, mask)
if nargin < 2
    mask = true(size(u));
end
coeffs_ampscaled = coeffs ./ amp;
lam = bayesshrink_eb(coeffs_ampscaled, mask);
%lam = bayesshrink_eb(coeffs, mask);
%v = nng_ampscaled(coeffs, amp, lam);
%v = ogs3(coeffs, [3 3 3], min(lam/10,0.01), 'atan', 1, 5);
v_ampscaled = nng(coeffs_ampscaled, lam);
v = v_ampscaled .* amp;
