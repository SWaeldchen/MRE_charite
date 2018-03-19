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
szu = size(u);
[u_resh, n_vols] = resh(u,4);
v_resh = zeros(size(u_resh));
for m = 1:n_vols

    %%create shearlets
    shearletSystem = SLgetShearletSystem3DC(0,szu(1),szu(2),szu(3),J,K,0,directionalFilter);

    %%decomposition
    coeffs_r = SLsheardec3DC(real(u_resh(:,:,:,m)),shearletSystem);
    coeffs_i = SLsheardec3DC(imag(u_resh(:,:,:,m)),shearletSystem);
    
    %retain image amplitudes for scaling
    amp = abs(u_resh(:,:,:,m));

    %%thresholding, separately for R and I (todo: multichannel)
    for n = 1:size(coeffs_r,4)-1
        coeffs_r(:,:,:,n) = amplitude_scaled_garotte(coeffs_r(:,:,:,n), amp, mask);
        coeffs_i(:,:,:,n) = amplitude_scaled_garotte(coeffs_i(:,:,:,n), amp, mask);
    end

    %%reconstruction
    v_resh(:,:,:,m) = SLshearrec3DC(coeffs,shearletSystem);
    
end
v = reshape(v_resh, szu);


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
