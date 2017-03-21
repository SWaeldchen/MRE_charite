
function [mag_num, mag_denom, phi_num, phi_denom] = invert(U, freqvec, spacing, ndims, ord, iso)

    if nargin < 6
        iso = 1;
        if nargin < 5
            ord = 4;
            if nargin < 4
                ndims = 3;
            end
        end
    end
	sz = size(U);
    if numel(sz) < 5
		d5 = 1;
    else
        d5 = sz(5);
    end
    if numel(sz) < 5
		d4 = 1;
    else
        d4 = sz(4);
    end
    U_lap = zeros(size(U));
    for m = 1:d4
        for n = 1:d5
            U_lap(:,:,:,m,n) = laplacian_image(U(:,:,:,m,n), spacing, ndims, ord, iso);
        end
    end
    sz_elasto = [size(U,1) size(U,2) size(U,3)];
    mag_num = zeros(sz_elasto);
	mag_denom = zeros(sz_elasto);
	phi_num = zeros(sz_elasto);
	phi_denom = zeros(sz_elasto);
    
    for m = 1:d4
        for n = 1:d5
            U_temp = U(:,:,:,m,n);
            U_lap_temp = U_lap(:,:,:,m,n);
            mag_num = mag_num + abs(U_temp).*1000.*(2*pi*freqvec(n)).^2;
            mag_denom = mag_denom + abs(U_lap_temp);
            phi_num = phi_num + real(U_temp.*real(U_lap_temp) + imag(U_temp).*imag(U_lap_temp));
            phi_denom = phi_denom + abs(U_temp) .* abs(U_lap_temp);
        end
    end
    
end


