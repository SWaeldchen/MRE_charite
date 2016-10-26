function x_rec = smooth_tv(x, niter, lambda, tau, epsilon)

x_rec = x;
e = zeros(niter, 1);
fid = zeros(niter, 1);
reg = zeros(niter, 1);
for n = 1:niter
    [e_, fid_, reg_] = eval_f(x_rec, x, lambda, epsilon);
    e(n) = e_;
    fid(n) = fid_;
    reg(n) = reg_;
    diff = grad_f(x_rec, x, lambda, epsilon);
    x_rec = x_rec - tau*diff;
end

end

function [e, fid, reg] = eval_f(x_rec, x, lambda, epsilon)
    fid = 0.5*norm(x_rec-x);
    reg = TV(x_rec, epsilon);
    e =  fid + lambda*reg;
end

function e = grad_f(x_rec, x, lambda, epsilon)
    [gradx, grady] = gradient1(x_rec);
    norm_vals = smoothed_L1(gradx, grady, epsilon);
    gradx_norm = gradx ./ norm_vals;
    grady_norm = grady ./ norm_vals;
    d = div(gradx_norm, grady_norm); % THIS IS L1
    %d = div(gradx, grady); % THIS IS L2
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




