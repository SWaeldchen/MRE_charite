function [ x ] = gen_sparse_mu(N, s, wName)
%GEN_SPARSE_MU Summary of this function goes here
%   Detailed explanation goes here


x = zeros(N,1);

[wx, L] = wavedec(x, fix(log2(N)), wName);

wx(randperm(fix(sqrt(N)),min(s,fix(sqrt(N))))) = 5;

x = waverec(wx, L, wName);

x = x - min(x) + 1;

end

