function [x, x_no_tv] = iterative_increase_wavelet(x, niter, target, tv_iter, lambda, tau, epsilon)
% to go up 4x: niter = 10, increment = 0.1487
increment = target^(1/niter);
x_no_tv = x;
sz = size(x);
max_dim = max(sz(1), sz(2));
effective_image_size = max_dim;
for n = 1:niter
    tic
    padding = nextpwr2(effective_image_size)
    x = simplepad(x, [padding padding]);
    x_r = real(x);
    x_i = imag(x);
    x_r = eb_gd_tv_wavelet(x_r, tv_iter, lambda, tau, epsilon);
    x_i = eb_gd_tv_wavelet(x_i, tv_iter, lambda, tau, epsilon);
    x = x_r + 1i*x_i;
    x = imresize(x, increment);
    effective_image_size = ceil(effective_image_size*increment);
    x = simplecrop(x, [effective_image_size, effective_image_size]);
    x_no_tv = imresize(x_no_tv, increment);
    toc
end

end
