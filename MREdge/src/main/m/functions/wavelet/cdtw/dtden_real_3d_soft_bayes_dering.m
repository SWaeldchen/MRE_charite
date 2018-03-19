function y = dtden_real_3d_soft_bayes_dering(x, J, gain)
if nargin < 3
    gain = 1;
end
[af, sf] = farras;
w = dwt3D(x,J,af);
QUANTILE = 0.99;
for j = 1:J
    for s = 1:7
        C = w{j}{s};
        %dering
        C_ft = fftnc(C);
        Q = quantile(abs(C_ft(:)), QUANTILE);
        C_ft(abs(C_ft) > Q) = 0;
        C = ifftnc(C_ft);
        % soft thresh
        T = gain*bayesshrink_eb(abs(C));
        c = max(abs(C) - T, 0);
        C = c./(c+T) .* C;
        %
        w{j}{s} = C;
    end
end
y = idwt3D(w,J,sf);

