function [U_den] = denoise_z(U)
[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;
J = 1;
sz = size(U);
if (numel(sz) < 4)
    d4 = 1;
else
    d4 = sz(4);
end
MAD = z_MAD(U);
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
for i=1:sz(1)
    for j =1:sz(2)
        for m = 1:d4
            z_line = U(i,j,:,m);
            w = dualtree(z_line, J, Faf, af);
            a = w{1}{1};
            b = w{1}{2};
            C = a + 1i*b;
            % soft thresh
            T = 3*MAD(m);
            c = max(abs(C) - T, 0);
            c = c./(c+T) .* C;
            %
            w{1}{1} = real(c);
            w{1}{2} = imag(c);
            z_line_den = idualtree(w, J, Fsf, sf);
            U_den(i,j,:,m) = z_line_den;
        end
    end
end
firsts = find(order_vector==1);
index1 = firsts(1);
index2 = index1 + sz(3) - 1;
U_den = U_den(:,:,index1:index2,:,:);


