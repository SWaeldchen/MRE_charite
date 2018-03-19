function mag = helmholtz_inversion_slicewise(U, freqvec, spacing)

	sz = size(U);
    U_lap = zeros(size(U));
    laplacian = [0 1 0; 1 -4 1; 0 1 0];
    for m = 1:sz(3)
            U_lap(:,:,m) = conv2(U(:,:,m), laplacian, 'same') ./ (spacing(1)^2);
    end
    sz_elasto = [size(U,1) size(U,2)];
    mag_num = zeros(sz_elasto);
	mag_denom = zeros(sz_elasto);
	phi_num = zeros(sz_elasto);
	phi_denom = zeros(sz_elasto);
    
    for f = 1:numel(freqvec)
        for c = 1:3
            index = (f-1)*3 + c;
            U_temp = U(:,:,index);
            U_lap_temp = U_lap(:,:,index);
            mag_num = mag_num + abs(U_temp).*1000.*(2*pi*freqvec(f)).^2;
            mag_denom = mag_denom + abs(U_lap_temp);
        end
    end
    
    mag = mag_num ./ mag_denom;
    
end