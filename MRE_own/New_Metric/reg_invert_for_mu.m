function [ muReg ] = reg_invert_for_mu( mu, lambda )
%REG_INVERT_FOR_MU Summary of this function goes here
%   Detailed explanation goes here

n = length(mu);

Op = [ eye(n); lambda*gradMat(n)'*gradMat(n) ];

vec = [mu; zeros(n,1)];

muReg = Op\vec;

muReg = wlet_denoise(mu, 5, 'db1', 0.95, 0, 2);


end

