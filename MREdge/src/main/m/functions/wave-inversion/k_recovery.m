
function [c, sum_amp, rings] = k_recovery(uw, mask, freqvec, spacing)

%% set parameters

% for z denoise 
z_lev = 3;
NORM = 0.5;
% for log-gabor bank - ALL VALUES FROM FERRARI 2012
% EXCEPT A SHORTER WAVELENGTH IS ADDED AND AN ADDITIONAL SCALE
% FERRARI WAS MIN WAVELENGTH 7, 3 OCTAVES
% HERE MIN WAVELENGTH IS 3.5, 4, OCTAVES
sig_ang = 25/360*2*pi;
MIN_WAVELENGTH = 3.5;
OCTAVES = 4;
eta_b = exp(-1/4*sqrt(2*log(2))*OCTAVES);
mult = 2.1;
w0 = zeros(OCTAVES, 1)';
for scale = 1:OCTAVES
    lam = MIN_WAVELENGTH * mult^(scale-1);
    w0(scale) = 1 / lam;
end
rings = cell(OCTAVES,1);
num_theta = 6;
%num_theta = 1;
num_phi = 4;
%num_phi = 1;
% for wavelet bank
[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;
J = 1;
% for phase gradient recovery
W = 4;
if size(freqvec, 1) > 1
    freqvec = freqvec';
end
freqvec = 2*pi*vec(repmat(freqvec, [3 1]));

% reshape and allocate data
% uw = temporal_ft(uw);
[U, nvols] = resh(uw, 4);
weighted_k = zeros(size(U(:,:,:,1)));
sum_weights = weighted_k;
sum_amp = weighted_k;

%% strip interslice artifact
disp('Interslice artifact removal...');
tic
parfor n = 1:nvols
   U(:,:,:,n) = zden_3D_DWT(dejitter_phase_mask(U(:,:,:,n), mask, NORM), z_lev, mask);
end
toc

%% wavelet decomposition of image
disp('Simultanous decomposition, denoise, directional filter')
for v = 1:nvols
    disp(['volume ', num2str(v)])
    tic
    % blind noise estimation
    %sigma = sigma_mad_wavelet(U(:,:,:,v), mask);
    sigma = mad_est_3d(U(:,:,:,v), mask);
    % undecimated directional complex wavelet decomposition
    w = cplxdual3D_u(U(:,:,:,v), J, Faf, af);
    % denoise wavelet coefficients with nonnegative garotte
    w = denoise_wavelet_coefficients(w, sigma, J);
    % TEST EB
    %U_den = icplxdual3D_u(w, J, Fsf, sf);
    %U_den(isnan(U_den)) = 0;
    % convolve scaling images with log-gabor filter bank. estimate weighted
    % k and weights
    parfor scale = 1:OCTAVES
        %disp(['scale ', num2str(scale)]);
        % create sample image of the freq scale, for inspection
        sig_b = w0(scale)*eta_b
        lg = loggabor_3d(size(w{J+1}{1}{1}{1}), w0(scale),  -1, -1, sig_b, sig_ang);
        sz = size(lg);
        rings{scale} = lg(  :,:,ceil( (sz(3)+1) /2)  ); % center slice in odd, half plus one in even
        for theta = 1:num_theta
            %disp(['theta ',num2str(theta)])
            for phi = 1:num_phi
                %disp(['phi ',num2str(phi)])
                lg = loggabor_3d(size(w{J+1}{1}{1}{1}), w0(scale),  theta*2*pi/num_theta, phi*pi/num_phi, sig_b, sig_ang);
                w_filt = filter_and_scale(w, lg, J);
                U_filt = icplxdual3D_u(w_filt, J, Fsf, sf);
                % TEST EB
                %lg = loggabor_3d(size(U_den), w0(scale),  theta*2*pi/num_theta, phi*pi/num_phi, sig_r, sig_ang);
                %U_filt = ifftn(ifftshift(fftshift(fftn(U_den)).*lg));
                amp = abs(U_filt);
                sum_amp = sum_amp + amp;
                weights = amp.^W;
                sum_weights = sum_weights + weights;
                absK = phase_gradient(U_filt, spacing);
                weighted_k = weighted_k + absK.*weights./freqvec(v);
            end
        end
    end
    toc
end

c = sum_weights ./ weighted_k;

end

function w = denoise_wavelet_coefficients(w, sigma, J)
    % denoise complex wavelet coefficients using nonnegative garotte
    for j = 1:J
        for n = 1:2
            for p = 1:2
                for q = 1:7
                    w_r = w{j}{1}{n}{p}{q};
                    w_i = w{j}{2}{n}{p}{q};
                    w_c = w_r + 1i*w_i;
                    w_c = nng(w_c, sigma);
                    w{j}{1}{n}{p}{q} = real(w_c);
                    w{j}{2}{n}{p}{q} = imag(w_c);
                end
            end
        end
    end
end

function w_filt = filter_and_scale(w, lg, J)
    % filter scaling coefficients
    w_filt = w;
    for m = 1:2
        for n = 1:2
            for p = 1:2
                convn = fftshift(fftn(w{J+1}{m}{n}{p})).*lg;
                w_filt{J+1}{m}{n}{p} = ifftn(ifftshift(convn));
            end
        end
    end
    % scale wavelet coefficients
    for m = 1:2
        for n = 1:2
            for p = 1:2
                w_lo_orig = w{J+1}{m}{n}{p};
                w_lo_filt = w_filt{J+1}{m}{n}{p};
                ratio = range(abs(w_lo_filt(:))) ./ range(abs(w_lo_orig(:)));
                for q = 1:7
                    for j = 1:J
                        w_filt{j}{m}{n}{p}{q} = w_filt{j}{m}{n}{p}{q} .* ratio;
                        w_filt{j}{m}{n}{p}{q}(isnan(w_filt{j}{m}{n}{p}{q})) = 0;
                    end
                end
            end
        end
    end
end

function absK = phase_gradient(u, spacing)
    dx = angle( conj(u(1:end-1,:,:)) .* u(2:end,:,:) ) / spacing(1);
    dy = angle( conj(u(:,1:end-1,:)) .* u(:,2:end,:) ) / spacing(2);
    dz = angle( conj(u(:,:,1:end-1)) .* u(:,:,2:end) ) / spacing(3);
    G1 = cat( 1, dx(1,:,:), (dx(1:end-1,:,:)+dx(2:end,:,:)) / 2, dx(end,:,:) );
    G2 = cat( 2, dy(:,1,:), (dy(:,1:end-1,:)+dy(:,2:end,:)) / 2, dy(:,end,:) );
    G3 = cat( 3, dz(:,:,1), (dz(:,:,1:end-1)+dz(:,:,2:end)) / 2, dz(:,:,end) );
    absK = sqrt( abs(G1).^2 + abs(G2).^2 + abs(G3).^2);%[rad/m] real part of the wave vector k
end
  

