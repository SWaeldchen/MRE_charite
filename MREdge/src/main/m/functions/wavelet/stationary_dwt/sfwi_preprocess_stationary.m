function U = sfwi_preprocess_stationary(U, unwrap, ft, den_meth, den_fac, z_den_fac)
% stacked frequency wave inversion
% (c) Eric Barnhill 2016. All Rights Reserved.
% For private use only.

if unwrap > 0
    disp('Unwrapping');
    U = dct_unwrap(U);
end
if ft > 0
    disp('FT');
    U_ft = fft(U, [], 4);
    U = squeeze(U_ft(:,:,:,2,:,:));
    assignin('base', 'U_FT', U);
end
sz = size(U);
if numel(sz) < 5
    d5 = 1;
else
    d5 = sz(5);
end

% denoise
disp('Denoise')

if den_meth == 0
    parfor m = 1:d5
        tic
        U(:,:,:,:,m) = dtdenoise_z_mad_u(U(:,:,:,:,m), 2, z_den_fac, 1);
        U(:,:,:,:,m) = dtdenoise_3d_mad_ogs_undec(U(:,:,:,:,m), den_fac);
        toc
    end
elseif den_meth == 1
    disp('Denoising z-xy');
    parfor m = 1:d5
        U(:,:,:,:,m) = dtdenoise_z_mad_u(U(:,:,:,:,m), 2, z_den_fac, 1);
        U(:,:,:,:,m) = dtdenoise_xy_pca_mad_u(U(:,:,:,:,m), den_fac, 1);
    end
end
