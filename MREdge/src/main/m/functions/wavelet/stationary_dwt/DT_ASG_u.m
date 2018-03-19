function [u_den] = DT_ASG_u(u, J, mask, amp)

% Dualtree complex denoising 
% with overlapping group sparsity thresholding

[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;
w = cplxdual3D_u(u,J,Faf,af);
sz_orig = size(u); % to deal with growing coefficients
% loop thru scales
for j = 1:J
    % loop thru subbands
    for s1 = 1:2
        for s2 = 1:2
            for s3 = 1:7
                a = w{j}{1}{s1}{s2}{s3};
                b = w{j}{2}{s1}{s2}{s3};
                C = a + 1i*b;
                sz_diff = size(C) - sz_orig;
                mask_pad = zeros(size(C));
                amp_pad = zeros(size(C));
                margins = round(sz_diff/2);
                mask_pad(margins(1):margins(1)+size(mask,1)-1, margins(2):margins(2)+size(mask,2)-1,...
                    margins(3):margins(3)+size(mask,3)-1) = mask;
                amp_pad(margins(1):margins(1)+size(amp,1)-1, margins(2):margins(2)+size(amp,2)-1,...
                    margins(3):margins(3)+size(amp,3)-1) = amp;
                
                %lam = bayesshrink_eb(abs(C), mask_pad);
                C_scale = abs(C) ./ amp_pad;
                lam = sigma_mad_wavelet(C_scale, mask_pad);
                C = nng(C_scale, lam).*amp_pad;
                C(isnan(C)) = 0;
                w{j}{1}{s1}{s2}{s3} = real(C);
                w{j}{2}{s1}{s2}{s3} = imag(C);
            end
        end
    end
end
u_den = icplxdual3D_u(w,J,Fsf,sf);

