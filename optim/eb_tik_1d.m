function eb_tik_1d

signal = sinVec(512, 86);
signal = [signal fliplr(signal)];
signal = signal + randn(size(signal))*0.05;
lambda = 10;
niter = 30;
signal_min = tik_min_1d(signal, lambda, niter);
signal_stack = tik_lsq_1d_stack(signal, lambda);
signal_pinv = tik_lsq_1d_pinv(signal, lambda);
figure(1);
subplot(4, 1, 1); plot(signal);
subplot(4, 1, 2); plot(signal_min);
subplot(4, 1, 3); plot(signal_stack);
subplot(4, 1, 4); plot(signal_pinv);

end

function signal_rec = tik_min_1d(signal, lambda, niter)
    e = zeros(niter,1);
    signal_rec = signal;
    tau = 0.1;
    for n = 1:niter
        e(n) = eval_f(signal_rec, signal, lambda);
        diff = tau*grad_f(signal_rec, signal, lambda);
        signal_rec = signal_rec - diff;
    end
    figure(2); plot(e);
end

function e = eval_f(signal_rec, signal, lambda)
    signal_grad = conv(signal_rec, [1 -1], 'same');
    e = 0.5*norm(signal_rec-signal) + lambda*norm(signal_grad);
end

function g = grad_f(signal_rec, signal, lambda)
    signal_lap = conv(signal_rec, [1 -2 1], 'same');
    g = (signal - signal_rec) + lambda*(signal_lap);
end
        
function signal_stack = tik_lsq_1d_stack(signal, lambda)
    grad = gradient_matrix(signal)*lambda;
    A = [eye(numel(signal)); grad];
    s = signal';
    b = [s; zeros(size(s))];
    signal_stack = A\b;
end

function m = gradient_matrix(signal)
    n = numel(signal);
    diag1 = ones(n,1);
    diag2 = -diag1;
    m = spdiags([diag1 diag2], [0 1], n, n);
end

function signal_pinv = tik_lsq_1d_pinv(signal, lambda)
    A = [eye(numel(signal))];
    G = gradient_matrix(signal)*lambda;
    s = signal';
    b = [s];
    signal_pinv = inv(A'*A + G'*G)*A'*b; %#ok<MINV>
end

