function [ mu ] = fast_invert_for_mu( u1, u2, sigma1, sigma2, M1, M2, lambda)
%CIRCLE_INVERT_FOR_MU Summary of this function goes here
%   Detailed explanation goes here

D_u1 =  uOp_for_mu_border(u1);
D_u2 = uOp_for_mu_border(u2); 

cond(full(D_u1))

eee = eigs(D_u1, length(u1))

min(abs(eee))

%k = 100;

%MM1 = moving_avg_mat(length(u1)-k +1, k, 0)*moving_avg_mat(length(u1), k, 0); %(M1'*M1);
%MM2 = moving_avg_mat(length(u1)-k +1, k, 0)*moving_avg_mat(length(u1), k, 0); %(M2'*M2);

size(D_u1)
size(M1)

Op = (lambda*gradMat(length(u1))'*gradMat(length(u1)) + D_u1'*inv(M1'*M1)*D_u1 + D_u2'*inv(M2'*M2)*D_u2);

% mmin = min(eigs(MM1))
% mmax = max(eigs(MM1))

% Op = [inv(M1)*D_u1; inv(M2)*D_u2; lambda*gradMat(length(u1))];
%Op = [M1*D_u1; M2*D_u2; lambda*gradMat(length(u1))'*gradMat(length(u1))];

%vec = - D_u1'*MM*(sigma1*u1 + sigma2*u2 + bound_diff(u1, [1,1]) + bound_diff(u2, [1,1]));

vec = -[sigma1*D_u1'*inv(M1'*M1)*u1 + sigma2*D_u2'*inv(M2'*M2)*u2];

%vec = -[sigma1*inv(M1)*u1; sigma2*inv(M2)*u2; zeros(length(u1)-1,1)];


mu = Op\vec;



end

