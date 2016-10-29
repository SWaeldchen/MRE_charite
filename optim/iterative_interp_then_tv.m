function [x, x_notv] = iterative_interp_then_tv(x, niter, target, tv_iter, lambda, tau, epsilon)
% to go up 4x: niter = 10, increment = 0.1487
tic
increment = target^(1/niter);
for n = 1:niter
    x = imresize(x, increment);
end
x_notv = x;
x_r = real(x);
x_i = imag(x);
x_r = eb_gd_tv(x_r, tv_iter, lambda, tau, epsilon);
x_i = eb_gd_tv(x_i, tv_iter, lambda, tau, epsilon);
x = x_r + 1i*x_i;
toc
end