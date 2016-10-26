function [mag, phi] = tgv_inversion_2d(U_curl, freqs, spacing, super_factor)

sz = size(U_curl);
for p = 1:sz(5)
    U_curl_byfreq{p} = U_curl(:,:,:,:,p);
end
U_curl_interp = cell(sz(5)); 
parfor p = 1:sz(5)
    vol_4d = U_curl_byfreq{p};
    vol_4d_interp = zeros(size(vol_4d,1)*super_factor-1, size(vol_4d,2)*super_factor-1, size(vol_4d, 3), size(vol_4d,4));
    for m = 1:size(vol_4d, 3)
        for n = 1:size(vol_4d, 4)
            disp([num2str(m), ' ', num2str(n)]);
            slice_interp = interp_cubic(vol_4d(:,:,m,n), super_factor);
            slice_tv = tgv_complex(slice_interp, .01, .02, 1000, 501);
            %slice_tv = slice_interp;
            vol_4d_interp(:,:,m,n) = slice_tv;
        end
    end
    U_curl_interp{p} = vol_4d_interp;
end
for p = 1:sz(5)
    U_interp(:,:,:,:,p) = U_curl_interp{p};
end
spacing = spacing * super_factor;
[magNum, magDenom, phiNum, phiDenom] = invert(U_interp, spacing, freqs, 1, 1);

mag = magNum ./ magDenom;
phi = acos(-phiNum ./ phiDenom);
	
mag(isnan(mag)) = 0;
phi(isnan(phi)) = 0;

