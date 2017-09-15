function [U_lo, U_hi] = sfwi_separate_preprocess(U, unwrap, ft, den_fac, mask)
% stacked frequency wave inversion
% (c) Eric Barnhill 2016. All Rights Reserved.
% For private use only.

DEN_LEVELS = 2;
Z_DEN_LEVELS = 2;
K_LEVELS = [1 1 1];
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
    U = dejitter_phase_2(U, 0.5, 256);
    U_lo = zeros(size(U));
    U_hi = zeros(size(U));
    for m = 1:d5
        U(:,:,:,:,m) = zden_3D_DWT(U(:,:,:,:,m), Z_DEN_LEVELS, mask);
        [U_lo(:,:,:,:,m), U_hi(:,:,:,:,m)] = denoise_and_separate(U(:,:,:,:,m), den_fac, DEN_LEVELS, mask);
    end
