function [x,it,Co,J,dx]=HQAd1d(x0,y,A,phi,a,b,c,dJ,MxIt)
% COST-FUNCTION: J(x)=||Ax-y||^2+ b sum_i phi [x(i)-x(i-1)]
% phi=  'log' => phi(t)= 1+|t|/a-log(1+|t|/a)
%       'sqr' => phi(t)= sqrt (a+t^2)
%       'hub' => t^2/2 if |t|<a,  =a|t|-a^2/2 otherwise
% y-data vector,  y = A x + noise (if A=1 => A=IDENTITY)
% x0 initialization
% c : ct^2/2-phi(t) convex. IF c=0, AUTOMATICAL CHOICE:  
%    'log'=>c=1/(a^2); 'sqr'=>c=1/sqrt(a); 'hub'=>c=1.
% STOP at iteration K if  | J(x_K)-J(x_{K-1}) |<=dJ
% MxIt - max number of iterations (default MxIt=Inf)
% OUTPUT
% x - minimizer of J
% it - total number of iterations
% Co - conditioning of the matrix to invert
% J_k =J(x_k) (OPTIONAL)
% dx_k =||x_k-x_{k-1}||_Inf (OPTIONAL)
% Min. by Half-Quad Regu --- ADDITIVE Form:
% x=MinAd1d(x0,y,A,phi,a,b);        %%% OR
% [x,it,Co,J,dx]=HQAd1d(x0,y,A,phi,a,b,c,dJ,MxIt);
if nargin <7    
    c=0;                
end
if nargin <8    
    dJ=1e-5*norm(y)/length(y);  
end
if nargin <9    
    MxIt=Inf;           
end
if nargout >3   
    JJ=[];              
end
if nargout >4   
    dx=[];              
end
if c==0 
    if strcmp(phi,'log')
        c=1/(a^2);
    elseif strcmp(phi,'sqr')   
        c=1/sqrt(a);
    elseif strcmp(phi,'hub')
        c=1;
    end    
end
sz=size(x0);
n = prod(sz);   
x0=x0(:);           
y=y(:);  
if A==1 
    A2=eye(n,n);    
    z=2*y;
else
    A2=A'*A;        
    z=A'*y;     
    z=2*z;
end
% here is the 1D version - swap in a 2D nabla matrix
%G=eye(n,n)-diag(ones(n-1,1),1);     
%G(n,:)=[];
G = sparse_deriv(sz, 1);

% here is the 1D version - swap in a 2d Laplacian matrix
%G2=2*eye(n,n)-diag(ones(n-1,1),1);
%G2=G2-diag(ones(n-1,1),-1);         
%G2(1)=1;G2(n,n)=1;
G2 = sparse_deriv(sz, 2);

H=2*A2+b*c*G2;
Co=cond(H);
H1=inv(H);      
H1=sparse(H1);
y2=y'*y;        
clear H G2 y A
eJ=10*dJ;       
x=x0;
J=Inf;         
it=0;
while eJ>dJ && it<MxIt
    it=it+1;
    x1=x;J1=J;
    t=G*x;
    if strcmp(phi,'log')
        s=c*t-t./(a*(a+abs(t)));
    elseif strcmp(phi,'sqr')
        s=c*t-t./sqrt(a+t.^2);
    elseif strcmp(phi,'hub')
        s=zeros(n,1);
        if c==1
            i=find(t>a);
            if isempty(i)==0,s(i)=t(i)-a*ones(size(i));end
            i=find(t<-a);
            if isempty(i)==0,s(i)=t(i)+a*ones(size(i));end            
        else
            i=find(abs(t)<=a);
            if isempty(i)==0,s(i)=(c-1)*t(i);end
            i=find(t>a);
            if isempty(i)==0,s(i)=c*t(i)-a*ones(size(i));end
            i=find(t<-a);
            if isempty(i)==0,s(i)=c*t(i)+a*ones(size(i));end
        end
    end
    w=z+b*G'*s;
    x=H1*w;
    J=A2*x-z;
    J=x'*J+y2;
    t=G*x;
    if  strcmp(phi,'log')
        t=1+abs(t)/a;
        J=J+b*sum(t-log(t));
    elseif strcmp(phi,'sqr')
        J=J+b*sum(sqrt(a+t.^2));
    elseif strcmp(phi,'hub')
        i=find(abs(t)<=a);      
        j=find(abs(t)>a);
        f=0.5*sum((t(i)).^2)+a*sum(abs(t(j)))-0.5*a^2*length(j);
        J=J+b*f;
    end
    eJ=abs(J-J1);
    if nargout>4    
        dx=[dx;max(abs(x1-x))];  
    end
    if nargout>3    
        JJ=[JJ;J];               
    end
end
if nargout>4    
    J=JJ;      
end


