function y = dtden_real_3d_dering(x, J)
if nargin < 3
    gain = 1;
end
[af, sf] = farras;
w = dwt3D(x,J,af);
for j = 1:J
    for s = 1:7
        C = w{j}{s};
        % remove spikes in Fourier domain
        C_ft = fftnc(C);
        C_99 = quantile(C_ft, 0.99);
        C_ft(abs(C_ft) > C_99) = 0;
        C = ifftnc(C_ft);
        %
        w{j}{s} = C;
    end
end
y = idwt3D(w,J,sf);

