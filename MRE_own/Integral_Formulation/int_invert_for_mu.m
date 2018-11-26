function [ output_args ] = int_invert_for_mu( u1, u2, sigma1, sigma2, k, lambda)
%INT_INVERT_FOR_MU Summary of this function goes here
%   Detailed explanation goes here

N = length(u1);

u1Diff = diff(u1);
u2Diff = diff(u2);

u1Op = spdiags_own([-u1Diff(1:end-1),u1Diff(2:end)], [0,1], N-2, N-1);
u2Op = spdiags_own([-u2Diff(1:end-1),u2Diff(2:end)], [0,1], N-2, N-1);

I3 = moving_avg_mat(N-9,8,0)*moving_avg_mat(N-2,8,0);

combOp = [I3*u1Op; I3*u2Op];
uVec = -[sigma1*I3*u1(2:end-1); sigma2*I3*u2(2:end-1)];

size(combOp)
size(uVec)

mu = combOp\uVec;

mu = [mu;1];




end

