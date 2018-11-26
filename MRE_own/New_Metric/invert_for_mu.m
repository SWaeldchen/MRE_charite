function [ mu ] = invert_for_mu( u1, u2, sigma1, sigma2, lambda)
%WAVEOP_FOR_MU Summary of this function goes here
%   Detailed explanation goes here


N = length(u1);

u1Diff = diff(u1);
u2Diff = diff(u2);

u1Op = spdiags_own([-u1Diff(1:end-1),u1Diff(2:end)], [0,1], N-2, N-1);
u2Op = spdiags_own([-u2Diff(1:end-1),u2Diff(2:end)], [0,1], N-2, N-1);

combOp = [u1Op; u2Op];
combVec = -[sigma1*u1(2:end-1); sigma2*u2(2:end-1)];


length(combVec)

mu = combOp\combVec; %(combOp'*combOp + lambda*eye(N-1))\combOp'*(combVec + lambda*ones(2*N-4,1));

mu = [mu;1];

end

