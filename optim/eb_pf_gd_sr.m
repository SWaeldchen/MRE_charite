function y = eb_pf_gd_sr(x, niter, lambda, epsilon, srfac)

% Super-resolution with relaxed partial Fourier equality constraint
pf_x = fft(x);
x_super = imresize(x, srfac);

step_size = 4*(1.8/( 1 + lambda*8/epsilon ));
%step_size = 1;
y = x_super;
e = zeros(niter, 1);
for n = 1:niter
    pf_y = pf(y, srfac);
    %e(n) = eval_f(pf_y, pf_x, lambda, epsilon);
    %diff = step_size*grad_f(pf_y, pf_x, lambda, epsilon);
    e(n) = eval_f(y, x, lambda, epsilon);
    diff = step_size*grad_f(y, x, lambda, epsilon);
    y = y - diff;
end

figure(1);
plot(e); axis tight;
figure(2);
imshow(y, []);

end

function e = eval_f(y,x,lambda,epsilon)
    e = 0.5*L2_norm(x - y).^2 + lambda*TV(y, epsilon);
end

function g = grad_f(y, x, lambda, epsilon)
    del_J = grad_J(y, epsilon);
    g = y-x+lambda*del_J;
end

function pf_mat = pf(y, srfac)
    sz = size(y);
    mids = round(sz / 2);
    range_from_ctr = round(sz / srfac);
    x_lo = max(mids(1) - range_from_ctr(1), 1); % for edge case of srfac = 1 and pixel dim is even
    y_lo = max(mids(2) - range_from_ctr(2), 1); 
    x_hi = min(mids(1) + range_from_ctr(1), sz(1));
    y_hi = min(mids(2) + range_from_ctr(2), sz(2));

    xrange = ( x_lo:1:x_hi );
    yrange = ( y_lo:1:y_hi );
    ft_mat = fft(y);
    pf_mat = ft_mat(xrange, yrange);
end




