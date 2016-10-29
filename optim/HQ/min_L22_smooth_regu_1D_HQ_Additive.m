% COST-FUNCTION: J(x)=||Ax-y||^2+ b sum_i phi [x(i)-x(i-1)]
% phi=  'log' => phi(t)= 1+|t|/a-log(1+|t|/a)
%       'sqr' => phi(t)= sqrt (a+t^2)
%       'hub' => t^2/2 if |t|<a,  =a|t|-a^2/2 otherwise
% y-data vector,  y = A x + noise (if A=1 => A=IDENTITY)
% x0 initialization
% STOP at iteration K if K < MxIt or dJ < tol 
% default: tol = 1e-15 and MxIt = Inf;
% Jaugmented(x,s) = ||Ax-y||^2+ 0.5*b ||sqrt(c)Gx - s/sqrt(c)||^2 +
%               b sum_i psi ( s(i) )
% c = phi''(0) is the theoretical optimal choice 
% Convergence holds if c > phi''(0)
% OUTPUT
% x - minimizer of J
% it - total number of iterations
% dJ = || gard J(x_K)|| / ( || A'y|| * length(x0) )) 
% 
% Minimization by Half-Quad Regu --- ADDITIVE form 
% REFERENCE : M. Nikolova and M. Ng,
% "Analysis of Half-Quadratic Minimization Methods for Signal and Image
% Recovery", SIAM Journal on Scientific computing, 27(3), 2005, pp. 937-966
%
% Original code : Nikolova 2003
% Revised code : Nikolova 29 oct 2016, nikolova@ens-cachan.fr
% [x,it,dJ]=min_L22_smooth_regu_1D_HQ_Additive(x0,y,A,phi,a,b,tol,MxIt,c);
function [x,it,dJ]=min_L22_smooth_regu_1D_HQ_Additive(x0,y,A,phi,a,b,tol,MxIt,c);
if nargin == 6 ;   MxIt = Inf; tol=1e-15; 
elseif nargin ==7 ;   MxIt=Inf;  end
if nargin < 9
    if strcmp(phi,'log');       c=1/a;
    elseif strcmp(phi,'sqr');   c=1/sqrt(a);
    elseif strcmp(phi,'hub');   c=1;
    end;    
end
n=length(x0);   x0=x0(:);           y=y(:);  
if A==1; A2=2*eye(n,n);  else    A2=2*(A'*A);  end
G=eye(n,n)-diag(ones(n-1,1),1);     G(n,:)=[];
z=2*A'* y ;   nz=norm(z);       clear A y
H=A2+b*c*(G'*G); % H=inv(H);
x=x0;       it=0;
dJ = tol^(-10);

while dJ>tol && it<MxIt
    it=it+1;
    t=G*x; 
    % Compute phi'
    if strcmp(phi,'log')
        s=t./(a+abs(t)); 
    elseif strcmp(phi,'sqr')
        s=t./sqrt(a+t.^2);
    elseif strcmp(phi,'hub')
         s=t;
         idx=find(abs(t)>a);
         if isempty(idx)==0;   s(idx)=a*sign(t(idx));   end
    end
    dJ = A2*x- z + b* G'*(s); % grad J (x^{k-1} )
    dJ = norm(dJ)/ (n *nz) ; 
    
    s = c*t - s;
    w=z+b*G'*s;
    x = H\w;
end


