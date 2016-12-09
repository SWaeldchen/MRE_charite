function U_sr = additive_sr (U, fac)
  
  phi = 'hub';
  alpha = 1;
  lambda = 1;
  tol = 1e-15;
  max_iter = 20;
  sz = size(U);
  A = additive_sr_matrix(sz(1:3), fac);

  
  sz = size(U);
  if numel(sz) == 5
    U_sr = sr_5d(U, A, fac, phi, alpha, lambda, tol, max_iter);
  elseif numel(sz) == 4
    U_sr = sr_4d(U, A, fac, phi, alpha, lambda, tol, max_iter);
  else
    U_sr = sr_3d(U, A, fac, phi, alpha, lambda, tol, max_iter);
  end
  
  assignin('base', 'U_sr', U_sr);
  
end

function U_sr = sr_3d(U, A, fac, phi, alpha, lambda, tol, max_iter)
   sz = size(U);
   U_sr = zeros(sz*fac);
  [U_sr]=HQ_Multiplicative(zeros(size(U)*fac), U, A,phi,alpha,lambda,tol,max_iter);
end

function U_sr = sr_4d(U, A, fac, phi, alpha, lambda, tol, max_iter)
  sz = size(U);
  %U_sr = zeros([sz(1)*fac, sz(2)*fac, sz(3)*fac, sz(4)]);
  for n = 1:sz(4)
    U_sr(:,:,:,n) = sr_3d(U(:,:,:,n), A, fac, phi, alpha, lambda, tol, max_iter);
  end
end

function U_sr = sr_5d(U, A, fac, phi, alpha, lambda, tol, max_iter)
  sz = size(U);
  %U_sr = zeros([sz(1)*fac sz(2)*fac sz(3)*fac sz(4) sz(5)]);
  for n = 1:sz(5)
    U_sr(:,:,:,:,n) = sr_4d(U(:,:,:,:,n), A, fac, phi, alpha, lambda, tol, max_iter);
  end
end
