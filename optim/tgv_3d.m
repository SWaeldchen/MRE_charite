function [x] = tgv_3d(b, lambda_1, lambda_0, maxiter, check, A, I, J, K, NVOLS)
b = b(:);
b1 = I*J*K;
b2 = I*J*K*3;
b3 = I*J*K*NVOLS;

if nargin < 6 
    A = speye(b1, b1);
end

nabla = make_nabla_3d(I,J,K);
nabla = repmat(nabla, [1 NVOLS]);
N = [nabla,  sparse(b2, b3), sparse(b2, b3);
     sparse(b2, b3), nabla, sparse(b2, b3);
     sparse(b2, b3), sparse(b2, b3), nabla];

L = sqrt(12);

u = zeros(b3*3,1); %match N not nabla
u(1:b3) = b;
p = zeros(b3,1);

tau = 0.05/L;
sigma = 1/tau/L^2;

for k = 1:maxiter
   disp(k)

  % remeber old value
  u_ = u;
  
  % linear update
  u = u - tau*(N'*p);
  
  % Prox for squared data term
  u1 = u(1:b1);
  u1 = (u1 + tau*A'*b)/(1+tau);  
  u(1:b1)=u1;
  
  % overrelaxation
  u_ = 2*u-u_;
  
  % linear update
  p = p + sigma*N*u;
  
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
    sfigure(1); imshow(vol_resh(:,:,round(K/2)), []); drawnow;
  end
end

x = reshape(u(1:b1),[I, J,K]);