function x_rec = eb_gd_tik_3(x, niter, lambda, tau)

x_rec = x;
e = zeros(niter, 1);
fid = zeros(niter, 1);
reg = zeros(niter, 1);
for n = 1:niter
    [e_, fid_, reg_] = eval_f(x_rec, x, lambda);
    e(n) = e_;
    fid(n) = fid_;
    reg(n) = reg_;
    diff = grad_f(x_rec, x, lambda);
    x_rec = x_rec - tau*diff;
end


figure(1);
subplot(3, 1, 1); plot(e); axis tight;
subplot(3, 1, 2); plot(fid); axis tight;
subplot(3, 1, 3); plot(reg); axis tight;

figure();
imshow(x_rec, []);

end

function [e, fid, reg] = eval_f(x_rec, x, lambda)
    [gradx, grady] = gradient1(x_rec);
    fid = 0.5*norm(x_rec-x);
    reg = norm(sqrt(gradx.^2 + grady.^2));
    e =  fid + lambda*reg;
end

function e = grad_f(x_rec, x, lambda)
    [gradx, grady] = gradient(x_rec);
    d = div(gradx, grady);
    e = x - x_rec - lambda*d;
end

function d = div(gradx, grady)
    d = grady([2:end 1],:)-grady(:,:,1) + gradx(:,[2:end 1])-gradx(:,:);
end


function [gradx, grady] = gradient1(f)
    grad = @(x)cat(3, x-x([end 1:end-1],:), x-x(:,[end 1:end-1]));
    grad_f = grad(f);
    grady = grad_f(:,:,1);
    gradx = grad_f(:,:,2);
end



