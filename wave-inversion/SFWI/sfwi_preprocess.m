function U = sfwi_preprocess(U, unwrap, ft, den_meth, den_fac, z_den_fac, mask)
% stacked frequency wave inversion
% (c) Eric Barnhill 2016. All Rights Reserved.
% For private use only.

DEN_LEVELS = 3;
Z_DEN_LEVELS = 2;
if nargin < 7
    mask = ones(size(U, 1), size(U, 2), size(U, 3));
end
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
        U(:,:,:,:,m) = dtdenoise_z_mad_u(U(:,:,:,:,m), z_den_fac, Z_DEN_LEVELS, 1);
        U(:,:,:,:,m) = dtdenoise_3d_mad_ogs_undec(U(:,:,:,:,m), den_fac);
        toc
    end
elseif den_meth == 1
    disp('Denoising z-xy stationary');
    for m = 1:d5
        U(:,:,:,:,m) = dtdenoise_z_mad_u(U(:,:,:,:,m), z_den_fac, Z_DEN_LEVELS, 1);
        U(:,:,:,:,m) = dtdenoise_xy_pca_mad_u(U(:,:,:,:,m), den_fac, DEN_LEVELS, 1, mask);
    end
elseif den_meth == 2
    disp('Denoising z-xy, critically sampled with phase spin');
    for m = 1:d5
        U(:,:,:,:,m) = dtdenoise_z_mad_u(U(:,:,:,:,m), z_den_fac, Z_DEN_LEVELS, 1);
        U(:,:,:,:,m) = dtdenoise_xy_pca_mad(U(:,:,:,:,m), den_fac, DEN_LEVELS, 1);
     end
end
