function x = iterative_increase_smtv_gauss(x, niter, increment, tv_iter, lambda, epsilon)
% to go up 4x: niter = 10, increment = 0.1487
for n = 1:niter
    x = imresize(x, increment);
    x_r = real(x);
    x_i = imag(x);
    x_r = eb_gd_tv(x_r, tv_iter, lambda, 0.001, epsilon);
    x_i = eb_gd_tv(x_i, tv_iter, lambda, 0.001, epsilon);
    x = x_r + 1i*x_i;
end

end