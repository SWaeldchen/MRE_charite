function x = iterative_increase_gauss(x, niter, target)
increment = target^(1/niter);
for n = 1:niter
    x = imresize(x, increment);
    sigma = increment/3;
    g = fspecial('gaussian', [ceil(sigma*3) ceil(sigma*3)], sigma);
    x_r = real(x);
    x_r = conv2(x_r, g, 'same');
    x_i = imag(x);
    x_i = conv2(x_i, g, 'same');    
    x = x_r + 1i*x_i;
end

end