function [mag, phi] = finish_from_hodge(U_denoise, freqvec, spacing, super_factor, hodge_fac)

U = U_denoise;
%U = hodge_decomp(U_denoise, hodge_fac);
twoD = 0;

% take derivatives and interpolate

U_lap = get_compact_laplacian(U, spacing, twoD);

%{
U_lap = zeros(size(U_denoise));
for n = 1:size(U_denoise, 5)
	for m = 1:size(U_denoise, 4)
		U_lap(:,:,:,m,n) = dwt_lap_3D(U_denoise(:,:,:,m,n),1);
	end
end
%}



assignin('base', 'U_lap', U_lap);

[magNum, magDenom, phiNum, phiDenom] = invert(U, U_lap, freqvec, super_factor);
mag = magNum ./ magDenom;
phi = acos(-phiNum ./ phiDenom);
%{
if super_factor > 1
    mag = ortho_ring_reduce(mag, super_factor);
    phi = ortho_ring_reduce(phi, super_factor);
end
%}
mag(isnan(mag)) = 0;
phi(isnan(phi)) = 0;
