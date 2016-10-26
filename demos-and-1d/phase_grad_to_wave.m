function [wave] = phase_grad_to_wave(grad, mag, start)

wave = zeros(size(grad));
N = size(grad, 1);

if nargin < 3
  start = 1;
  if nargin < 2
    mag = ones(size(grad));
  end
end

wave(1) = start; 
for n = 2:N;
      prev = wave(n-1);
      [t, ~] = cart2pol(real(prev), imag(prev));
      [a, b] = pol2cart(t+grad(n), mag(n));
      wave(n) = a + 1i*b;
end