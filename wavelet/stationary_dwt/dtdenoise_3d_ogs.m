function u = dtdenoise_3d_undec(u, J, mask, gain)

% 3D Dualtree complex denoising 

if nargin < 4
    gain = 1;
    if nargin < 3
        mask = ones(size(u));
    end
end

[u_resh, n_vol] = resh(u, 4);

[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;

for n = 1:n_vol
        u_n = u_resh(:,:,:,n);
        [~, ~, sigma_n] = donoho_method_snr_multichannel_vec(real(u_n), mask);
        mask = logical(mask);
        u_resh(:,:,:,n) = cdwt_den(real(u_n), mask, J, Faf, af, Fsf, sf, sigma_n) + 1i*cdwt_den(imag(u_n), mask, J, Faf, af, Fsf, sf, sigma_n);
end

u = reshape(u_resh, size(u));

end

function u_den = cdwt_den(u, mask, J, Faf, af, Fsf, sf, sigma_n)
    K = [3 3 3];
    pen = 'atan';
    rho = 0.5;
    niter = 10;
    w = cplxdual3D_u(u, J, Faf, af);
    % loop thru scales
    for j = 1:J
        % loop thru subbands
        %disp(['--',num2str(j),'--'])
        %noise_mean = 0;
        local_mask = pad_mask(mask, j);
        for s1 = 1:2
            for s2 = 1:2
                for s3 = 1:7
                    a = w{j}{1}{s1}{s2}{s3};
                    b = w{j}{2}{s1}{s2}{s3};
                    C = a + 1i*b;
                    
                    thresh = quantile(a(local_mask), 0.95);
                    lam = 0.1*thresh;
                    C = ogs3(C, K, lam, pen, rho, niter);
                    %C = hard(C, thresh);
                    C(isnan(C)) = 0;
                    w{j}{1}{s1}{s2}{s3} = real(C);
                    w{j}{2}{s1}{s2}{s3} = imag(C);
                end
            end
        end
    end
    u_den = icplxdual3D_u(w, J, Fsf, sf);
end

function local_mask = pad_mask(mask,level)
    sz = size(mask);
    pad1 = 0;
    pad2 = 0;
    for n = 1*level
        pad1 = pad1 + 4*2^(level-1);
        pad2 = pad2 + 5*2^(level-1);
    end
    local_mask = zeros(sz(1)+pad1+pad2, sz(2)+pad1+pad2, sz(3)+pad1+pad2);
    local_mask(pad1+1:end-pad2, pad1+1:end-pad2, pad1+1:end-pad2) = mask;
    local_mask = logical(local_mask);
end
