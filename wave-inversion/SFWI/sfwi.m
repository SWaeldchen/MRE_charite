function G = sfwi(U, freqvec, spacing, unwrap, ft, diff_meth)
% stacked frequency wave inversion
% (c) Eric Barnhill 2016. All Rights Reserved.
% For private use only.

if nargin < 6
    diff_meth = 3;
    if nargin < 5
        ft = 0;
        if nargin < 4
            unwrap = 0;
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
end
sz = size(U);
if numel(sz) < 5
    d5 = 1;
else
    d5 = sz(5);
end

% denoise
disp('Denoise')
den_fac = 0.012;

parfor m = 1:d5
    tic
    U(:,:,:,:,m) = dtdenoise_3d_mad_ogs_undec(U(:,:,:,:,m), den_fac);
    toc
end
assignin('base', 'U_denoise', U);


disp('Hodge Decomp')
tic
U = hodge_decomp(U, 2, 5);
toc
assignin('base', 'U_hodge', U);


% inversion
disp('Inversion')
tic
G = full_wave_inversion(U, freqvec, spacing, diff_meth);
toc