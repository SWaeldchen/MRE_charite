function x_zden = mre_z_denoise(x, J, lam)
if nargin < 3 
    lam = 0.5;
    if nargin < 2
        J = 3;
    end
end
sz = size(x);
num_series = prod(sz(5:end));

[h0, h1, g0, g1] = daubf(3);
z_ext = 3 * sz(3) - 2;
filters = {h0, h1, g0, g1};

x_4d = reshape(x, [sz(1) sz(2) sz(3) sz(4) num_series]);
for n = 1:num_series
    [vol, order_vector] = extend_Z(x_4d(:,:,:,:,n), z_ext);
    vol_zden = den_z(vol, filters, J, lam);
    x_4d(:,:,:,:,n) = crop_Z(vol_zden, order_vector);
end
x_zden = reshape(x_4d, sz);

end

function vol_den = den_z(vol_4d, filters, J,lam)
    sz = size(vol_4d);
    T = sz(4);
    vol_den = zeros(sz);
    for i=1:sz(1)
        disp([num2str((1-i/sz(1))*100),'% remaining']);
        for j =1:sz(2)
            dwts = cell(T,1);
            for n = 1:T
                z_line = squeeze(vol_4d(i,j,:,n));
                w = udwt(z_line, J, filters{1}, filters{2});
                ww = center_udwt(w); % needed because filt padding keeps growing the size
                dwts{n} = ww;
            end
            % TVL1 STEP
            dwts_thresh = TVL1_thresh(dwts, J, T, lam);
            for n = 1:T
                ww_thresh = dwts_thresh{n};
                w_thresh = decenter_udwt(ww_thresh, w);
                z_line_thresh = iudwt(w_thresh, J, filters{3}, filters{4});
                vol_den(i,j,:,n) = z_line_thresh(1:length(z_line));
            end
        end
    end
end