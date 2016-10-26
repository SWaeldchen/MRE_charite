function [x,it,Co,J,dx]=HQMu1d(x0,y,A,phi,a,b,dJ,MxIt);
% COST-FUNCTION: J(x)=||Ax-y||^2+ b sum_i phi [x(i)-x(i-1)]
% phi=  'log' => phi(t)= 1+|t|/a-log(1+|t|/a)
%       'sqr' => phi(t)= sqrt (a+t^2)
%       'hub' => t^2/2 if |t|<a,  =a|t|-a^2/2 otherwise
% y-data vector,  y = A x + noise (if A=1 => A=IDENTITY)
% x0 initialization
% STOP at iteration K if  | J(x_K)-J(x_{K-1}) |<=dJ
% MxIt - max number of iterations (default MxIt=Inf)
% OUTPUT
% x - minimizer of J
% it - total number of iterations
% Co_k - conditioning of the matrix to invert at iteration k
% J_k =J(x_k) (OPTIONAL)
% dx_k =||x_k-x_{k-1}||_Inf (OPTIONAL)
% Min. by Half-Quad Regu --- MULTIPLICATIVE Form:
% x=MinMu1d(x0,y,A,phi,a,b);                %%% OR
% [x,it,Co,J,dx]=HQMu1d(x0,y,A,phi,a,b,dJ,MxIt);
if nargin <7    dJ=1e-5*norm(y)/length(y);  end
if nargin <8    MxIt=Inf;           end
if nargout >3   JJ=[];              end
if nargout >4   dx=[];              end
n=length(x0);   x0=x0(:);           y=y(:);  
if A==1 A2=eye(n,n);
else    A2=A'*A;
end
G=eye(n,n)-diag(ones(n-1,1),1);     G(n,:)=[];
z=A'*y;         y2=y'*y;            clear A y
eJ=10*dJ;       x=x0;J=Inf;         it=0;
while eJ>dJ & it<MxIt
    it=it+1;
    x1=x;J1=J;
    t=G*x;
    if phi=='log'
        s=(2*a*(a+abs(t))).^(-1);
    elseif phi=='sqr'
        s=(2*sqrt(a+t.^2)).^(-1);
    elseif phi=='hub'
        s=0.5*ones(n-1,1);
        i=find(t>a);
        if isempty(i)==0    s(i)=0.5*a./t(i);   end
        i=find(t<-a);
        if isempty(i)==0    s(i)=-0.5*a./t(i);  end
    end
    H1=diag(s)*G;
    H1=G'*H1;
    H1=A2+b*H1;
    Co(it)=cond(H1);
    H1=inv(H1);  %%%    USE CG INSTEAD 
    x=H1*z;
    J=A2*x-2*z;
    J=x'*J+y2;
    t=G*x;
    if  phi=='log'
        t=1+abs(t)/a;
        J=J+b*sum(t-log(t));
    elseif phi=='sqr'
        J=J+b*sum(sqrt(a+t.^2));
    elseif phi=='hub'
        i=find(abs(t)<=a);      j=find(abs(t)>a);
        f=0.5*sum((t(i)).^2)+a*sum(abs(t(j)))-0.5*a^2*length(j);
        J=J+b*f;
    end
    eJ=abs(J-J1);
    if nargout>4    dx=[dx;max(abs(x1-x))];  end
    if nargout>3    JJ=[JJ;J];               end
end
if nargout>4    J=JJ;      end


