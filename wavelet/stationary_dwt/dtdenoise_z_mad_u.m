<<<<<<< HEAD
function [U_den] = dtdenoise_z_mad_u(U, strategy, J, is_complex)
=======
function [U_den] = dtdenoise_z_mad_u(U, J, strategy, is_complex)
>>>>>>> 14803ebee41767e1a5bf2a62664855d932748d33
if nargin < 4
    if nargin < 3
        if nargin < 2
            J = 1;
        end
        strategy = 'w1';
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
    
    for p = 1:size(xr, 3)
      mc_xr = middle_circle(xr(:,:,p));
      mc_xi = middle_circle(xi(:,:,p));
      xr(:,:,p) = xr(:,:,p) - mean(mc_xr(~isnan(mc_xr)));
      xi(:,:,p) = xi(:,:,p) - mean(mc_xi(~isnan(mc_xi)));
    end
    
    
    z_noise_r = z_noise_est(xr);
    if strcmp(strategy, 'w1') == 1
        zfac = 2 + (1 + z_noise_r*2 );
    elseif strcmp(strategy, 'w2') == 1
        zfac = 2 + (1 + z_noise_r*2 )^2;
    elseif strcmp(strategy, 'w3') == 1
        zfac = 3 + (1 + z_noise_r*3 )^2;
    else
        zfac = strategy;
    end
  
	sz = size(xr);

	xr = dtdenoise_z_u(xr, zfac, J);
	if is_complex == 1
		xi = dtdenoise_z_u(xi, zfac, J);
		U_den(:,:,:,n) = xr + 1i*xi;
	else
		U_den(:,:,:,n) = xr;
	end
end	


