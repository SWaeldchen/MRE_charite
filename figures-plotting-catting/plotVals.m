freqs = 10:10:100;
resultingvals = zeros(numel(etas),1);
index = 1:1:numel(freqs);
for n = 1:numel(etas);
   spVals = makeSpringPotVals(alpha, mus(1), etas(1), freqs);
   figure(); hold on;
   plot(index, real(spVals), 'blue');
   plot(index, imag(spVals), 'red');
   hold off;
end
