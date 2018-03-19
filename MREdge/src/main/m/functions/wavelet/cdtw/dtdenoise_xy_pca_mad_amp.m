
function U_den = dtdenoise_xy_pca_mad_amp(U, amp, fac, n_spins, is_complex) 
    if nargin < 5
		if nargin < 4
		    if nargin < 3
		        fac = 0.1;
		    end
			n_spins = 0;
		end
        is_complex = 1;
    end
    sz = size(U);
    denR = zeros(size(U));
    denI = zeros(size(U));
    if (numel(sz) < 4)
		d4 = 1;
	else 
		d4 = sz(4);
    end
    pad1 = nextpwr2(sz(1));
    pad2 = nextpwr2(sz(2));
    padMax = max(pad1, pad2);
    for m = 1:d4
	   mad_r = mad_est_3d(real(U(:,:,:,m)));
       mad_i = mad_est_3d(imag(U(:,:,:,m)));
   	   lambda_r = (fac*mad_r);
       lambda_i = (fac*mad_i);
       for k = 1:size(U,3)
            for jiggerY = 0:n_spins
                for jiggerX = 0:n_spins
                    U_temp = circshift(simplepad(U(:,:,k,m), [padMax, padMax]), [jiggerY jiggerX]);
                    denR_temp = DT_SOFT_2D_ampguided(real(U_temp), simplepad(amp(:,:,k,m), [padMax padMax]), lambda_r);
                    denR_temp = circshift(denR_temp, [-jiggerY -jiggerX]);
                    denR(:,:,k,m) = denR(:,:,k,m) + denR_temp(1:sz(1), 1:sz(2), :);
                    if is_complex == 1
                        denI_temp = DT_SOFT_2D_ampguided(imag(U_temp), amp(:,:,k,m), lambda_i*fac);
                        denI_temp = circshift(denI_temp, [-jiggerY -jiggerX]);
                        denI(:,:,k,m) = denI(:,:,k,m) + denI_temp(1:sz(1), 1:sz(2), :);
                    end
                end
            end
        end
    end
    if is_complex == 1
        U_den = (denR + 1i*denI) ./ 16;
    else
        U_den = denR ./ 16;
    end
end


