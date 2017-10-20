function [vdx, vdy] = cdwt_diff_2D(v,J)

% if 2d, needless to say Z is rubbish

[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;

sz = size(v);

padmax = max(nextpwr2(sz(1)), nextpwr2(sz(2)));

v_pad = simplepad(v, [padmax padmax]);

w = cplxdual2D(v_pad, J, Faf, af);
w_x = w;
w_y = w;
x_grad = [1 -1] / 2;
y_grad = [1; -1] / 2;

for i = 1:2
	for j = 1:2
		w_x{J+1}{i}{j} = convn(w_x{J+1}{i}{j}, x_grad, 'same');
		w_y{J+1}{i}{j} = convn(w_y{J+1}{i}{j}, y_grad, 'same');
	end
end

vdx = icplxdual2D(w_x, J, Fsf, sf);
vdy = icplxdual2D(w_y, J, Fsf, sf);

vdx = simplecrop(vdx, sz);
vdy = simplecrop(vdy, sz);

