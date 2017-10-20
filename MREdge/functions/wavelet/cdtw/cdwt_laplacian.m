function [x_lap] = cdwt_laplacian(x, J);
    
[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;

sz = size(v);
padmax = max(nextpwr2(sz(1)), max(nextpwr2(sz(2)), nextpwr2(sz(3))));

padmax_vec = [padmax padmax padmax];
v_pad = simplepad(v, padmax_vec);


w = cplxdual3D(v_pad, J, Faf, af);
w_x = w;
w_y = w;
w_z = w;
lap = get3dLaplacian();
for i = 1:2
	for j = 1:2
		for k = 1:2
			w_x{J+1}{i}{j}{k} = convn(w_x{J+1}{i}{j}{k}, lap, 'same');
			w_y{J+1}{i}{j}{k} = convn(w_y{J+1}{i}{j}{k}, lap, 'same');
			w_z{J+1}{i}{j}{k} = convn(w_z{J+1}{i}{j}{k}, lap, 'same');
		end
	end
end

vdx = icplxdual3D(w_x, J, Fsf, sf);
vdy = icplxdual3D(w_y, J, Fsf, sf);
vdz = icplxdual3D(w_z, J, Fsf, sf);

vdx = simplecrop(vdx, sz);
vdy = simplecrop(vdy, sz);
vdz = simplecrop(vdz, sz);

end
