function [u, guides] = dtdenoise_2d_undec_guides(u, J, mask)

% 3D Dualtree complex denoising 
% with NNG thresholding
if numel(size(u)) < 5
    d5 = 1;
else
    d5 = size(u,5);
end
if numel(size(u)) < 4
    d4 = 1;
else
    d4 = size(u,4);
end
if numel(size(u)) < 3
    d3 = 1;
else
    d3 = size(u,3);
end
if nargin < 3
    mask = ones(size(u));
end

[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;
if nargin < 3
	J = 3;
end

guides = [];
for p = 1:d5
    for n = 1:d4
        for m = 1:d3
            [u_r(:,:,m,n,p), guides] = cdwt_nng(real(u(:,:,m,n,p)), mask(:,:,m), J, Faf, af, Fsf, sf, guides);
            [u_i(:,:,m,n,p), guides] = cdwt_nng(imag(u(:,:,m,n,p)), mask(:,:,m), J, Faf, af, Fsf, sf, guides);
            u(:,:,m,n,p) = u_r(:,:,m,n,p) + 1i*u_i(:,:,m,n,p);
        end
    end
end

sz = size(u);

guides = reshape(guides, [sz(1), sz(2), 12, sz(3), sz(4), sz(5)]);
guides = permute(guides, [1 2 4 3 5 6]);
guides = squeeze(median(median(guides,4),5));
guides(guides<1) = 0;
end

function [u_den, guides] = cdwt_nng(u, mask, J, Faf, af, Fsf, sf, guides)
    u = butter_2d(4, 0.5, u);
    w = cplxdual2D_u(u, J, Faf, af);
    % loop thru scales
    for j = 1:J
        % loop thru subbands
        for s1 = 1:2
            for s2 = 1:3
                a = w{j}{1}{s1}{s2};
                b = w{j}{2}{s1}{s2};
                C = a + 1i*b;
                bayesshrink_noise_est = bayesshrink_eb(abs(C), simplepad(mask, [size(C,1) size(C,2)]));
                %visushrink_noise_est = visushrink_eb(abs(C), simplepad(mask, [size(C,1) size(C,2)]));
                C = nng(C, bayesshrink_noise_est);
                C(isnan(C)) = 0;
                if j == 1
                    C_guide = C;
                    C_guide(C_guide ~= 0) = 1;
                    guides = cat(3, guides, logical(C_guide(5:end-5, 5:end-5)));
                end
                w{j}{1}{s1}{s2} = real(C);
                w{j}{2}{s1}{s2} = imag(C);
            end
        end
    end
    u_den = icplxdual2D_u(w, J, Fsf, sf);
end