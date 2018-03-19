function [u_lo, u_hi] = denoise_separate_volume(u, K, lambda, J)

% Dualtree complex denoising 
% with overlapping group sparsity thresholding

pad_1 = nextpwr2(size(u,1));
pad_2 = nextpwr2(size(u,2));
u_pad = simplepad(u, [pad1, pad2]);
shearletSystem = SLgetShearletSystem2D(useGPU, rows, cols, nScales, shearLevels, full, directionalFilter, quadratureMirrorFilter)
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
w_hi = w;
w_lo = w;
for s0 = 1:2
    for s1 = 1:2
        for s2 = 1:2
                w_hi{J+1}{s0}{s1}{s2} = butter_3d(ORD, CUT, w{J+1}{s0}{s1}{s2},1);
                w_lo{J+1}{s0}{s1}{s2} = w{J+1}{s0}{s1}{s2} - w_hi{J+1}{s0}{s1}{s2};
        end
    end
end
u_lo = icplxdual3D_u(w_lo,J,Fsf,sf);
u_hi = icplxdual3D_u(w_hi,J,Fsf,sf);

