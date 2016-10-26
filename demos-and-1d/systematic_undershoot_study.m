function [table] = systematic_undershoot_study

spike_widths = 7:2:31;
nwidths = numel(spike_widths);
spike_coeffs = -5:-5:-50;
ncoeffs = numel(spike_coeffs);

table = zeros(nwidths, ncoeffs);

for i = 1:nwidths
  for j = 1:ncoeffs
     table(i,j) = ieee_undershoot_demo(spike_widths(i), spike_coeffs(j));
    end
   end 