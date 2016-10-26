function x = iterative_increase_smtv(x, niter, increment)
% to go up 4x: niter = 10, increment = 0.1487
for n = 1:niter
    x = akima_2d(x, increment);
    x_r = real(x);
    x_i = imag(x);
    x_r = eb_gd_tv(x_r, 100, 0.01, 0.001, 2);
    x_i = eb_gd_tv(x_i, 100, 0.01, 0.001, 2);
    x = x_r + 1i*x_i;
end

end