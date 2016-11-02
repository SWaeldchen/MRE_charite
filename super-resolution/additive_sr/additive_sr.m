function U_sr = additive_sr (U, fac)
  
  phi = 'hub';
  alpha = .01;
  lambda = 10;
  tol = 1e-8;
  max_iter = 100;
  
  
  sz = size(U);
  if numel(sz) == 5
    U_sr = sr_5d(U, fac, phi, alpha, lambda, tol, max_iter);
  elseif numel(sz) == 4
    U_sr = sr_4d(U, fac, phi, alpha, lambda, tol, max_iter);
  else
    U_sr = sr_3d(U, fac, phi, alpha, lambda, tol, max_iter);
  end
  
end

function U_sr = sr_3d(U, fac, phi, alpha, lambda, tol, max_iter)
   sz = size(U);
   U_sr = zeros(sz*fac);
   A = additive_sr_matrix(sz, fac);
  [U_sr]=HQ_Multiplicative(zeros(size(U)*fac),U,A,phi,alpha,lambda,tol,max_iter);
end

function U_sr = sr_4d(U, fac, phi, alpha, lambda, tol, max_iter)
  sz = size(U);
  U_sr = zeros(sz*fac);
  for n = 1:sz(4)
    U_sr(:,:,:,n) = sr_3d(U(:,:,:,n), fac, phi, alpha, lambda, tol, max_iter);
  end
end

function U_sr = sr_5d(U, fac, phi, alpha, lambda, tol, max_iter)
  sz = size(U);
  U_sr = zeros(sz*fac);
  for n = 1:sz(5)
    U_sr(:,:,:,:,n) = sr_4d(U(:,:,:,:,n), fac, phi, alpha, lambda, tol, max_iter);
  end
end
