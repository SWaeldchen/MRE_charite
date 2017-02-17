function y = perdecomp_stack(x, factor)


if nargin < 2 || ndims(x) < 2
	disp('MCNIT error: interp_2d requires a 2d or higher data set, and an interpolation factor.');
end

sz = size(x);
[x_resh, n_slcs] = resh(x, 3);
sz_interp = sz(1:2)*factor;
x_interp = zeros(sz_interp(1), sz_interp(2), n_slcs);

for n = 1:n_slcs
	x_interp(:,:,n) = magnify_fft2_perdecomp(x_resh(:,:,n), factor);
end

y = reshape(x_interp, [sz_interp(1), sz_interp(2), sz(3:end)]);

end

