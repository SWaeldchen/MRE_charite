function [vdx, vdy, vdz] = spline_wavelet_diff_3D(v,J)

[RF,DF] = biorwavf('bior2.2');
RF = [RF 0 0 0]';
DF = [DF 0]';

af = [RF DF];
sf = [RF DF];

[af, sf] = farras;

sz = size(v);
padmax = max(nextpwr2(sz(1)), max(nextpwr2(sz(2)), nextpwr2(sz(3))));

padmax_vec = [padmax padmax padmax];
v_pad = simplepad(v, padmax_vec);


w = dwt3D(v_pad, J, af);
w_x = w;
w_y = w;
w_z = w;
x_grad = [1 -1] / (2^J);
y_grad = [1; -1] / (2^J);
z_grad = zeros(1,1,2);
z_grad(:) = [1, -1] / (2^J);

			w_x{J+1} = convn(w_x{J+1}, x_grad, 'same');
			w_y{J+1} = convn(w_y{J+1}, y_grad, 'same');
			w_z{J+1} = convn(w_z{J+1}, z_grad, 'same');


vdx = idwt3D(w_x, J, sf);
vdy = idwt3D(w_y, J, sf);
vdz = idwt3D(w_z, J, sf);

vdx = simplecrop(vdx, sz);
vdy = simplecrop(vdy, sz);
vdz = simplecrop(vdz, sz);

end
