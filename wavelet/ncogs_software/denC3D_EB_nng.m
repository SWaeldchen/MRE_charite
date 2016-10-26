function y = denC3D_EB_nng(x, T)


[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;
J = 4;
w = cplxdual3D(x,J,Faf,af);
I = sqrt(-1);
% loop thru scales

for j = 1:J
    % loop thru subbands
    for s1 = 1:2
        for s2 = 1:2
            for s3 = 1:7
                a = w{j}{1}{s1}{s2}{s3};
                b = w{j}{2}{s1}{s2}{s3};
                C = a + I*b;
                C = nng(C,T);
                w{j}{1}{s1}{s2}{s3} = real(C);
                w{j}{2}{s1}{s2}{s3} = imag(C);
            end
        end
    end
end

y = icplxdual3D(w,J,Fsf,sf);
szx = size(x);
depth = szx(3);
if depth > 5
    depth = 5;
end
