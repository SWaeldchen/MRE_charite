function[U_filt, om_vec] = lg_dirfilt(U, freqvec)

sz = size(U);
if numel(sz) < 5
    d5 = 1;
    if numel(sz) < 4
        d4 = 1;
    else
        d4 = sz(4);
    end
else
    d5 = sz(5);
end
[U_resh, n_vols] = resh(U, 4);

% for log-gabor bank - ALL VALUES FROM FERRARI 2012
% EXCEPT A SHORTER WAVELENGTH IS ADDED AND AN ADDITIONAL SCALE
% FERRARI WAS MIN WAVELENGTH 7, 3 OCTAVES
% HERE MIN WAVELENGTH IS 3.5, 4 OCTAVES
sig_ang = 25/360*2*pi;
MIN_WAVELENGTH = 3.5;
OCTAVES = 4;
%eta_b = exp(-1/4*sqrt(2*log(2))*OCTAVES);
% TEST EB
eta_b = [0.8 0.75 0.7 0.65];
mult = 2.1;
w0 = zeros(OCTAVES, 1)';
for scale = 1:OCTAVES
    lam = MIN_WAVELENGTH * mult^(scale-1);
    w0(scale) = 1 / lam;
end
num_theta = 6;
num_phi = 4;
%num_theta = 2;
%num_phi = 2;

n_results = d4*d5*OCTAVES*num_theta*num_phi;
om_vec = 2*pi*vec(permute(repmat(freqvec, [1 n_results]), [2 1]));

U_res = zeros(size(U,1), size(U,2), size(U,3), n_results);

for scale = 1:OCTAVES
    %sig_b = w0(scale);
    sig_b = eta_b(scale);
    for theta = 1:num_theta
        for phi = 1:num_phi
            result_index = (scale-1)*num_theta*num_phi*n_vols + (theta-1)*num_phi*n_vols + (phi-1)*n_vols + 1;
            lg = loggabor_3d_2(size(U_resh(:,:,:,1)), w0(scale),  theta*2*pi/num_theta, phi*pi/num_phi, sig_b, sig_ang, 0.25, 4);
            lg_rep = repmat(lg, [1 1 1 n_vols]);
            U_res(:,:,:,result_index:result_index + n_vols - 1) = ifft3(lg_rep.*(fft3(U_resh)));
        end
    end
end

U_filt = reshape(U_res, [size(U,1), size(U,2), size(U,3), 3, n_results/3]);

end

function U = fft3(U)

for n = 1:size(U,4)
    U(:,:,:,n) = fftshift(fftn(U(:,:,:,n)));
end

end

function U = ifft3(U)


for n = 1:size(U,4)
    U(:,:,:,n) = ifftn(ifftshift(U(:,:,:,n)));
end


end