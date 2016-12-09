function x_interp = iterative_bicubic_5d(x, target, niter)

sz = size(x);
for n = 1:sz(5)
    x_interp(:,:,:,:,n) = iterative_bicubic_4d(x(:,:,:,:,n), target, niter); %#ok<AGROW>
end

