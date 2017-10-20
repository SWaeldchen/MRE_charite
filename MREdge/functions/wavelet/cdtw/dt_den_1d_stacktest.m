function [U_den] = dt_den_1d_stacktest(U)
tic
[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;
J = 1;
sz = size(U);
MAD = z_MAD(U);
U_den = zeros(ssz);
for i=1:sz(1)
    for j =1:sz(2)
        for m = 1:sz(4)
            for n = 1:sz(5)
                z_line = U(i,j,:,m,n);
                w = dualtree(z_line, J, Faf, af);
                a = w{1}{1};
                b = w{1}{2};
                C = a + 1i*b;
                % soft thresh
                T = 10*MAD(m, n);
                c = max(abs(C) - T, 0);
                c = c./(c+T) .* C;
                %
                w{1}{1} = real(c);
                w{1}{2} = imag(c);
                z_line_den = idualtree(w, J, Fsf, sf);
                U_den(i,j,:,m,n) = z_line_den;
            end
        end
    end
end
firsts = find(order_vector==1);
index1 = firsts(1);
index2 = index1 + sz(3) - 1;
U_den = U_den(:,:,index1:index2,:,:);
toc

