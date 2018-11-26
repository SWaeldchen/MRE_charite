function [ goodMu ] = good_mu( mu, thresh )
%GOOD_MU Summary of this function goes here
%   Detailed explanation goes here


goodMu = wlet_denoise(mu, 'db10', fix(log2(length(mu))), 0, thresh, 0);


end

