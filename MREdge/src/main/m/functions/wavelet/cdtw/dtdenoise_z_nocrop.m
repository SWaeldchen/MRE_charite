function [U_den, order_vector] = dtdenoise_z_nocrop(U, fac, J)
[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;
if nargin < 3
	J = 1;
end
sz = size(U);
if nargin < 2
	fac = 1;
end
if (numel(sz) < 4)
    d4 = 1;
else
    d4 = sz(4);
end

pwr = 0;
while (2^pwr < sz(3)) 
    pwr = pwr+1;
end
xDim = 2^(pwr+1);
Uex = zeros(sz(1), sz(2), xDim, d4);
for m = 1:d4
    [temp, order_vector] = extendZ2(U(:,:,:,m), xDim);
    [Uex(:,:,:,m)] = temp(1:sz(1),1:sz(2),:);
end
U = Uex;
U_den = zeros(sz(1), sz(2), xDim, d4);
for m = 1:d4
    lambda = getLambda(U(:,:,:,m),0);
    T = lambda*fac;
    for i=1:sz(1)
        for j =1:sz(2)
            z_line = U(i,j,:,m);
            w = dualtree(z_line, J, Faf, af);
			for n = 1:J
            	a = w{n}{1};
            	b = w{n}{2};
            	C = a + 1i*b;
				c = max(abs(C) - T, 0);
                c = c./(c+T) .* C;
		        w{n}{1} = real(c);
		        w{n}{2} = imag(c);
			end
            z_line_den = idualtree(w, J, Fsf, sf);
            U_den(i,j,:,m) = z_line_den;
        end
    end
end


