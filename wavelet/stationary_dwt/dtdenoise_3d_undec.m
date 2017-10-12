function u = dtdenoise_3d_undec(u, J, mask)

% 3D Dualtree complex denoising 
% with NNG thresholding

if nargin < 4
    thresh = 'visu';
    if nargin < 3
        mask = ones(size(u));
    end
end

[u_resh, n_vol] = resh(u, 4);

[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;

for n = 1:n_vol
        %disp(['------',num2str(n),'------'])
        u_resh(:,:,:,n) = cdwt_den(real(u_resh(:,:,:,n)), mask, J, Faf, af, Fsf, sf) + 1i*cdwt_den(imag(u_resh(:,:,:,n)), mask, J, Faf, af, Fsf, sf);
end

u = reshape(u_resh, size(u));

end

function u_den = cdwt_den(u, mask, J, Faf, af, Fsf, sf)
    w = cplxdual3D_u(u, J, Faf, af);
    % loop thru scales
    for j = 1:J
        % loop thru subbands
        %disp(['--',num2str(j),'--'])
        %noise_mean = 0;
        for s1 = 1:2
            for s2 = 1:2
                for s3 = 1:7
                    a = w{j}{1}{s1}{s2}{s3};
                    b = w{j}{2}{s1}{s2}{s3};
                    C = a + 1i*b;
                    noise_est = 1.5*visushrink_eb(abs(C), simplepad(mask, [size(C,1), size(C,2) , size(C,3)]));
                    %if j == 1
                    %    noise_est = 0.4;
                    %else
                    %    noise_est = 0.04;
                    %end
                    C = soft(C, noise_est);
                    C(isnan(C)) = 0;
                    w{j}{1}{s1}{s2}{s3} = real(C);
                    w{j}{2}{s1}{s2}{s3} = imag(C);
                end
            end
        end
        %disp(noise_mean / (2*2*7))
    end
    u_den = icplxdual3D_u(w, J, Fsf, sf);
end

