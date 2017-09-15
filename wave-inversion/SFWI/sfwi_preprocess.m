function U = sfwi_preprocess(U, unwrap, ft, den_meth, mask, CUT)
% stacked frequency wave inversion
% (c) Eric Barnhill 2016. All Rights Reserved.
% For private use only.

DEN_LEVELS = 2;
Z_DEN_LEVELS = 2;
K_LEVELS = [1 1 1];
ORD = 4;
den_fac = 2;
z_den_fac = 2;
den_fac_3d = 0.5;

if nargin < 6
    CUT = 0.03;
end
if nargin < 5
    mask = ones(size(U, 1), size(U, 2), size(U, 3));
end
if unwrap > 0
    disp('Unwrapping');
    U = dct_unwrap(U,2);
end

% denoise
if den_meth == 0
    parfor m = 1:d5
        U(:,:,:,:,m) = dtdenoise_z_mad_u(U(:,:,:,:,m), z_den_fac, Z_DEN_LEVELS, 1);
        U(:,:,:,:,m) = dtdenoise_3d_mad_ogs_undec(U(:,:,:,:,m), den_fac);
    end
elseif den_meth == 1 % OLD PROT
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
        U(:,:,:,:,m) = dtdenoise_xy_pca_mad_u(U(:,:,:,:,m), den_fac, DEN_LEVELS, 1, mask);
        U(:,:,:,:,m) = butter_3d(ORD, CUT, U(:,:,:,:,m), 1);
    end
elseif den_meth == 2 % LINEAR THRESHOLD
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
    U = dejitter_phase_mask(U, logical(mask), 0.5, 256);
    tic
    parfor m = 1:d5
        U(:,:,:,:,m) = zden_3D_DWT(U(:,:,:,:,m), Z_DEN_LEVELS, mask);
        U(:,:,:,:,m) = dtdenoise_3d_undec(U(:,:,:,:,m), DEN_LEVELS, mask);
        U(:,:,:,:,m) = butter_3d(ORD, CUT, U(:,:,:,:,m), 1);
        %U(:,:,:,:,m) = dtdenoise_3d_mad_ogs_undec(U(:,:,:,:,m), den_fac, DEN_LEVELS, mask);
    end
    toc
elseif den_meth == 3 % Z NEGLECT
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
    tic
    parfor m = 1:d5
        U(:,:,:,:,m) = butter_3d(ORD, CUT, U(:,:,:,:,m), 1);
        U(:,:,:,:,m) = dtdenoise_3d_undec(U(:,:,:,:,m), DEN_LEVELS, mask);
    end
elseif den_meth == 4 % OGS THRESHOLD
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
    U = dejitter_phase_mask(U, logical(mask), 0.5, 256);
    tic
    parfor m = 1:d5
        U(:,:,:,:,m) = zden_3D_DWT(U(:,:,:,:,m), Z_DEN_LEVELS, mask);
        U(:,:,:,:,m) = dtdenoise_3d_mad_ogs_undec(U(:,:,:,:,m), den_fac_3d, DEN_LEVELS, mask);
    end
end
toc
   
end
