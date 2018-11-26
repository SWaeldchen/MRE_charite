

% gridSize = 1000;
% x = (1:gridSize)';
% 
% mu = sin(x/gridSize*5*pi);
% 
% mu = mu + randn(size(mu))/10;
% 
% 
% itSteps =1000;
% 
% muIt = mu;
% 
% lambda = 200;
% alpha = 0.01;
% 
% 
% muRec = (speye(gridSize) + lambda*gradMat(gridSize)'*gradMat(gridSize))\mu;

% A = randn(100,100);
% x = randn(100,1);
% 
% b = A*x;
% 
% y = lsqr(A,b, 1e-6, 1000);
% 
% z = A\b;
% 
% norm(x-y), norm(y-z), norm(x-z)

% mu = ones(100,1);
% 
% M = full(waveOp_for_u(mu, 0.0002));
% 
% cond(M)
% 
% N = fft(fft(M')');
% 
% cond(diag(diag(N))\N)

N = 10;

mu = ones(N,1); %
%mu = mu_func((1:N)/N)'; %ones(N,1) + randn(N,1)/10;

sigma = 0.003;
% D = waveOp_for_u(mu, sigma);
% 
% E = laplace_op(N) + sigma*speye(N);
% 
% full(E);
% full(D);
% 
% con = cond(full(E))

%U = dst(eye(N-2)); %gen_wave_mat(N, fix(log2(N)), 'db1');

% UEU = (U*E*U')
% UDU = (U*D*U')

muLap = spdiags( [mu(2:end-1), -(mu(1:end-2) + mu(2:end-1)), mu(1:end-2)], [-1,0,1], N-2, N-2);

eee = eigs(muLap, N-2)



idst(eye(N-2))*diag(1./(2 - 2*cos(pi/(N-1)*(1:N-2)')))*dst(eye(N-2))

full(inv(muLap))

% tic
% [L, U] = ilu(muLap);
% toc
% 
% x = rand(N-2, 1);
% 
% tic
% L\(U\x);
% toc
% 
% 
% tic
% muLap\x;
% toc

% eigs(muLap, N-2)
% 
% ml = muLap + sigma*speye(N-2);
% condest(ml)
% 
% UMU = U*ml*U'
% 
% wLet = 'db3';
% % N = 9;
% 
% [wDec, wRec] = gen_wave_mat(N-2, wmaxlev(N-2, wLet), wLet);
% 
% size(wRec)
% size(ml)
% size(wDec)
% 
% full(wDec*ml*wRec)


% cond(UDU/diag(diag(UDU)));
% cond(UEU/diag(diag(UEU)));

% cond(UMU)
% 
% cond(UMU/diag(diag(UMU)))
% cond(UMU/diag(max(abs(diag(UMU)),0.1)))
% 
% return
% cond(UDU)
% 
% 
% 
% 
% 


% 
% U
% 
% UDU = (U*D*U');
% 
% fUDU = full(UDU);
% 
% full(diag(diag(UDU'))\UDU');
% 
% UDU./(diag(UDU)');
% 
%  condest(UDU./(diag(UDU)'))


% 
% g = full(gradMat(64));
% 
% d1 = fft(g')
% d2 = fft(d1')

%fft(ones(100,1))


% waveMat = gen_wave_mat(gridSize, 5, 'db10');
% save('waveMat', waveMat);
% 
% S = load('waveMat', wavemat);
% waveMat = S.wavemat;
% 
% for step = 1:itSteps
%     
%     gradStep1 = lambda*gradMat(gridSize)'*gradMat(gridSize)*muIt + (muIt - mu);
%     gradStep2 = lambda*waveMat'*sign(waveMat*muIt) + (muIt - mu);
%     
%     
%     muIt1 = muIt1 - alpha*gradStep;
%     
%     
%     norm(gradStep)
% end
% 
% 
% plot(x, mu, 'r', x, muRec, 'b');