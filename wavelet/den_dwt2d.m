function y = den_dwt2d(x,T)

[af, sf] = farras;
J = 4;
w = dwt2D(x,J,af);
% loop thru scales:
for j = 1:J
    for s = 1:3
        w{j}{s} = soft_simple(w{j}{s},T);
    end
end
y = idwt2D(w,J,sf);

