function lam = visushrink_eb(u, mask)
if nargin < 2
    mask = true(size(u));
end
mask = logical(mask);
u_len = numel(u(mask));
sigma = simplemad(u(mask)) / 0.6745;
lam = sigma*sqrt(2*log(u_len));

end

