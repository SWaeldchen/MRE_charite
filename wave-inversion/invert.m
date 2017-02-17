
function [mag_num, mag_denom, phi_num, phi_denom] = invert(U, freqvec, spacing, twoD)

    if nargin < 4
        twoD = 0;
    end
	sz = size(U);
    if numel(sz) == 4
		d5 = 1;
    else
        d5 = sz(5);
    end
    U_lap = zeros(size(U));
    for m = 1:sz(4)
        for n = 1:d5
            U_lap(:,:,:,m,n) = get_compact_laplacian(U(:,:,:,m,n), spacing, twoD);
            %[dx, dy, dz] = gradient(U(:,:,:,m,n), spacing(1), spacing(2), spacing(3));
            %[dxx, ~, ~] = gradient(dx,spacing(1), spacing(2), spacing(3));
            %[~, dyy, ~] = gradient(dy, spacing(1), spacing(2), spacing(3));
            %[~, ~, dzz] = gradient(dz, spacing(1), spacing(2), spacing(3));
            %U_lap(:,:,:,m,n) = dxx + dyy + dzz;
        end
    end
    sz_elasto = [size(U,1) size(U,2) size(U,3)];
    mag_num = zeros(sz_elasto);
	mag_denom = zeros(sz_elasto);
	phi_num = zeros(sz_elasto);
	phi_denom = zeros(sz_elasto);
    
    for m = 1:sz(4)
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


