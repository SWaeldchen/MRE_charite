function x_rec = eb_gd_tv_wavelet(x, niter, lambda, tau, epsilon)

x_rec = x;
J = 1;
spin = 2;
[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;
x_dwt = cplxdual2D(x, J, Faf, af);
e = zeros(niter, 1);
fid = zeros(niter, 1);
reg = zeros(niter, 1);
for n = 1:niter
    [e_, fid_, reg_] = eval_f(x_rec, x, lambda, epsilon);
    e(n) = e_;
    fid(n) = fid_;
    reg(n) = reg_;
    x_rec_temp = x_rec;
    x_rec = 0;
    for ii = 0:spin-1
        for jj = 0:spin-1
            x_rec_dwt = cplxdual2D(circshift(x_rec_temp, [ii jj]), J, Faf, af);
            for j = 1:J
                % loop thru subbands
                for s1 = 1:2
                    for s2 = 1:3
                        x_r = x_dwt{j}{1}{s1}{s2};
                        x_i = x_dwt{j}{2}{s1}{s2}; 
                        x_rec_r = x_rec_dwt{j}{1}{s1}{s2};
                        x_rec_i = x_rec_dwt{j}{2}{s1}{s2}; 
                        diff_r = grad_f(x_rec_r, x_r, lambda, epsilon);
                        diff_i = grad_f(x_rec_i, x_i, lambda, epsilon);
                        x_rec_dwt{j}{1}{s1}{s2} = x_rec_r - tau*diff_r;
                        x_rec_dwt{j}{2}{s1}{s2} = x_rec_i - tau*diff_i;
                    end
                end
            end
            x_rec = x_rec + circshift(icplxdual2D(x_rec_dwt, J, Fsf, sf), [-ii -jj]);
            %mean(x_rec(:)) % / mean(x_rec_temp(:))
        end
    end
    x_rec = x_rec ./ spin^2;
end


%figure(1);
%subplot(3, 1, 1); plot(e); axis tight;
%subplot(3, 1, 2); plot(fid); axis tight;
%subplot(3, 1, 3); plot(reg); axis tight;

%figure();
%imshow(x_rec, []);

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




