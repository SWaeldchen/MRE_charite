
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
	%sz_resh = [sz(1), sz(2), sz(3), sz(4)*d5];
	%sz_super = round([sz(1)*super_factor, sz(2)*super_factor, sz(3)*super_factor]);
	

	
    % get data in cell format
    U_interp = cell(sz(4), d5);
    for m = 1:sz(4)
        for n = 1:d5
            U_interp{m,n} = U(:,:,:,m,n);
        end
    end
    %{
    % interpolate it
    if super_factor == 1
      NITER = 1;
    else
      NITER = 20;
    end
      
    for m = 1:sz(4)
        for n = 1:d5
            tic
            U_interp{m,n} = U(:,:,:,m,n); %iterative_bicubic_3d_by_1d(U(:,:,:,m,n), super_factor, NITER);
            %U_lap_interp{m,n} = iterative_bicubic_3d(U_lap(:,:,:,m,n), super_factor, 1);            
            toc
        end
    end
    %}
    % put it back in matrix format
    U = [];
    U_lap = [];
    for m = 1:sz(4)
        for n = 1:d5
            tic
            U(:,:,:,m,n) = U_interp{m,n}; %#ok<AGROW>
            U_lap(:,:,:,m,n) = get_compact_laplacian(U_interp{m,n}, spacing, twoD);  %#ok<AGROW>
            %U_lap(:,:,:,m,n) = get_wavelet_laplacian(U(:,:,:,m,n), spacing, twoD);  %#ok<AGROW>

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


