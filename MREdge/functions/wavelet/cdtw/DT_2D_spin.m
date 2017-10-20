function y = DT_2D_spin(x, spins, T, J)
if nargin < 4
    J = 3;
    if nargin < 3
        T = 0.08;
    end
end
y = zeros(size(x));
for i = 0:spins-1
    for j = 0:spins-1
        x_shift = circshift(x, [i j]);
        x_shift_denoise = DT_2D(x_shift, T, J);
        x_shift_inv = circshift(x_shift_denoise, [-i -j]);
        y = y + x_shift_inv;
    end
end

y = y / spins^2;
        