function [x y z] = swt_diff_3d(v, J);

[af sf] = farras;
derivs = cell(3,1);

sz = size(v);
padmax = max(nextpwr2(sz(1)), max(nextpwr2(sz(2)), nextpwr2(sz(3))));

padmax_vec = [padmax padmax padmax];
v_pad = simplepad(v, padmax_vec);
derivs = cell(3,1);

for n = 1:3
	[A H V D] = swt2(v_pad, J, af(:,1), af(:,2));
	
x_grad = [1 -1] / (2^J);
y_grad = [1; -1] / (2^J);
z_grad = zeros(1,1,2);
z_grad(:) = [1, -1] / (2^J);

A_x = convn(A, x_grad, 'same');
A_y = convn(A, y_grad, 'same');
A_z = convn(A, z_grad, 'same');

x = iswt2(A_x, H, V, D, sf(:,1), sf(:,2));
y = iswt2(A_y, H, V, D, sf(:,1), sf(:,2));
z = iswt2(A_z, H, V, D, sf(:,1), sf(:,2));
