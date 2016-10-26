function y = DT_NNG(x, T)

% Dualtree complex denoising 
% with non-negative garotte thresholding
[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;
J = 4;
T = 0.4;
w = cplxdual3D(x,J,Faf,af);
for j = 1:J
    % loop thru subbands
    for s1 = 1:2
        for s2 = 1:2
            for s3 = 1:7
                a = w{j}{1}{s1}{s2}{s3};
                b = w{j}{2}{s1}{s2}{s3};
                C = a + 1i*b;
                C = ( C - T^2 ./ C ) .* (abs(C) > T);  
                w{j}{1}{s1}{s2}{s3} = real(C);
                w{j}{2}{s1}{s2}{s3} = imag(C);
            end
        end
    end
end
y = icplxdual3D(w,J,Fsf,sf);

