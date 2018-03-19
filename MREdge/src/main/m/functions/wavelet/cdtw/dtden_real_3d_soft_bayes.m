function y = dtden_real_3d_soft_bayes(x, J, gain)
if nargin < 3
    gain = 1;
end
[af, sf] = farras;
w = dwt3D(x,J,af);
for j = 1:J
    for s = 1:7
        C = w{j}{s};
        % soft thresh
        T = gain*bayesshrink_eb(abs(C));
        c = max(abs(C) - T, 0);
        C = c./(c+T) .* C;
        %
        w{j}{s} = C;
    end
end
y = idwt3D(w,J,sf);

