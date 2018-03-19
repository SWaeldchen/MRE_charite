function u = dtdenoise_2d_undec(u, J, mask)

% 2D Dualtree complex denoising 
% with NNG thresholding

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
if nargin < 4
	J = 3;
end


for n = 1:d4
    for m = 1:d3
        u(:,:,m,n) = cdwt_nng(real(u(:,:,m,n)), mask(:,:,m), J, Faf, af, Fsf, sf) + 1i*cdwt_nng(imag(u(:,:,m,n)), mask(:,:,m), J, Faf, af, Fsf, sf);
    end
end

end

function u_den = cdwt_nng(u, mask, J, Faf, af, Fsf, sf)
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
                C = nng(C, 1.5*bayesshrink_noise_est);
                C(isnan(C)) = 0;
                w{j}{1}{s1}{s2} = real(C);
                w{j}{2}{s1}{s2} = imag(C);
            end
        end
    end
    u_den = icplxdual2D_u(w, J, Fsf, sf);
end

