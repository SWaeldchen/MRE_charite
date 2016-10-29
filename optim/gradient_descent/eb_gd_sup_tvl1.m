function x_rec = eb_gd_sup_tvl1(x, niter, lambda,  tau, superfac, epsilon)

sz = size(x);
if mod(sz(1), 2) ~= 0
    x(end+1,:) = x(end-1, :);
end
if mod(sz(2), 2) ~= 0
    x(:, end+1,:) = x(:, end-1);
end
x = simplepad(x, sz);
x = ft_interp_2d(x, superfac);

x_rec = x;
e = zeros(niter, 1);
fid = zeros(niter, 1);
reg = zeros(niter, 1);

for n = 1:niter
    [e_, fid_, reg_] = eval_f(x_rec, x, lambda, epsilon);
    e(n) = e_;
    fid(n) = fid_;
    reg(n) = reg_;
    diff = grad_f(x_rec, x, lambda, epsilon);
    x_rec = x_rec - tau*diff;
end


figure(1);
subplot(3, 1, 1); plot(e); axis tight; title('Obj Function');
subplot(3, 1, 2); plot(fid); axis tight; title('Fidelity to Image');
subplot(3, 1, 3); plot(reg); axis tight; title('Roughness');

end

function [e, fid, reg] = eval_f(x_rec, x, lambda, epsilon)
    fid = TV(x_rec-x, epsilon);
    tv = TV(x_rec, epsilon);
    reg = tv;
    e =  fid + lambda*tv;
end

function e = grad_f(x_rec, x, lambda, epsilon)
    [gradx, grady] = gradient1(x_rec);
    [gradx_fid, grady_fid] = gradient1(x - x_rec);
    norm_vals = smoothed_L1(gradx, grady, epsilon);
    gradx_norm = gradx ./ norm_vals;
    grady_norm = grady ./ norm_vals;
    d = div(gradx_norm, grady_norm);

    norm_vals_fid = smoothed_L1(gradx_fid, grady_fid, epsilon);
    gradx_fid_norm = gradx_fid ./ norm_vals_fid;
    grady_fid_norm = grady_fid ./ norm_vals_fid;
    d_fid = div(gradx_fid_norm, grady_fid_norm);        

    e = d_fid - lambda*d;
end

function d = div(gradx, grady)
    d = grady([2:end 1],:)-grady(:,:,1) + gradx(:,[2:end 1])-gradx(:,:);
end

function [gradx, grady] = gradient1(f)
    grad = @(x)cat(3, x-x([end 1:end-1],:), x-x(:,[end 1:end-1]));
    grad_f = grad(f);
    grady = grad_f(:,:,1);
    gradx = grad_f(:,:,2);
end

function x_interp = ft_interp_2d(x, superfac)
    x_mir = mirror(x);
    x_ft = fftshift(fft2(x_mir));
    sz_orig = size(x_mir);
    mids_orig = round(sz_orig / 2);
    x_interp = zeros(sz_orig*superfac);
    sz_interp = size(x_interp);
    mids_interp = round(sz_interp / 2);
    x_i_start = max(mids_interp(1) - mids_orig(1), 1);
    x_i_end = min(x_i_start + sz_orig(1), sz_interp(1));
    x_j_start = max(mids_interp(2) - mids_orig(2), 1);
    x_j_end = min(x_j_start + sz_orig(2), sz_interp(2));
    x_interp(x_i_start+1:x_i_end, x_j_start+1:x_j_end) = x_ft;
    x_interp = real(ifft2(ifftshift(x_interp)));
    x_interp = x_interp(1:mids_interp(1), 1:mids_interp(2));
end

function x_mir = mirror(x)
    x1 = [x fliplr(x)];
    x2 = flipud(x1);
    x_mir = [x1; x2];
end
