function [x_zden, rc_means, rc_stds] = mre_z_denoise(x, thresh)

sz = size(x);
if numel(sz) == 6
    DIMS = 6;
else
    DIMS = 5;
end

if DIMS == 6
    num_series = prod(sz(5:end));
else
    num_series = prod(sz(4:end));
end

if DIMS == 6
    x_resh = reshape(x, [sz(1) sz(2) sz(3) sz(4) num_series]);
else 
    x_resh_5d = reshape(x, [sz(1) sz(2) sz(3) num_series]);
end
z_ext = 3*sz(3)-2;
rc_means = zeros(num_series, 1);
rc_stds = zeros(num_series, 1);
for n = 1:num_series
    disp(['Time Series Volume ',num2str(n)]);
    if DIMS == 6
        [vol, order_vector] = extend_z(x_resh(:,:,:,:,n), z_ext);
    else 
        [vol, order_vector] = extend_z(x_resh_5d(:,:,:,n), z_ext);
    end
    if ~isreal(vol)
        [vol_zden_r, rc_mean, rc_std] = den_z(real(vol), thresh);
        [vol_zden_i, ~, ~] = den_z(imag(vol), thresh);
        vol_zden = vol_zden_r + 1i*vol_zden_i;
    else
        [vol_zden, rc_mean, rc_std] = den_z(vol, thresh);
    end
    rc_means(n) = rc_mean;
    rc_stds(n) = rc_std;
    if DIMS == 6
        x_resh(:,:,:,:,n) = crop_z(vol_zden, order_vector);
    else 
        x_resh_5d(:,:,:,n) = crop_z(vol_zden, order_vector);
    end
end
if DIMS == 6
    x_zden = reshape(x_resh, sz);
else
    x_zden = reshape(x_resh_5d, sz);
end

end

function [vol_den, rc_mean, rc_std] = den_z(vol, thresh)
    sz = size(vol);
    if numel(sz) == 4
        DIMS = 4;
        d4 = sz(4);
    else
        DIMS = 3;
        d4 = 1;
    end
    orig_depth = sz(3);
    if DIMS == 4
        vol = simplepad(vol, [sz(1), sz(2), nextpwr2(orig_depth), d4]);
    else
        vol = simplepad(vol, [sz(1), sz(2), nextpwr2(orig_depth)]);
    end
    sz = size(vol);
    T = d4;
    vol_den = zeros(sz);
    removed_coeffs = zeros(sz(1), sz(2));
    [Faf, Fsf] = FSfarras;
    [af, sf] = dualfilt1;
    for i=1:sz(1)
        for j=1:sz(2)
            dwts = cell(T,1);
            z_image_L1 = zeros(sz(3)/2, T);
            z_image_L2 = zeros(sz(3)/4, T);
            z_image_L3 = zeros(sz(3)/8, T);
            % CONSTRUCT ZT IMAGE
            for n = 1:T
                z_line = squeeze(vol(i,j,:,n));
                dwts{n} = dualtree(z_line, 2, Faf, af);
                z_image_L1(:,n) = dwts{n}{1}{1} + 1i*dwts{n}{1}{2};
                z_image_L2(:,n) = dwts{n}{2}{1} + 1i*dwts{n}{2}{2};
                %z_image_L3(:,n) = dwts{n}{3}{1} + 1i*dwts{n}{3}{2};
            end
            % WE ARE GOING TO TRY USING THE FINEST COEFF ESTIMATE FOR ALL
            % LEVELS. ONLY TO ORIG DEPTH NO PADDING
            noise_est_L1 = mad_est_2d(abs(z_image_L1(1:floor(orig_depth/2), 1:T)));
            noise_est_L2 = mad_est_2d(abs(z_image_L2(1:floor(orig_depth/4), 1:T)));
            %noise_est_L3 = mad_est_2d(abs(z_image_L3(1:floor(orig_depth/8), 1:T)));

            removed_coeffs(i,j) = numel(z_image_L1(abs(z_image_L1) > thresh*noise_est_L1)) / numel(z_image_L1);
            z_image_L1(abs(z_image_L1) > thresh*noise_est_L1) = 0;
            z_image_L2(abs(z_image_L2) > thresh*noise_est_L2) = 0;
            %z_image_L3(abs(z_image_L3) > thresh*noise_est_L3) = 0;
            % RESTORE ZT IMAGE
            for n = 1:T
                dwts{n}{1}{1} = real(z_image_L1(:,n));
                dwts{n}{1}{2} = imag(z_image_L1(:,n));
                dwts{n}{2}{1} = real(z_image_L2(:,n));
                dwts{n}{2}{2} = imag(z_image_L2(:,n));
                %dwts{n}{3}{1} = real(z_image_L3(:,n));
                %dwts{n}{3}{2} = imag(z_image_L3(:,n));
                z_line_thresh = idualtree(dwts{n}, 2, Fsf, sf);
                vol_den(i,j,:,n) = z_line_thresh;
            end
        end
    end
    rc = removed_coeffs(:);
    rc_mean = mean(rc);
    rc_std = std(rc);
    disp([' Mean removed coeffs: ', num2str(rc_mean),'%, std: ',num2str(rc_std),'%']);
end