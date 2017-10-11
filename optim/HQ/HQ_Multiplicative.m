% COST-FUNCTION: J(x) = ||Ax-y||^2+ b sum_i phi [x(i)-x(i-1)]
% phi=  'log' => phi(t)= 1+|t|/a-log(1+|t|/a)
%       'sqr' => phi(t)= sqrt (a+t^2)
%       'hub' => t^2/2 if |t|<a,  =a|t|-a^2/2 otherwise
% y-data vector,  y = A x + noise (if A=1 => A=IDENTITY)
% x0 initialization
% STOP at iteration K if K < MxIt or dJ < tol  
% default: tol = 1e-15 and MxIt = Inf;
% OUTPUT
% x - minimizer of J
% it - total number of iterations
% dJ = || gard J(x_K)|| / ( || A'y|| * length(x0) )) 
%
% Minimization by Half-Quadratic Regularization --- MULTIPLICATIVE FORM
% REFERENCE : M. Nikolova and M. Ng,
% "Analysis of Half-Quadratic Minimization Methods for Signal and Image
% Recovery", SIAM Journal on Scientific computing, 27(3), 2005, pp. 937-966
%
% Original code : Nikolova 2003
% Revised code : Nikolova 29 oct 2016, nikolova@ens-cachan.fr
% [x,it,dJ]=min_L22_smooth_regu_1D_HQ_Multiplicative(x0,y,A,phi,a,b,dJ,MxIt);
function [x,it,dJ] = HQ_Multiplicative(x0,y,A,phi,a,b,tol,MxIt)
  sz = size(x0);
  
        %b = mean(abs(y(:)))*b; % impact of the reg, like lambda
        %a = mean(abs(y(:)))*a; % height of Huber function
  
  if nargin < 8 || isempty(MxIt)
    %MxIt = Inf;
    MxIt = 1000;
    if nargin < 7 || isempty(tol)
      tol = 1e-15;
    end
  end
      
  n=prod(sz);   
  x0=x0(:);           
  y=y(:);
  if A==1
    A2=2*eye(n,n);
  else    
    A2=2*(A'*A);  
  end
  %G=eye(n,n)-diag(ones(n-1,1),1);     G(n,:)=[];
  G = sparse_deriv(sz, 1);
  z=2*A'* y ; 
  nz=norm(z);       
  %clear A y
  x=x0;                
  it=0;
  dJ = tol^(-10);

  while dJ>tol && it<MxIt
      tic
      it=it+1
      t=G*x;
      if strcmp(phi,'log')
          s=(a+abs(t)).^(-1);
      elseif strcmp(phi,'sqr')
          s=(sqrt(a+t.^2)).^(-1);
       elseif strcmp(phi,'hub')
           %s=ones(n-1,1);
           s = ones(n, 1);
           idx=find(abs(t)>a);
           if numel(idx) > 0
               s(idx)=a*sign(t(idx))./t(idx);   
           end
      end
      
      dJ = A2*x- z + b* G'*(s.*t); % grad J (x^{k-1} )
      dJ = norm(dJ)/ (n *nz);
      H=spdiags(s, 0, n, n)*G; % H = diag(s)*G
      H=G'*H;
      H=A2+b*H;
      %x = lsqr(H, z, 1e-15, 10000); 
      x=H\z;
      toc
  end
  
  disp(['HQ Resid: ',num2str(dJ), ' Iter: ',num2str(it)]);
  x = reshape(x, sz);
  
 end
  


