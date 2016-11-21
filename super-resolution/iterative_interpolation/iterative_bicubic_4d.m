function x_interp = iterative_bicubic_4d(x, target, niter)

sz = size(x);
for n = 1:sz(4)
    x_interp(:,:,:,n) = iterative_bicubic_3d(x(:,:,:,n), target, niter); %#ok<AGROW>
end

