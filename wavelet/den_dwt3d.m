function y = den_dwt3d(x,T)

[af, sf] = farras;
J = 3;
w = dwt3D(x,J,af);
% loop thru scales:
for j = 1:J
    for s = 1:7
        w{j}{s} = soft(w{j}{s},T);
    end
end
y = idwt3D(w,J,sf);

