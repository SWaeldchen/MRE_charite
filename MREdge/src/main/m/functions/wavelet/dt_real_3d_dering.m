function y = dt_real_3d_dering(x, J)
if nargin < 3
    gain = 1;
end
[af, sf] = farras;
w = dwt3D(x,J,af);
QUANTILE = 0.99;
for j = 1:J
    for s = 1:7
        C = w{j}{s};
        % remove spikes in Fourier domain
        C_ft = fftnc(C);
        Q = quantile(abs(C_ft(:)), QUANTILE);
        C_ft(abs(C_ft) > Q) = 0;
        C = ifftnc(C_ft);
        %
        w{j}{s} = C;
    end
end
y = idwt3D(w,J,sf);

