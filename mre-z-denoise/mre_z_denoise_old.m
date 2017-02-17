function [x_zden, rc_means, rc_stds] = mre_z_denoise(x, thresh)

sz = size(x);
num_series = prod(sz(5:end));

[h0, h1, g0, g1] = daubf(3);
z_ext = 3 * sz(3) - 2;
filters = {h0, h1, g0, g1};

x_4d = reshape(x, [sz(1) sz(2) sz(3) sz(4) num_series]);
rc_means = zeros(num_series, 1);
rc_stds = zeros(num_series, 1);
for n = 1:num_series
    disp(['Time Series Volume ',num2str(n)]);
    [vol, order_vector] = extend_z(x_4d(:,:,:,:,n), z_ext);
    [vol_zden, rc_mean, rc_std] = den_z(vol, filters, thresh);
    rc_means(n) = rc_mean;
    rc_stds(n) = rc_std;
    x_4d(:,:,:,:,n) = crop_z(vol_zden, order_vector);
end
x_zden = reshape(x_4d, sz);

end

function [vol_den, rc_mean, rc_std] = den_z(vol_4d, filters, thresh)
    sz = size(vol_4d);
    T = sz(4);
    vol_den = zeros(sz);
    removed_coeffs = zeros(sz(1), sz(2));
    for i=1:sz(1)
        %if mod(round(1000*i/sz(1))/10, 10) == 0
        %    disp([num2str((1-i/sz(1))*100),'% remaining']);
        %end
        for j =1:sz(2)
            dwts = cell(T,1);
            z_image = zeros(sz(3) + 5, T);
            for n = 1:T
                z_line = squeeze(vol_4d(i,j,:,n));
                dwts{n} = udwt(z_line, 1, filters{1}, filters{2});
                z_image(:,n) = dwts{n}{1};
            end
            % THRESH
            % do not need to anatomically mask, assume line is either "in"
            % or "out"
            noise_est = mad_est_2d(z_image);
            removed_coeffs(i,j) = numel(z_image(abs(z_image) > thresh*noise_est)) / numel(z_image);
            z_image(abs(z_image) > thresh*noise_est) = 0;
            for n = 1:T
                dwts{n}{1} = z_image(:,n);
                z_line_thresh = iudwt(dwts{n}, 1, filters{3}, filters{4});
                vol_den(i,j,:,n) = z_line_thresh(1:length(z_line));
            end
        end
    end
    rc = removed_coeffs(:);
    rc_mean = mean(rc);
    rc_std = std(rc);
    disp([' Mean removed coeffs: ', num2str(rc_mean),'%, std: ',num2str(rc_std),'%']);
end