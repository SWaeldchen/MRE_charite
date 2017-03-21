
function U_den = dtdenoise_xy_pca_mad_u(U, fac, J, is_complex, mask, meth) 
    if nargin < 6
        meth = 4;
        if nargin < 5
            mask = ones(size(U, 1), size(U, 2), size(U, 3));
            mask = double(middle_circle(mask));
            if nargin < 4
                if nargin < 3
                    J = 3;
                    if nargin < 2
                        fac = 0.1;
                    end
                end
                is_complex = 1;
            end
        end
    end
    if isempty(mask)
        mask = ones(size(U, 1), size(U, 2), size(U, 3));
        mask = double(middle_circle(mask));
    end
    sz = size(U);
    denR = zeros(size(U));
    denI = zeros(size(U));
    if (numel(sz) < 4)
		d4 = 1;
	else 
		d4 = sz(4);
    end
    if (numel(sz) < 3)
		d3 = 1;
	else 
		d3 = sz(3);
    end
    for m = 1:d4
        if d3 > 1
           mad_r = mad_est_3d(real(U(:,:,:,m)), mask);
           mad_i = mad_est_3d(imag(U(:,:,:,m)), mask);
        else
           mad_r = mad_est_2d(real(U(:,:,:,m)), mask);
           mad_i = mad_est_2d(imag(U(:,:,:,m)), mask);
        end
   	   lambda_r = (fac*mad_r);
       lambda_i = (fac*mad_i);
       for k = 1:d3
            U_temp = U(:,:,k,m);
            denR(:,:,k,m) = DT_2D_u(real(U_temp), lambda_r*fac, J, meth);
            if is_complex == 1
                denI(:,:,k,m) = DT_2D_u(imag(U_temp), lambda_i*fac, J, meth);
            end
        end
    end
    if is_complex == 1
        U_den = (denR + 1i*denI);
    else
        U_den = denR;
    end
end


