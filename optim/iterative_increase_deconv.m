function [x, x_no_deconv] = iterative_increase_deconv(x, niter, target, iter, lambda)
% to go up 4x: niter = 10, increment = 0.1487
tic
increment = target^(1/niter);
x_no_deconv = x;
for n = 1:niter
    x_r = real(x);
    x_i = imag(x);
    psf_rad = ceil(increment*3)+1;
    psf = fspecial('gaussian', [psf_rad, psf_rad], increment);
    x_r = deconv_l2_pd(x_r, psf, lambda, 2, iter, iter+1);
    x_i = deconv_l2_pd(x_i, psf, lambda, 2, iter, iter+1);
    x = x_r + 1i*x_i;
    x = imresize(x, increment);
    x_no_deconv = imresize(x_no_deconv, increment);
end
toc
end