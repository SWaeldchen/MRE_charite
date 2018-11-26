function [ mu ] = alt_invert_for_mu_3( u1, u2, sigma1, sigma2, M1, M2, muReg, lambda )
%NORM_INVERT_FOR_MU Summary of this function goes here
%   Detailed explanation goes here

n = length(u1);
gf = 50;
D_u1 = [zeros(1,n-1); uOp_for_mu(u1); zeros(1,n-1)]; %[zeros(1, length(u1)-1); uOp_for_mu(u1); zeros(1, length(u1)-1)];
D_u2 = [zeros(1,n-1); uOp_for_mu(u2); zeros(1,n-1)]; %[zeros(1, length(u2)-1); uOp_for_mu(u2); zeros(1, length(u2)-1)];

MM1 = M1*M1';
MM2 = M2*M2';
M1 = M1/sqrt(trace(MM1));
M2 = M2/sqrt(trace(MM2));
MM1 = MM1/trace(MM1);
MM2 = MM2/trace(MM2);


%%%%%%%%%%%%%%

%% Iterative method, might not scale to higher dimension

L1 = chol(MM1);
L2 = chol(MM2);

%Op2 = @(v) lambda^2*v + D_u1'*(MM1\(D_u1*v)) + D_u2'*(MM2\(D_u2*v)) + (gf*lambda)^2*gradMat(n-1)'*gradMat(n-1)*v;
Op = @(v) lambda^2*v + D_u1'*(L1\(L1'\(D_u1*v))) + D_u2'*(L2\(L2'\(D_u2*v))) + (gf*lambda)^2*gradMat(n-1)'*gradMat(n-1)*v;

%OpMat = lambda^2*eye(n-1) + D_u1'*(MM1\D_u1) + D_u2'*(MM2\D_u2) + (gf*lambda)^2*gradMat(n-1)'*gradMat(n-1);

v = -sigma1*D_u1'*(MM1\u1) + -sigma2*D_u2'*(MM2\u2) + lambda^2*muReg(1:end-1) + (gf*lambda)^2*gradMat(n-1)'*gradMat(n-1)*muReg(1:end-1);

% mu_pre = OpMat\v;

tic
mu_pcg = pcg(Op, v, 1e-6, 1000, [], [], muReg(1:end-1));
toc

%%%%%%%%%%%%%%%%%

%% Woodbury Inversion, wird numerisch instabil


% D_u = [D_u1;D_u2; gradMat(n-1)];
% 
% OpGes = mat_diag({MM1, MM2, eye(n-2)/gf^2}) + D_u*D_u'/lambda^2;
% 
% vect = -sigma1*D_u1'*(MM1\u1) + -sigma2*D_u2'*(MM2\u2) + lambda^2*muReg(1:end-1) + (gf*lambda)^2*gradMat(n-1)'*gradMat(n-1)*muReg(1:end-1);
% 
% mu_woodbury = (vect - D_u'*(OpGes\(D_u*vect))/lambda^2)/lambda^2;


%%%%%%%%%%%%%%%%

%% Direct method with non-sparse inverse, takes long

% Op1 = M1\D_u1;
% Op2 = M2\D_u2;
% Op = [Op1; Op2; lambda*eye(n-1); gf*lambda*gradMat(n-1)];
% 
% vec = [-sigma1*(M1\u1); -sigma2*(M2\u2); lambda*muReg(1:end-1); gf*lambda*gradMat(n-1)*muReg(1:end-1)];
% 
% mu_direct = Op\vec;


%%%%%%%%%%%%%

% nnn = norm(mu_pcg - mu_pre)

%nn2 = norm(OpMat - Op'*Op)


mu = [mu_pcg; 1];

end

