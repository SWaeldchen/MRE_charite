function x_rec = eb_gd_sup_zero_interp(x, niter, lambda,  tau, superfac, mode, epsilon)
if nargin < 8
    epsilon = 0;
    if nargin < 7
        swap = 1;
    end
end
sz = size(x);
if mod(sz(1), 2) ~= 0
    x(end+1,:) = x(end-1, :);
end
if mod(sz(2), 2) ~= 0
    x(:, end+1,:) = x(:, end-1);
end
x = simplepad(x, sz);
x = zero_interp_2d(x, superfac);
sz = size(x);
midpts = round(sz/2);
span = round(midpts/superfac);

x_rec = x;
e = zeros(niter, 1);
fid = zeros(niter, 1);
reg = zeros(niter, 1);

for n = 1:niter
    [e_, fid_, reg_] = eval_f(x_rec, x, lambda, mode, epsilon);
    e(n) = e_;
    fid(n) = fid_;
    reg(n) = reg_;
    diff = grad_f(x_rec, x, lambda, mode, epsilon);
    x_rec = x_rec - tau*diff;
end


figure(1);
subplot(3, 1, 1); plot(e); axis tight; title('Obj Function');
subplot(3, 1, 2); plot(fid); axis tight; title('Fidelity to Image');
subplot(3, 1, 3); plot(reg); axis tight; title('Roughness');

end

function [e, fid, reg] = eval_f(x_rec, x, lambda, mode, epsilon)
    [gradx, grady] = gradient1(x_rec);
    fid = 0.5*norm(x_rec-x);
    if strcmp(mode, 'L1') == 1
        tv = TV(x_rec, epsilon);
        reg = tv;
        e =  fid + lambda*tv;
    elseif strcmp(mode, 'L2') == 1
        tik = norm(sqrt(gradx.^2 + grady.^2));
        reg = tik;
        e =  fid + lambda*tik;
    else
        display('Mode not recognized.');
    end
end

function e = grad_f(x_rec, x, lambda, mode, epsilon)
    [gradx, grady] = gradient1(x_rec);
    if strcmp(mode, 'L1') == 1
        norm_vals = smoothed_L1(gradx, grady, epsilon);
        gradx_norm = gradx ./ norm_vals;
        grady_norm = grady ./ norm_vals;
        d = div(gradx_norm, grady_norm);
        e = (x - x_rec) - lambda*d;
    elseif strcmp(mode, 'L2') == 1
        d = div(gradx, grady);
        e = (x - x_rec) - lambda*d;
    else
        display('Mode not recognized.');
    end
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

function x_interp = zero_interp_2d(x, superfac)
    x_interp = zeros(size(x)*superfac);
    x_interp(1:superfac:end, 1:superfac:end) = x;
end