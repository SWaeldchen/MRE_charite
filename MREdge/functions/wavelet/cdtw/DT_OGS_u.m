function [u_den] = DT_OGS_u(u, K, fac, J, mask)

% Dualtree complex denoising 
% with overlapping group sparsity thresholding

[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;
if nargin < 4
	J = 3;
end
w = cplxdual3D_u(u,J,Faf,af);
% loop thru scales
for j = 1:J
    % loop thru subbands
    disp(['Denoise layer ', num2str(j)]);
    for s1 = 1:2
        for s2 = 1:2
            for s3 = 1:7
                a = w{j}{1}{s1}{s2}{s3};
                b = w{j}{2}{s1}{s2}{s3};
                C_ = a + 1i*b;
                mad = simplemad(abs(C_(mask)));
                lambda = fac*mad;
                C = ogs3(C_, K, lambda, 'atan', 1, 10);
                %if numel(isnan(C)) > 0 
                %    disp([num2str(numel(isnan(C))), ' nans in the denoise']);
                %end
                C(isnan(C)) = 0;
                w{j}{1}{s1}{s2}{s3} = real(C);
                w{j}{2}{s1}{s2}{s3} = imag(C);
            end
        end
    end
end

u_den = icplxdual3D_u(w,J,Fsf,sf);

