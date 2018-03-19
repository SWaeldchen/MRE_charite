function absg = quick_invert(x, freq, grid)
if nargin < 2
  grid = 1;
 end
RHO = 1000;
absg = RHO * (2*pi*freq).^2 * abs(x) ./ abs(lap(x) ./ grid^2);
