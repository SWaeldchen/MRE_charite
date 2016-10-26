function [x, x_no_tv] = iterative_increase_smtv_bicubic(x, niter, target, tv_iter, lambda, tau, epsilon)
% to go up 4x: niter = 10, increment = 0.1487
tic
increment = target^(1/niter);
x_no_tv = x;
for n = 1:niter
    x_r = real(x);
    x_i = imag(x);
    x_r = eb_gd_tv(x_r, tv_iter, lambda, tau, epsilon);
    x_i = eb_gd_tv(x_i, tv_iter, lambda, tau, epsilon);
    x = x_r + 1i*x_i;
    x = imresize(x, increment);
    x_no_tv = imresize(x_no_tv, increment);
end
toc
end