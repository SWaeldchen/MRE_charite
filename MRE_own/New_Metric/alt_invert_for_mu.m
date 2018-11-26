function [ mu ] = alt_invert_for_mu( u1, u2, sigma1, sigma2, M1, M2, muReg, lambda )
%NORM_INVERT_FOR_MU Summary of this function goes here
%   Detailed explanation goes here

n = length(u1);

D_u1 = [zeros(1,n-1); uOp_for_mu(u1); zeros(1,n-1)]; %[zeros(1, length(u1)-1); uOp_for_mu(u1); zeros(1, length(u1)-1)];
D_u2 = [zeros(1,n-1); uOp_for_mu(u2); zeros(1,n-1)]; %[zeros(1, length(u2)-1); uOp_for_mu(u2); zeros(1, length(u2)-1)];

%%%%%%%%%%%%%%%%%

tstart = tic;

D_u = [D_u1;D_u2];
MM1 = M1*M1';
MM2 = M2*M2';

OpGes = mat_diag({MM1, MM2}) + D_u*D_u'/lambda^2;

vect = -sigma1*D_u1'*(MM1\u1) + -sigma2*D_u2'*(MM2\u2) + lambda^2*muReg(1:end-1);

mu3 = (vect - D_u'*(OpGes\(D_u*vect))/lambda^2)/lambda^2;

toc(tstart)


%%%%%%%%%%%%%%%%

tstart = tic;

Op1 = M1\D_u1;
Op2 = M2\D_u2;
Reg = eye(length(u1)-1);


%Op = (lambda*gradMat(length(u1)-1)'*gradMat(length(u1)-1) + D_u1'*MM*D_u1 + D_u2'*MM*D_u2);

%Op = [D_u1'*MM1*D_u1; D_u2'*MM2*D_u2; lambda*eye(length(u1)-1)];
Op = [Op1; Op2; lambda*Reg];

%vec = - D_u1'*MM*(sigma1*u1 + sigma2*u2 + bound_diff(u1, [1,1]) + bound_diff(u2, [1,1]));

%vec = -[sigma1*D_u1'*MM1*u1(2:end-1); sigma2*D_u2'*MM2*u2(2:end-1); -lambda*muReg];
vec = [-sigma1*(M1\u1); -sigma2*(M2\u2); lambda*muReg(1:end-1)];

mu = Op\vec;


toc(tstart)

norm(mu3 - mu)


mu = [mu; 1];

end

