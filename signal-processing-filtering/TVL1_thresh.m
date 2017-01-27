function dwts_thresh = TVL1_thresh(dwts, J, T, lam)

% make coeffs into 2D grid
len_pad = size(dwts{1}{J}, 1);
len_pad_mid = len_pad / 2;
len = size(dwts{1}{1}, 1);
len_mid = len / 2;
coeff_grid = zeros(T,J,len);
lo = len_pad_mid - len_mid + 1;
hi = len_pad_mid + len_mid;
dwts_thresh = dwts;
for m = 1:T
    for n = 1:J
        coeff_grid(m,n,:) = dwts{m}{n}(lo:hi);
    end
end
coeff_grid_thresh = TVL1(coeff_grid, lam);
for m = 1:T
    for n = 1:J
        dwts_thresh{m}{n}(lo:hi) = coeff_grid_thresh(m,n,:);
    end
end
end


function x_thresh = TVL1(x, lambda)

sz = size(x);
x = x(:);
u = x;
G = make_nabla_3d(sz(1), sz(2), sz(3));

p = zeros(prod(sz)*numel(sz),1);

L = sqrt(8);
tau = 1/L;
sigma = 1/tau/L^2;

%primal = [];
maxiter = 50;
for k = 1:maxiter
  
  u_ = u;
  u = u - tau*G'*p;
  u = x + max(0, abs(u-x)-tau).*sign(u-x);
  u_ = 2*u-u_;
  
  p = p + sigma*(G*u_);
  p = reshape(p,[sz numel(sz)]);
  p = reshape(bsxfun(@rdivide,p,max(1, sqrt(sum(p.^2,2))/lambda)), prod(sz)*numel(sz),1);
  
  %e = lambda*sum(sum(sqrt(reshape(nabla*u, M*N, 2).^2),2)) + norm(u-f,1);
  %primal = [primal, e];
end

x_thresh = reshape(u, sz);

end