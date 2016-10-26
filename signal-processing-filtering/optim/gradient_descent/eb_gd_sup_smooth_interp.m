function x_rec = eb_gd_sup_smooth_interp(x, niter, lambda,  tau, superfac, mode, swap, epsilon)
if nargin < 8
    epsilon = 0;
    if nargin < 7
        swap = 1;
    end
end
sz = size(x);
if mod(sz(1), 2) ~= 0
    x(end+1,:) = x(end-1, :);
end
if mod(sz(2), 2) ~= 0
    x(:, end+1,:) = x(:, end-1);
end
x = simplepad(x, sz);
x = ft_interp_2d(x, superfac);
sz = size(x);
midpts = round(sz/2);
span = round(midpts/superfac);

x_rec = x;
e = zeros(niter, 1);
fid = zeros(niter, 1);
reg = zeros(niter, 1);
[~, lf_x_lf, x_i_start, x_i_end, x_j_start, x_j_end] = lowfreq(x, sz, midpts, span);
lf_x_ft = fftshift(fft2(lf_x_lf));


for n = 1:niter
    [e_, fid_, reg_] = eval_f(x_rec, x, lambda, mode, epsilon);
    e(n) = e_;
    fid(n) = fid_;
    reg(n) = reg_;
    diff = grad_f(x_rec, x, lambda, mode, epsilon);
    x_rec = x_rec - tau*diff;
    if swap == 1
        x_rec_ft = fftshift(fft2(mirror(x_rec)));
        xrange = x_i_start:x_i_end;
        yrange = x_j_start:x_j_end;
        x_rec_ft(xrange, yrange) = lf_x_ft(xrange, yrange);
        figure(2); imshow(log(abs(x_rec_ft)), []);
        x_rec = mircrop(real(ifft2(ifftshift(x_rec_ft))));
    end
end


figure(1);
subplot(3, 1, 1); plot(e); axis tight; title('Obj Function');
subplot(3, 1, 2); plot(fid); axis tight; title('Fidelity to Image');
subplot(3, 1, 3); plot(reg); axis tight; title('Roughness');

end

function [e, fid, reg] = eval_f(x_rec, x, lambda, mode, epsilon)
    [gradx, grady] = gradient1(x_rec);
    fid = 0.5*norm(x_rec-x);
    if strcmp(mode, 'L1') == 1
        tv = TV(x_rec, epsilon);
        reg = tv;
        e =  fid + lambda*tv;
    elseif strcmp(mode, 'L2') == 1
        tik = norm(sqrt(gradx.^2 + grady.^2));
        reg = tik;
        e =  fid + lambda*tik;
    else
        display('Mode not recognized.');
    end
end

function e = grad_f(x_rec, x, lambda, mode, epsilon)
    [gradx, grady] = gradient1(x_rec);
    if strcmp(mode, 'L1') == 1
        norm_vals = smoothed_L1(gradx, grady, epsilon);
        gradx_norm = gradx ./ norm_vals;
        grady_norm = grady ./ norm_vals;
        d = div(gradx_norm, grady_norm);
        e = (x - x_rec) - lambda*d;
    elseif strcmp(mode, 'L2') == 1
        d = div(gradx, grady);
        e = (x - x_rec) - lambda*d;
    else
        display('Mode not recognized.');
    end
end

function d = div(gradx, grady)
    d = grady([2:end 1],:)-grady(:,:,1) + gradx(:,[2:end 1])-gradx(:,:);
end

function [x_pf, x_lf, x_i_start, x_i_end, x_j_start, x_j_end]  = lowfreq(x, sz, midpts, span)
    x_mir = mirror(x);
    sz = 2*sz;
    midpts = 2*midpts;
    span = 2*span;
    x_ft = fftshift(fft2(x_mir));
    x_i_start = max(midpts(1) - span(1), 1);
    x_i_end = min(midpts(1) + span(1), sz(1));
    x_j_start = max(midpts(2) - span(2), 1);
    x_j_end = min(midpts(2) + span(2), sz(2));
    x_pf = x_ft(x_i_start:x_i_end, x_j_start:x_j_end);
    x_lf = zeros(size(x_ft));
    x_lf(x_i_start:x_i_end, x_j_start:x_j_end) = x_pf;
    x_lf = real(ifft2(ifftshift(x_lf)));
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

function x_mircrop = mircrop(x)
    sz = size(x);
    sz_crop = sz / 2;
    x_mircrop = x(1:sz_crop(1), 1:sz_crop(2));
end