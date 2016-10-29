function x_rec = eb_gd_tik_2(x, niter, lambda, tau)

x_rec = x;
e = zeros(niter, 1);
for n = 1:niter
    e(n) = eval_f(x_rec, x, lambda);
    diff = step_size*grad_f(x_rec, x, lambda);
    y = y - tau*diff;
end


figure(1);
plot(e); axis tight;
figure();
imshow(y, []);

end

function e = eval_f(signal_rec, signal, lambda)
    [x_grad, y_grad] = gradient(signal_rec);
    e = 0.5*norm(signal_rec-signal) + norm(lambda*(x_grad + y_grad));
end

function e = grad_f(signal_rec, signal, lambda)
    [gradx, grady] = gradient(signal_rec);
    d = div(gradx, grady);
    e = signal - signal_rec - lambda*d;
end

function d = div(gradx, grady)
    d = grady([2:end 1],:)-grady(:,:,1) + gradx(:,[2:end 1])-gradx(:,:);
end






