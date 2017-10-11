function u = dtdenoise_3d_undec(u, J, mask, thresh)

% 3D Dualtree complex denoising 
% with NNG thresholding

if numel(size(u)) < 4
    d4 = 1;
else
    d4 = size(u,4);
end

if nargin < 4
    thresh = 'visu';
    if nargin < 3
        mask = ones(size(u));
    end
end

[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;

for n = 1:d4
        u(:,:,:,n) = cdwt_den(real(u(:,:,:,n)), mask, J, thresh, Faf, af, Fsf, sf) + 1i*cdwt_den(imag(u(:,:,:,n)), mask, J, thresh, Faf, af, Fsf, sf);
end

end

function u_den = cdwt_den(u, mask, J, thresh, Faf, af, Fsf, sf)
    w = cplxdual3D_u(u, J, Faf, af);
    % loop thru scales
    for j = 1:J
        % loop thru subbands
        for s1 = 1:2
            for s2 = 1:2
                for s3 = 1:7
                    a = w{j}{1}{s1}{s2}{s3};
                    b = w{j}{2}{s1}{s2}{s3};
                    C = a + 1i*b;
                    noise_est = 1.5*visushrink_eb(abs(C), simplepad(mask, [size(C,1), size(C,2) , size(C,3)]));
                    C = soft(C, noise_est);
                    C(isnan(C)) = 0;
                    w{j}{1}{s1}{s2}{s3} = real(C);
                    w{j}{2}{s1}{s2}{s3} = imag(C);
                end
            end
        end
    end
    u_den = icplxdual3D_u(w, J, Fsf, sf);
end

