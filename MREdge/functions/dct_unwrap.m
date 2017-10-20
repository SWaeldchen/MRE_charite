function w_u = dct_unwrap(w, d)

if d == 2
	w_u = dct_unwrap_2d(w);
elseif d == 3
	w_u = dct_unwrap_3d(w);
elseif d==4
	w_u = dct_unwrap_4d(w);
else
	disp('MCNIT error: dct_unwrap unwraps in 2, 3 or 4D');
	return;
end

end

function w_u = dct_unwrap_2d(w)
	sz = size(w);
	[x, y] = meshgrid(1:sz(2), 1:sz(1));
    mask = x.^2 + y.^2;
	[w_resh, n_slcs] = resh(w, 3);
	w_u = zeros(size(w_resh));
	parfor n = 1:n_slcs
		w_u(:,:,n) = unwrap(w_resh(:,:,n), mask);
	end
	w_u = reshape(w_u, sz);
end

function w_u = dct_unwrap_3d(w)
	sz = size(w);
	[x, y, z] = meshgrid(1:sz(2), 1:sz(1), 1:sz(3));
    mask = x.^2 + y.^2 + z.^2;
	[w_resh, n_vols] = resh(w, 4);
	w_u = zeros(size(w_resh));
	parfor n = 1:n_vols
		w_u(:,:,:,n) = unwrap(w_resh(:,:,:,n), mask);
	end
	w_u = reshape(w_u, sz);
end

function w_u = dct_unwrap_4d(w)
	sz = size(w);
	[x, y, z, t] = meshgrid(1:sz(2), 1:sz(1), 1:sz(3), 1:sz(4));
    mask = x.^2 + y.^2 + z.^2 + t.^2;
	[w_resh, n_acqs] = resh(w, 5);
	w_u = zeros(size(w_resh));
	parfor n = 1:n_acqs
		w_u(:,:,:,:,n) = unwrap(w_resh(:,:,:,:,n), mask);
	end
	w_u = reshape(w_u, sz);
end

function w_u = unwrap(w, mask)

    cosx = cos(w);
    sinx = sin(w);
   
    term1 = sinx;
    term1 = dctn_octave(term1);
    term1 = term1 .* mask;
    term1 = idctn_octave(term1);
    term1 = term1 .* cosx;
    term1 = dctn_octave(term1);
    term1 = term1 ./ mask;
    term1 = idctn_octave(term1);
    
    term2 = cosx;
    term2 = dctn_octave(term2);
    term2 = term2 .* mask;
    term2 = idctn_octave(term2);
    term2 = term2 .* sinx;
    term2 = dctn_octave(term2);
    term2 = term2 ./ mask;
    term2 = idctn_octave(term2);
    
    w_u = term1 - term2;

end
