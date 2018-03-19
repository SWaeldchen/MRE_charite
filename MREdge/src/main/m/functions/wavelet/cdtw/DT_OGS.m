function y = DT_OGS(x, K, lambda, J)

% Dualtree complex denoising 
% with overlapping group sparsity thresholding

[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;
if nargin < 4
	J = 3;
end
w = cplxdual3D(x,J,Faf,af);
% loop thru scales
for j = 1:J
    % loop thru subbands
    for s1 = 1:2
        for s2 = 1:2
            for s3 = 1:7
                a = w{j}{1}{s1}{s2}{s3};
                b = w{j}{2}{s1}{s2}{s3};
                C = a + 1i*b;
                %c = javaMethod('threshold', OGSJava, real(C), imag(C));
                %C = c(:,:,:,1) + 1i*c(:,:,:,2);
                C = ogs3(C, K, lambda, 'atan', 1, 5);
                w{j}{1}{s1}{s2}{s3} = real(C);
                w{j}{2}{s1}{s2}{s3} = imag(C);
            end
        end
    end
end

y = icplxdual3D(w,J,Fsf,sf);

