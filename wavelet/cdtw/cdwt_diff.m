function [vdx, vdy, vdz] = cdwt_diff(v,J)

% if 2d, needless to say Z is rubbish

[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;

w = cplxdual2D(v, J, Faf, af);
w_x = w;
w_y = w;
w_z = w;
x_grad = [1 -1];
y_grad = [1; -1];
z_grad = zeros(1,1,2);
z_grad(:) = [1, -1];
for i = 1:2
	for j = 1:2
		w_x{J+1}{i}{j} = convn(w_x{J+1}{i}{j}, x_grad, 'same');
		w_y{J+1}{i}{j} = convn(w_y{J+1}{i}{j}, y_grad, 'same');
		w_z{J+1}{i}{j} = convn(w_z{J+1}{i}{j}, z_grad, 'same');
	end
end

vdx = icplxdual2D(w_x, J, Fsf, sf);
vdy = icplxdual2D(w_y, J, Fsf, sf);
vdz = icplxdual2D(w_z, J, Fsf, sf);
