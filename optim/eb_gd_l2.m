function y = eb_gd_l2(x, niter, lambda)

step_size = 0.1;
%step_size = 1;
y = x;
e = zeros(niter, 1);
for n = 1:niter
    e(n) = eval_f(y, x, lambda);
    diff = step_size*grad_f(y, x, lambda);
    y = y - diff;
end

figure(1);
plot(e); axis tight;
figure();
imshow(y(2:end, 2:end), []);

end

function e = eval_f(y, x, lambda)
    [gradx, grady] = gradient(y);
    fidelity = 0.5*norm(y-x)
    smooth = lambda*sum(abs(gradx(:)) + abs(grady(:)))
    e = 0.5*norm(y-x) + lambda*sqrt(sum(gradx(:).^2 + grady(:).^2));
end

function del_f = grad_f(y, x, lambda)
    [gradx, grady] = gradient(y);
    del_f = (y-x) + 8*lambda*(gradx + grady);
end








