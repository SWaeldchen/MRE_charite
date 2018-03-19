function [U_den] = dtdenoise_z_mad_u(U, fac, J, is_complex)
if nargin < 4
    if nargin < 3
        if nargin < 2
            J = 1;
        end
        fac = 0.1;
    end
	is_complex = 1;
end
U_den = zeros(size(U));
if numel(size(U)) < 4
    d4 = 1;
else
    d4 = size(U,4);
end

for n = 1:d4

	xr = real(U(:,:,:,n));
	xi = imag(U(:,:,:,n));

	xr = dtdenoise_z_u(xr, fac, J);
	if is_complex == 1
		xi = dtdenoise_z_u(xi, fac, J);
		U_den(:,:,:,n) = xr + 1i*xi;
	else
		U_den(:,:,:,n) = xr;
	end
end	


