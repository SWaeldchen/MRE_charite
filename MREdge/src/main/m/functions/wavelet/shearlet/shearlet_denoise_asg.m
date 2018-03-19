function v = shearlet_denoise_asg(u, mask, J, K)

DIM = 128;
%%settings
if nargin < 3
    J = 3;
    K = [1 1 1];
    if nargin < 2
        mask = true(size(u));
    end
end
mask = logical(simplepad(mask, [DIM DIM DIM]));
directionalFilter = modulate2(dfilters('cd','d')./sqrt(2),'c');
[u_resh, n_vols] = resh(u,4);
v_resh = zeros(size(u_resh));
for m = 1:n_vols

    szu_resh = size(u_resh(:,:,:,m));
    u_pad = simplepad(u_resh(:,:,:,m), [128 128 128]);
    u_pad(u_pad==0) = randn(numel(u_pad(u_pad==0)), 1); %% to avoid numerical errors
    szu_pad = size(u_pad);
    %%create shearlets
    %shearletSystem = SLgetShearletSystem3DC(0,szu_pad(1),szu_pad(2),szu_pad(3),J,K,0,directionalFilter);
    shearletSystem = SLgetShearletSystem3D(0,szu_pad(1),szu_pad(2),szu_pad(3),J,K,0,directionalFilter);
    assignin('base', 'shearletSystem', shearletSystem);
    %%decomposition
    %coeffs = SLsheardec3DC(u_pad,shearletSystem);
    amp = abs(u_pad);

    coeffs_r = SLsheardec3D(real(u_pad),shearletSystem);
    coeffs_i = SLsheardec3D(imag(u_pad),shearletSystem);

    %%thresholding, separately for R and I (todo: multichannel)
    for n = 1:size(coeffs_r,4)-1
        coeffs_r(:,:,:,n) = amplitude_scaled_garotte(coeffs_r(:,:,:,n), amp, mask);
        coeffs_i(:,:,:,n) = amplitude_scaled_garotte(coeffs_i(:,:,:,n), amp, mask);
        %coeffs_r(:,:,:,n) = nonscaled_garotte(coeffs_r(:,:,:,n), mask);
        %coeffs_i(:,:,:,n) = nonscaled_garotte(coeffs_i(:,:,:,n), mask);
    end
    coeffs_r(isnan(coeffs_r)) = 0;
    coeffs_i(isnan(coeffs_i)) = 0;
    %%reconstruction
    %shearrec = SLshearrec3DC(coeffs,shearletSystem);
    shearrec_r = SLshearrec3D(coeffs_r,shearletSystem).*amp;
    shearrec_i = SLshearrec3D(coeffs_i,shearletSystem).*amp;
    v_resh(:,:,:,m) = simplecrop(shearrec_r + 1i*shearrec_i, [szu_resh(1), szu_resh(2), szu_resh(3)]);
    
end
v = reshape(v_resh, size(u));


%
%  Copyright (c) 2014. Rafael Reisenhofer
%
%  Part of ShearLab3D v1.1
%  Built Mon, 10/11/2014
%  This is Copyrighted Material
%
%  If you use or mention this code in a publication please cite the website www.shearlab.org and the following paper:
%  G. Kutyniok, W.-Q. Lim, R. Reisenhofer
%  ShearLab 3D: Faithful Digital SHearlet Transforms Based on Compactly Supported Shearlets.
%  ACM Trans. Math. Software 42 (2016), Article No.: 6
