
n = 1000;

ons = ones(n,1);

x = rand(n, n);

y = rand(n,n);

diagMatrix = spdiags([y(:)],[0],n^2,n^2);

f_sparse = @() diagMatrix*x(:);
f_mult = @() x.*y;

sparse = timeit(f_sparse)
direkt = timeit(f_mult)



% 

% convMatrix = spdiags([-ons, ons],[0,2],n-2,n);
% 
% convFilter = [-1; 0; 1];
% 
% f_conv = @() convn(x, convFilter, 'valid');
% f_mult = @() convMatrix*x;
% 
% 
% 
% tic;
% v = f_mult();
% b = toc
% 
% tic;
% v = f_conv();
% b = toc

%b-a


% 
% 
% convTime = timeit(f_conv)
% multTime = timeit(f_mult)

% on = ones(n,1);
% 
% A = spdiags([-2*on 4*on -on],-1:1,n,n);
% full(A)
% 
% b = sum(A,2); tol = 1e-8; maxit = 15;
% b
% 
% M1 = spdiags([on/(-2) on],-1:0,n,n);
% M2 = spdiags([4*on -on],0:1,n,n);
% 
% full(M1)
% full(M2)
% 
% x = lsqr(A,b,tol,maxit,M1,M2)
% 
% return

% Or, use this matrix-vector product function
% %-----------------------------------%
% function y = afun(x,n,transp_flag)
% if strcmp(transp_flag,'transp')
% y = 4 * x;
% y(1:n-1) = y(1:n-1) - 2 * x(2:n);
% y(2:n) = y(2:n) - x(1:n-1);
% elseif strcmp(transp_flag,'notransp')
% y = 4 * x;
% y(2:n) = y(2:n) - 2 * x(1:n-1);
% y(1:n-1) = y(1:n-1) - x(2:n);
% end
% %-----------------------------------%
% as input to lsqr:
% x1 = lsqr(@(x,tflag)afun(x,n,tflag),b,tol,maxit,M1,M2);
