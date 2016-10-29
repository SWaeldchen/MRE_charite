function x = iterative_increase(x, niter, increment, lambda)
% to go up 4x: niter = 10, increment = 0.1487
for n = 1:niter
    x = akima_2d(x, increment);
    %x = rof_fem_pd(x, lambda, 10, 10);
    %[x_r, mn_r, mx_r] = normalize(real(x));
    %range_r = mx_r - mn_r;
    x_r = real(x);
    x_r = rof_fem_pd(x_r,  lambda, 5, 10);
    
    %[x_i, mn_i, mx_i] = normalize(imag(x));
    %range_i = mx_i - mn_i;
    x_i = imag(x);
    x_i = rof_fem_pd(x_i, lambda, 5, 10);
    
    x = x_r + 1i*x_i;
    %x = denormalize(x_r, mn_r, mx_r) + 1i*denormalize(x_i, mn_i, mx_i);
end

end

function [x, mn, mx] = normalize(x)

mn = min(x(:));
mx = max(x(:));
x = (x - mn) / (mx-mn);

end

function [x] = denormalize(x, mn, mx)

x = x * (mx - mn) - mn;

end