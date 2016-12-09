function U = sfwi_preprocess_stationary(U, unwrap, ft, den_meth, den_fac, z_den_fac)
% stacked frequency wave inversion
% (c) Eric Barnhill 2016. All Rights Reserved.
% For private use only.

<<<<<<< HEAD
DEN_LEVELS = 2;
Z_DEN_LEVELS = 2;

=======
>>>>>>> 14803ebee41767e1a5bf2a62664855d932748d33
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
<<<<<<< HEAD
        U(:,:,:,:,m) = dtdenoise_z_mad_u(U(:,:,:,:,m), z_den_fac, Z_DEN_LEVELS, 1);
=======
        U(:,:,:,:,m) = dtdenoise_z_mad_u(U(:,:,:,:,m), 2, z_den_fac, 1);
>>>>>>> 14803ebee41767e1a5bf2a62664855d932748d33
        U(:,:,:,:,m) = dtdenoise_3d_mad_ogs_undec(U(:,:,:,:,m), den_fac);
        toc
    end
elseif den_meth == 1
    disp('Denoising z-xy');
    for m = 1:d5
<<<<<<< HEAD
        U(:,:,:,:,m) = dtdenoise_z_mad_u(U(:,:,:,:,m), z_den_fac, Z_DEN_LEVELS, 1);
        U(:,:,:,:,m) = dtdenoise_xy_pca_mad_u(U(:,:,:,:,m), den_fac, DEN_LEVELS, 1);
=======
        U(:,:,:,:,m) = dtdenoise_z_mad_u(U(:,:,:,:,m), 2, z_den_fac, 1);
        U(:,:,:,:,m) = dtdenoise_xy_pca_mad_u(U(:,:,:,:,m), den_fac, 1);
>>>>>>> 14803ebee41767e1a5bf2a62664855d932748d33
    end
end
