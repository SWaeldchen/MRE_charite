function [ mu ] = alt_invert_for_mu_2( u1, u2, sigma1, sigma2, M1, M2, muReg, lambda )
%NORM_INVERT_FOR_MU Summary of this function goes here
%   Detailed explanation goes here

n = length(u1);

D_u1 = [zeros(1,n-1); uOp_for_mu(u1); zeros(1,n-1)]; %[zeros(1, length(u1)-1); uOp_for_mu(u1); zeros(1, length(u1)-1)];
D_u2 = [zeros(1,n-1); uOp_for_mu(u2); zeros(1,n-1)]; %[zeros(1, length(u2)-1); uOp_for_mu(u2); zeros(1, length(u2)-1)];

gf = 10;

%%%%%%%%%%%%%%%%%

tstart = tic;

D_u = [D_u1;D_u2; gradMat(n-1)];
MM1 = M1*M1';
MM2 = M2*M2';

MM1 = MM1/trace(MM1);
MM2 = MM2/trace(MM2);

OpGes = mat_diag({MM1, MM2, eye(n-2)/gf^2}) + D_u*D_u'/lambda^2;

condest(MM1)

ccc1 = condest(mat_diag({MM1, MM2, eye(n-2)/gf^2}))
ccc2 = condest(diag(diag(OpGes))\OpGes)
spfrob(MM1 + MM2)
spfrob(D_u*D_u'/lambda^2)

vect = -sigma1*D_u1'*(MM1\u1) + -sigma2*D_u2'*(MM2\u2) + lambda^2*muReg(1:end-1) + (gf*lambda)^2*gradMat(n-1)'*gradMat(n-1)*muReg(1:end-1);

vect= vect;

tic

sum(sum(OpGes~=0))/sum(sum(OpGes==0))

mu3 = (vect - D_u'*(OpGes\(D_u*vect))/lambda^2)/lambda^2;

toc

% tic
% mu4 = (vect - D_u'*(lsqr(OpGes,D_u*vect,1e-6, 10000 ))/lambda^2)/lambda^2;
% toc

A = OpGes\(D_u*vect);
B = lsqr(OpGes, D_u*vect,1e-3, 100 );
C = pcg(OpGes, D_u*vect, 1e-3, 100);


% 
% norm(vect)
% norm(full(D_u))
% norm((D_u*vect))
% norm(OpGes)
% [ norm(A), norm(B)]

norm(D_u'*A)

norm(vect - D_u'*A/lambda^2)

nnn = norm(A - B)
nnn2 = norm(A - C)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%t1 = toc(tstart);
% tstart = tic;
% 
% Op1 = M1\D_u1;
% Op2 = M2\D_u2;
% Reg = eye(length(u1)-1);
% Op = [Op1; Op2; lambda*Reg; gf*lambda*gradMat(n-1)];
% 
% vec = [-sigma1*(M1\u1); -sigma2*(M2\u2); lambda*muReg(1:end-1); gf*lambda*gradMat(n-1)*muReg(1:end-1)];
% 
% mu1 = Op\vec;
% 
% 
% norm(inv(Op'*Op) - woodbury(lambda^2*eye(n-1), mat_diag({MM1, MM2, eye(n-2)/(gf*lambda)^2}), D_u', D_u))
% 
% er = [norm(mu3 - mu1), norm(mu1 - (Op'*Op)\(Op'*vec))]
% 
% t2 = toc(tstart);
% 
% time = [t1, t2]
% 



mu = [mu3; 1];

end

