function x_rec = eb_gd_tik_pf(x, niter, lambda, lf_lambda, tau)

sz = size(x);
midpts = round(sz/2);
span = round(sz/4);

x_rec = x;
e = zeros(niter, 1);
fid = zeros(niter, 1);
pf = zeros(niter, 1);
tik = zeros(niter, 1);

for n = 1:niter
    [lf_x_pf, lf_x_lf] = lowfreq(x, sz, midpts, span);
    [lf_x_pf_rec, lf_x_lf_rec] = lowfreq(x_rec, sz, midpts, span);
    [e_, fid_, pf_, tik_] = eval_f(x_rec, x, lf_x_pf_rec, lf_x_pf, lambda, lf_lambda);
    e(n) = e_;
    fid(n) = fid_;
    pf(n) = pf_;
    tik(n) = tik_;
    diff = grad_f(x_rec, x, lf_x_lf_rec, lf_x_lf, lambda, lf_lambda);
    x_rec = x_rec - tau*diff;
end


figure(1);
subplot(4, 1, 1); plot(e); axis tight; title('Obj Function');
subplot(4, 1, 2); plot(fid); axis tight; title('Fidelity to Image');
subplot(4, 1, 3); plot(pf); axis tight; title('Fidelity to low-freq Fourier coeffs');
subplot(4, 1, 4); plot(tik); axis tight; title('Roughness');

figure();
imshow(x_rec, []);

end

function [e, fid, pf, tik] = eval_f(x_rec, x, lf_x_rec, lf_x, lambda, lf_lambda)
    [gradx, grady] = gradient1(x_rec);
    fid = 0.5*norm(x_rec-x);
    pf = norm(lf_x_rec - lf_x);
    tik = norm(sqrt(gradx.^2 + grady.^2));
    e =  fid + lambda*tik + lf_lambda*pf;
end

function e = grad_f(x_rec, x, lf_x_rec, lf_x, lambda, lf_lambda)
    [gradx, grady] = gradient1(x_rec);
    d = div(gradx, grady);
    e = (x - x_rec) + lf_lambda*(lf_x - lf_x_rec) - lambda*d;
end

function d = div(gradx, grady)
    d = grady([2:end 1],:)-grady(:,:,1) + gradx(:,[2:end 1])-gradx(:,:);
end

function [x_pf, x_lf]  = lowfreq(x, sz, midpts, span)
    x_ft = fftshift(fft2(x));
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


