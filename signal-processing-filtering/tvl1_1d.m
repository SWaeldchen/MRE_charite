function [uu, primal] = tvl1_1d(f, lambda, maxiter, check)

M = size(f,1);
f = f(:);
u = f;
nabla = spdiags([-ones(M,1) ones(M,1)], [0 1], M, M);

p = zeros(M,1);

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
  p = bsxfun(@rdivide,p,max(1, sqrt(sum(p.^2,2))/lambda));
  
  e = lambda*sum(sum(sqrt(nabla*u.^2),2)) + norm(u-f,1);
  primal = [primal, e]; %#ok<AGROW>
  
  if mod(k, check) == 0
    uu = u;    
    fprintf('tvl1_pd: k = %4d, primal = %f\n', k, e);
    figure(1); plot(uu); drawnow;
  end
end