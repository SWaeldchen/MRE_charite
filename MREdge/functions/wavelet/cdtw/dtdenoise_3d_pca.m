function U_den3 = dtdenoise_3d_pca(U, fac) 

    if nargin < 2
      fac = 0.7;
    end
    
	[Faf, Fsf] = FSfarras;
	[af, sf] = dualfilt1;
	if (nargin < 2)
		J = 1;
	end
	sz = size(U);
	if (numel(sz) < 4)
		d4 = 1;
	else
		d4 = sz(4);
	end
    padX = nextpwr2(sz(1));
    padY = nextpwr2(sz(2));
	padZ = nextpwr2(sz(3));
    padMax = max(max(padX, padY), padZ);
	U_den3 = zeros(size(U));
	Uex = zeros(sz(1), sz(2), padMax, d4);
	szUex = size(Uex);
	for m = 1:d4
		[temp, order_vector] = extendZ2(U(:,:,:,m), padMax);
		[Uex(:,:,:,m)] = temp(1:sz(1),1:sz(2),:);
	end
	firsts = find(order_vector==1);
	index1 = firsts(1);
	index2 = index1 + sz(3) - 1;
    for m = 1:d4
        U_r = process_cube(real(U(:,:,:,m)), padMax, fac);
        U_i = process_cube(imag(U(:,:,:,m)), padMax, fac);
        U_den3(:,:,:,m) = U_r + 1i*U_i;	
    end
end


function cube_den = process_cube(cube, padMax, fac)
        lambda = getLambda(cube)*fac;
        cube_pad = simplepad(cube, [padMax, padMax, padMax]);
        cube_pad_den = DT_OGS(cube_pad, [3 3 3], lambda);
        cube_den = simplecrop(cube_pad_den, size(cube));
end    


