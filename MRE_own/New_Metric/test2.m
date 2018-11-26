

run_test();


function run_test()
N = 200;

%mu = ones(N,1); %
mu1 = mu_func((1:(N+2))/(N+2))'; %ones(N,1) + randn(N,1)/10;

muLap1 = spdiags( [mu1(2:end-1), -(mu1(1:end-2) + mu1(2:end-1)), mu1(1:end-2)], [-1,0,1], N, N);



%mu2 = mu_func((1:(N+2))/(N+2))';
mu2 = ones(N+2,1);% + randn(N+2,1)/10;

muLap2 = spdiags( [mu2(2:end-1), -(mu2(1:end-2) + mu2(2:end-1)), mu2(1:end-2)], [-1,0,1], N, N);

% cond(full(muLap1))
% 
% cond(full(inv(muLap2))*muLap1)

P = muLap2\muLap1;

x = randn(N,1);

b = P*x;

tic
x1 = P\b;
toc


tic
x2 = qmr(@Pfun, b);
toc

norm(x - x1)
norm(x - x2)


function y = Pfun(x, transp_flag)

    if strcmp(transp_flag, 'transp')

        y = muLap1*(muLap2\x);

    elseif strcmp(transp_flag, 'notransp')

        y = muLap2\(muLap1*x);

    end


end



end