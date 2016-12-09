function [v] = tgv_denoise_3d(f, lambda_1, lambda_0, maxiter, check)

[I, J, K] = size(f);
f = f(:);
b1 = I*J*K;
b2 = I*J*K*3;
nabla = make_nabla_3d(I,J,K);
A = [nabla,  sparse(b2, b1), sparse(b2, b1);
     sparse(b2, b1), nabla, sparse(b2, b1);
     sparse(b2, b1), sparse(b2, b1), nabla];

L = sqrt(12);

u = zeros(b1*3,1);
u(1:b1) = f;
p = zeros(b2*3,1);

tau = 0.05/L;
sigma = 1/tau/L^2;

for k = 1:maxiter
 
  % remeber old value
  u_ = u;
  
  % linear update
  u = u - tau*(A'*p);
  
  % Prox for squared data term
  u1 = u(1:b1);
  u1 = (u1 + tau*f)/(1+tau);  
  u(1:b1)=u1;
  
  % overrelaxation
  u_ = 2*u-u_;
  
  % linear update
  p = p + sigma*A*u;
  
  % prox for first order term
  p1 = reshape(p(1:b2),b1,3);
  p1 = reshape(bsxfun(@rdivide,p1,max(1, sqrt(sum(p1.^2,2))/lambda_1)), b2,1);
  p(1:b2) = p1;
  
  % prox for second order term
  p2 = reshape(p(b2+1:end),b2,2);
  p2 = reshape(bsxfun(@rdivide,p2,max(1, sqrt(sum(p2.^2,2))/lambda_0)), b2*2,1);
  p(b2+1:end) = p2;
   
  if mod(k, check) == 0
    fprintf('tgv_pd: k = %4d\n', k);
    vol_resh = reshape(u(1:b1), [I, J, K]);
    sfigure(1); imshow(vol_resh(:,:,round(K/2))); drawnow;
  end
end

v = reshape(u(1:b1),[I, J,K]);