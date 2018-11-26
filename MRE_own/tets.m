
% N = 3000;
% s = 5;
% 
% 
% x = 1:N;
% 
% mu = gen_sparse_mu(N,s,'db10');
% 
% plot(x, mu, x(2:end), diff(mu)*3000);
% 

% N = 10;
% 
% A = eye(N);
% 
% x = 1:N;
% y = 1:N;
% 
% A(x == y'-1) = -1
% 
% inv(A)

N = 10;
k = 4;


A = sparse(N-k+1, N);

x = 1:N;
y = 1:N-k+1;

A((x>=y')&(x<y'+k)) = 1;

% N = 7;
% k = 4;
% 
% 
% B = sparse(N-k+1, N);
% 
% x = 1:N;
% y = 1:N-k+1;
% 
% B((x>=y')&(x<y'+k)) = 1;
% 
% full(B*A)
