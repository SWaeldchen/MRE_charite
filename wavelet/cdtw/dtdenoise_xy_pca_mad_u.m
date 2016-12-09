
<<<<<<< HEAD
function U_den = dtdenoise_xy_pca_mad_u(U, fac, J, is_complex) 
    if nargin < 4
		if nargin < 3
			J = 3;
		    if nargin < 2
		        fac = 0.1;
		    end
		end
=======
function U_den = dtdenoise_xy_pca_mad_u(U, fac, is_complex)
    J = 4;
    if nargin < 4
        if nargin < 2
            fac = 0.1;
        end
>>>>>>> 14803ebee41767e1a5bf2a62664855d932748d33
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
    for m = 1:d4
	   mad_r = mad_est_3d(real(U(:,:,:,m)));
       mad_i = mad_est_3d(imag(U(:,:,:,m)));
   	   lambda_r = (fac*mad_r);
       lambda_i = (fac*mad_i);
       for k = 1:size(U,3)
            U_temp = U(:,:,k,m);
            denR_temp = simplecrop(DT_2D_u(real(U_temp), lambda_r*fac, J), size(U_temp));
            denR(:,:,k,m) = denR(:,:,k,m) + denR_temp(1:sz(1), 1:sz(2), :);
            if is_complex == 1
                denI_temp = simplecrop(DT_2D_u(imag(U_temp), lambda_i*fac, J), size(U_temp));
                denI(:,:,k,m) = denI(:,:,k,m) + denI_temp(1:sz(1), 1:sz(2), :);
            end
        end
    end
    if is_complex == 1
        U_den = (denR + 1i*denI);
    else
        U_den = denR;
    end
end


