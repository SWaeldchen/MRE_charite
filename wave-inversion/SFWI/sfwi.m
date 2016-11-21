function G = sfwi(U, freqvec, spacing, unwrap, ft, diff_meth, inv_meth, den_fac, z_den_fac, sr_fac)
% stacked frequency wave inversion
% (c) Eric Barnhill 2016. All Rights Reserved.
% For private use only.

if nargin < 8 || isempty(den_fac)
    den_fac = 0.012;
    if nargin < 7 || isempty(inv_meth)
        inv_meth = 3;
        if nargin < 6 || isempty(diff_meth)
            diff_meth = 3;
            if nargin < 5 || isempty(ft)
                ft = 0;
                if nargin < 4 || isempty(unwrap)
                    unwrap = 0;
                end
            end
        end
    end
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

if den_fac > 0
    parfor m = 1:d5
        tic
        U(:,:,:,:,m) = dtdenoise_z_mad_u(U(:,:,:,:,m), 3, z_den_fac, 1);
        U(:,:,:,:,m) = dtdenoise_3d_mad_ogs_undec(U(:,:,:,:,m), den_fac);
        toc
    end
elseif den_fac == -1
    disp('Denoising z-xy');
    for m = 1:d5
        U(:,:,:,:,m) = dtdenoise_z_mad_u(U(:,:,:,:,m), 1, z_den_fac, 1);
        U(:,:,:,:,m) = dtdenoise_xy_pca_mad_u(U(:,:,:,:,m), 0.2, 1);
    end
end
%U = U_denoise;
clear U_denoise
assignin('base', 'U_denoise', U);


%disp('Hodge Decomp')
%tic
%U = hodge_decomp(U, 2, 5);
%toc
%assignin('base', 'U_hodge', U);


% inversion
disp('Inversion')
tic
if sr_fac == 1
    G = full_wave_inversion(U, freqvec, spacing, diff_meth, inv_meth);
else
    G = full_wave_inversion(additive_sr(U, sr_fac), freqvec, spacing / sr_fac, diff_meth, inv_meth);
end
toc