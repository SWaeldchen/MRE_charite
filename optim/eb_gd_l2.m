function xhat = eb_gd_l2(x, niter, lambda)

step_size = 0.1;
%step_size = 1;
xhat = x;
e = zeros(niter, 1);
for n = 1:niter
    e(n) = eval_f(xhat, x, lambda);
    diff = step_size*grad_f(xhat, x, lambda);
    xhat = xhat - diff;
end

figure(1);
plot(e); axis tight;
figure();
imshow(xhat(2:end, 2:end), []);

end

function e = eval_f(xhat, x, lambda)
    [gradx, gradxhat] = gradient(xhat);
    %fidelitxhat = 0.5*norm(xhat-x)
    %smooth = lambda*sum(abs(gradx(:)) + abs(gradxhat(:)))
    e = 0.5*norm(xhat-x) + lambda*sqrt(sum(gradx(:).^2 + gradxhat(:).^2));
end

function del_f = grad_f(xhat, x, lambda)
    [gradx, gradxhat] = gradient(xhat);
    del_f = (xhat-x) + 2^3*lambda*(gradx + gradxhat);
end








