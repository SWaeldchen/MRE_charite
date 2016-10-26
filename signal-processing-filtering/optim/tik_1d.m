    function tik_1d

    signal = sin((1:512)/128*2*pi);
    signal = signal + randn(size(signal))*0.05;
    lambda = 15;
    niter = 500;
    signal_lsq = tik_lsq(signal, lambda);
    signal_opt = tik_opt(signal, lambda, niter);
    figure(1); set(gcf, 'color', 'w');
    subplot(4, 1, 1); plot(signal); title('b'); ylim([-1 1]);
    subplot(4, 1, 2); plot(signal_lsq); title('LSQ x'); ylim([-1 1]);
    subplot(4, 1, 3); plot(signal_opt); title('GD x'); ylim([-1 1]);
    subplot(4, 1, 4); plot(signal_opt - signal_lsq'); title('LSQ x - GD x'); ylim([-1 1]);

    end

    function signal_lsq = tik_lsq(signal, lambda)
        grad = gradient_matrix(signal)*sqrt(lambda); %subfunction see below
        A = [eye(numel(signal)); grad];
        s = signal';
        b = [s; zeros(size(s))];
        signal_lsq = A\b;
    end

    function m = gradient_matrix(signal)
        n = numel(signal);
        diag1 = ones(n,1);
        diag2 = -diag1;
        m = spdiags([diag1 diag2], [0 1], n, n);
    end

    function signal_opt = tik_opt(signal, lambda, niter)
        e = zeros(niter,1);
        signal_opt = signal;
        tau = 0.001;
        for n = 1:niter
            e(n) = eval_f(signal_opt, signal, lambda); %subfunction see below
            diff = tau*grad_f(signal_opt, signal, lambda); %subfunction see below
            signal_opt = signal_opt - diff;
        end
        figure(2); plot(e);
    end

    function e = eval_f(signal_rec, signal, lambda)
        signal_grad = conv(signal_rec, [1 -1], 'same');
        signal_grad = gradient(signal_rec);
        e = 0.5*norm(signal_rec-signal) + norm(lambda*signal_grad);
    end

    function g = grad_f(signal_rec, signal, lambda)
        signal_lap = conv(signal_rec, [1 -2 1], 'same');
        g = (signal - signal_rec) - lambda*(signal_lap);
    end


