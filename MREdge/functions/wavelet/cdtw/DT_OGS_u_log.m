function [u_den] = DT_OGS_u_log(u, K, fac, J, mask, fileID, base1, base2)

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
    fprintf(fileID, '%s \n', ['Denoise layer ', num2str(j)]);
    lam_sum = 0;
    for s1 = 1:2
        for s2 = 1:2
            for s3 = 1:7
                a = w{j}{1}{s1}{s2}{s3};
                b = w{j}{2}{s1}{s2}{s3};
                C_ = a + 1i*b;
                mad = simplemad(abs(C_(mask)));
                base = 0;
                switch j
                    case 1
                        base = base1;
                    case 2
                        base = base2;
                end
                lambda = base + fac*mad;
                C = ogs3(C_, K, lambda, 'atan', 1, 10);
                %if numel(isnan(C)) > 0 
                %    disp([num2str(numel(isnan(C))), ' nans in the denoise']);
                %end
                lam_sum = lam_sum + lambda;
                %figure(1);
                %subplot(1, 2, 1); imshow(abs(C_(:,:,10)), []);
                %subplot(1, 2, 2); imshow(abs(C(:,:,10)), []);
                %pause(0.1);
                C(isnan(C)) = 0;
                w{j}{1}{s1}{s2}{s3} = real(C);
                w{j}{2}{s1}{s2}{s3} = imag(C);
            end
        end
    end
    fprintf(fileID, '%s \n', ['mean lambda: ', num2str(lam_sum/28)]);
end

u_den = icplxdual3D_u(w,J,Fsf,sf);

