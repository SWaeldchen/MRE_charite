function [vdx, vdy, vdz] = cdwt_diff_3D(v,J)

[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;

sz = size(v);
padmax = max(nextpwr2(sz(1)), max(nextpwr2(sz(2)), nextpwr2(sz(3))));

padmax_vec = [padmax padmax padmax];
v_pad = simplepad(v, padmax_vec);
shiftfac = 2.^J;
v_pad_shift = circshift(v_pad, [0 0 shiftfac]); 

w = cplxdual3D(v_pad_shift, J, Faf, af);

meth = 2;
T = 0.001;
w = subband_thresh_cdtw_3D(w, T, J, meth);

assignin('base', 'sample_hipass', w{1}{1}{1}{1}{1});

v_diff_shift = icplxdual3D(w, J, Fsf, sf);

v_diff = circshift(v_diff_shift, [0 0 -shiftfac]);

assignin('base','diff_image', v_pad-v_diff);

w_x = w;
w_y = w;
w_z = w;
x_grad = [1 -1] / (2^J);
y_grad = [1; -1] / (2^J);
z_grad = zeros(1,1,2);
z_grad(:) = [1, -1] / (2^J);
for i = 1:2
	for j = 1:2
		for k = 1:2
			w_x{J+1}{i}{j}{k} = convn(w_x{J+1}{i}{j}{k}, x_grad, 'same');
			w_y{J+1}{i}{j}{k} = convn(w_y{J+1}{i}{j}{k}, y_grad, 'same');
			w_z{J+1}{i}{j}{k} = convn(w_z{J+1}{i}{j}{k}, z_grad, 'same');
		end
	end
end

vdx = icplxdual3D(w_x, J, Fsf, sf);
vdy = icplxdual3D(w_y, J, Fsf, sf);
vdz = icplxdual3D(w_z, J, Fsf, sf);

vdx = simplecrop(circshift(vdx, [0 0 -shiftfac]), sz);
vdy = simplecrop(circshift(vdy, [0 0 -shiftfac]), sz);
vdz = simplecrop(circshift(vdz, [0 0 -shiftfac]), sz);

end
