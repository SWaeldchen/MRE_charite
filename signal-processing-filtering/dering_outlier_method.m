function v = dering_outlier_method(u)

C = 1;

sz = size(u);
v_ft = zeros(sz);
u_ft = fftshift(fftn(u));
u_spec = logpwrspec(u);
for n = 1:sz(3)
    slc_ft = u_ft(:,:,n);
    slc_spec = u_spec(:,:,n);
    % get sample max away from outliers
    sample_max = max(vec(slc_spec(9:sz(1)/8*2, 9:sz(2)/8*2)));
    sample_max = sample_max * C;
    % search at likely points and kill outliers
    x_pts = [sz(2)/2, ...
        sz(2)/4, sz(2)/2, 3*sz(2)/4, ...
        1, sz(2)/4, 3*sz(2)/4, sz(2), ...
        sz(2)/4, sz(2)/2, 3*sz(2)/4, ...
        sz(2)/2];
    y_pts = [1, ...
        sz(1)/4, sz(1)/4, sz(1)/4, ...
        sz(1)/2, sz(1)/2, sz(1)/2, sz(1)/2, ...
        3*sz(1)/4, 3*sz(1)/4, 3*sz(1)/4, ...
        sz(1)];
    slc_filt = search_and_destroy(slc_ft, slc_spec, x_pts, y_pts, sample_max, sz);
    v_ft(:,:,n) = slc_filt;
end
v = ifftn(ifftshift(v_ft));
end

function slc_ft = search_and_destroy(slc_ft, slc_spec, likely_x, likely_y, sample_max, sz)
    RADIUS = 32;
    x = vec(likely_x);
    y = vec(likely_y);
    for n = 1:numel(x)
        x_range = max((x(n)-RADIUS),1) :1: min((x(n)+RADIUS), sz(2));
        y_range = max((y(n)-RADIUS),1) :1: min((y(n)+RADIUS), sz(1));
        mdn = median(vec(slc_spec(y_range, x_range)));
        mx = max(vec(slc_spec(y_range, x_range)));
        spec_no_out = slc_spec(y_range, x_range) < (mdn + (mx-mdn)/2) ;
        slc_ft(y_range, x_range) = slc_ft(y_range, x_range).*spec_no_out;
    end
end
        
        