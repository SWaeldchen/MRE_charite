function x = iterative_bicubic(x, niter, target)
% to go up 4x: niter = 10, increment = 0.1487
increment = target ^ (1/niter);
for n = 1:niter
    x = imresize(x, increment);
end