function y = den_dwt3du(x,T)

[af, sf] = farras;
J = 3;
w = udwt3D(x,J,af);
% loop thru scales:
for j = 1:J
    for s = 1:7
        w{j}{s} = soft(w{j}{s},T);
    end
end
y = iudwt3D(w,J,sf);

