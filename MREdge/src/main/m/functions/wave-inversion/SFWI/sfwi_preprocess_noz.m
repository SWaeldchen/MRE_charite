function U = sfwi_preprocess_noz(U, unwrap, ft, den_meth, den_fac, z_den_fac, mask, CUT)
% stacked frequency wave inversion
% (c) Eric Barnhill 2016. All Rights Reserved.
% For private use only.

DEN_LEVELS = 2;
Z_DEN_LEVELS = 2;
ORD = 4;

if nargin < 8
    CUT = 0.03;
end
if nargin < 7
    mask = ones(size(U, 1), size(U, 2), size(U, 3));
end
if unwrap > 0
    disp('Unwrapping');
    U = dct_unwrap(U,2);
end

% denoise
if den_meth == 0
    parfor m = 1:d5
        tic
        U(:,:,:,:,m) = dtdenoise_z_mad_u(U(:,:,:,:,m), z_den_fac, Z_DEN_LEVELS, 1);
        U(:,:,:,:,m) = dtdenoise_3d_mad_ogs_undec(U(:,:,:,:,m), den_fac);
        toc
    end
elseif den_meth == 1
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
    parfor m = 1:d5
        U(:,:,:,:,m) = dtdenoise_z_mad_u(U(:,:,:,:,m), z_den_fac, Z_DEN_LEVELS, 1);
        %U(:,:,:,:,m) = mre_z_denoise(U(:,:,:,:,m));
        U(:,:,:,:,m) = dtdenoise_xy_pca_mad_u(U(:,:,:,:,m), den_fac, DEN_LEVELS, 1, mask);
    end
elseif den_meth == 2
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
    %U = dejitter_phase_2(U, 0.5, 256);
    parfor m = 1:d5
        %U(:,:,:,:,m) = zden_3D_DWT(U(:,:,:,:,m), Z_DEN_LEVELS, mask);
        U(:,:,:,:,m) = butter_3d(ORD, CUT, U(:,:,:,:,m), 1);
        U(:,:,:,:,m) = dtdenoise_3d_mad_ogs_undec(U(:,:,:,:,m), den_fac, DEN_LEVELS, mask);
    end
end
