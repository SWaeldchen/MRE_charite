function [y] = abs_norm_z_lap(x);

zlap = zeros(1, 1, 3);
zlap(:) = [1 -2 1];
y = abs(convn(x, zlap, 'same')) ./ abs(x);
