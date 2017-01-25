function [uu, primal] = tvl1_pd_eb(f, lambda, maxiter)

[M, N] = size(f);
f = f(:);
u = f;
nabla = make_nabla(M,N);

p = zeros(M*N*2,1);

L = sqrt(8);
tau = 1/L;
sigma = 1/tau/L^2;

primal = [];
for k = 1:maxiter
  
  u_ = u;
  u = u - tau*nabla'*p;
  u = f + max(0, abs(u-f)-tau).*sign(u-f);
  u_ = 2*u-u_;
  
  p = p + sigma*(nabla*u_);
  p = reshape(p,M*N,2);
  p = reshape(bsxfun(@rdivide,p,max(1, sqrt(sum(p.^2,2))/lambda)), M*N*2,1);
  
  e = lambda*sum(sum(sqrt(reshape(nabla*u, M*N, 2).^2),2)) + norm(u-f,1);
  primal = [primal, e];
  
  
end

  uu = reshape(u, M, N);    
