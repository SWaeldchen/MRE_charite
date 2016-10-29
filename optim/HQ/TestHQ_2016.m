
clear;
n=150;s=[1:n]';
xo=zeros(n,1);
xo(20:40)=10*ones(21,1);  
xo=xo+0.5*sin(0.1*[1:n]');
%plot(xo)
A=eye(n,n)+diag(ones(n-1,1),1);
A(n,:)=[];
y=A*xo+0.1*randn(n-1,1);
x0=zeros(n,1);

tol=1e-15;
a=0.01;
b=10;
%%
phi='log';
disp(['phi=',phi,' tol=',num2str(tol),' a=',num2str(a),' b=',num2str(b)])
MxIt=2000;
tic
[xm,it,dJ]=min_L22_smooth_regu_1D_HQ_Multiplicative(x0,y,A,phi,a,b,tol,MxIt);
t=toc;
disp(['Multiplicative: ',num2str(it),' iterations, CPU=',num2str(t),' sec.  precision dJ=',num2str(dJ)]);

% Additive form needs more iterations.
MxIt=50000;
% For c > 1/a more iterations are needed.
tic
[xa,it,dJ]=min_L22_smooth_regu_1D_HQ_Additive(x0,y,A,phi,a,b,tol,MxIt); t=toc;
disp(['Additive:       ',num2str(it),' iterations, CPU=',num2str(t),' sec.  precision dJ=',num2str(dJ)]);
tic
[xaf,it,dJ]=min_L22_smooth_regu_1D_HQ_AdditiveF(x0,y,A,phi,a,b,tol,MxIt); t=toc;
disp(['Additive fast:  ',num2str(it),' iterations, CPU=',num2str(t),' sec.  precision dJ=',num2str(dJ)]);

rer=100*norm(xm-xa)/min( norm(xm), norm(xa));
disp(['          relative error btw Add and Mult ',num2str(rer),' %'])
disp(' ')
%%
phi='hub';
disp(['phi=',phi,' tol=',num2str(tol),' a=',num2str(a),' b=',num2str(b)])
MxIt=2000;
tic
[xm,it,dJ]=min_L22_smooth_regu_1D_HQ_Multiplicative(x0,y,A,phi,a,b,tol,MxIt);t=toc;
disp(['Multiplicative: ',num2str(it),' iterations, CPU=',num2str(t),' sec.  precision dJ=',num2str(dJ)]);

MxIt=50000;
tic
[xa,it,dJ]=min_L22_smooth_regu_1D_HQ_Additive(x0,y,A,phi,a,b,tol,MxIt); t=toc;
disp(['Additive:       ',num2str(it),' iterations, CPU=',num2str(t),' sec.  precision dJ=',num2str(dJ)]);
tic
[xaf,it,dJ]=min_L22_smooth_regu_1D_HQ_Additive_fast(x0,y,A,phi,a,b,tol,MxIt);t=toc;
disp(['Additive fast:  ',num2str(it),' iterations, CPU=',num2str(t),' sec.  precision dJ=',num2str(dJ)]);

rer=100*norm(xm-xa)/min( norm(xm), norm(xa));
disp(['          relative error btw Add and Mult ',num2str(rer),' %'])
disp(' ')
%%
phi='sqr';
disp(['phi=',phi,' tol=',num2str(tol),' a=',num2str(a),' b=',num2str(b)])
MxIt=2000;
tic
[xm,it,dJ]=min_L22_smooth_regu_1D_HQ_Multiplicative(x0,y,A,phi,a,b,tol,MxIt);t=toc;
disp(['Multiplicative: ',num2str(it),' iterations, CPU=',num2str(t),' sec.  precision dJ=',num2str(dJ)]);

MxIt=50000;
% For c>1/sqrt(a)  more iterations are needed.
tic
[xa,it,dJ]=min_L22_smooth_regu_1D_HQ_Additive(x0,y,A,phi,a,b,tol,MxIt);t=toc;
disp(['Additive:       ',num2str(it),' iterations, CPU=',num2str(t),' sec.  precision dJ=',num2str(dJ)]);
tic
[xaf,it,dJ]=min_L22_smooth_regu_1D_HQ_Additive_fast(x0,y,A,phi,a,b,tol,MxIt); t=toc;
disp(['Additive fast:  ',num2str(it),' iterations, CPU=',num2str(t),' sec.  precision dJ=',num2str(dJ)]);

rer=100*norm(xm-xa)/min( norm(xm), norm(xa));
disp(['          relative error btw Add and Mult ',num2str(rer),' %'])

