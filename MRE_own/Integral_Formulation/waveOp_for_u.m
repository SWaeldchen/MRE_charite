function [ op ] = waveOp_for_u(mu, sigma)
%WAVEOP_FOR_U Summary of this function goes here
%   Detailed explanation goes here

N = length(mu); % gridlength

diags = [ mu(1:end-2), -(mu(1:end-2)+mu(2:end-1)), mu(2:end-1)];

diffPart = spdiags_own(diags, [-1,0,1], N,N); %spdiags([ [0;mu(1:end-2);0], [0;mu(1:end-2)+mu(2:end-1);0], [0;mu(2:end-1);0]], [-1,0,1], N, N);

boundaryPlus = [1; sigma*ones(N-2,1); 1];

op = diffPart + spdiags(boundaryPlus,0,N,N);


end

