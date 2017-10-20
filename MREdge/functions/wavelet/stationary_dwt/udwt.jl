using MatlabCompat
importall MatlabCompat.ImageTools
importall MatlabCompat.MathTools
function udwt(x, J, h0, h1)
R = sqrt(2);
h0 = h0/R;
if size(h0, 1) == 1
    h0 = permute(h0, [2 1]);
end
if size(h1, 1) == 1
    h1 = permute(h1, [2 1]);
end
h1 = h1/R;
N0 = length(h0);
N1 = length(h1);
isrow = 0;
if size(x,1) == 1    
    x = permute(x, [2 1]);
    isrow = 1;
end
w = cell(1,J);
for j = 1:J
    L = length(x);
    M = 2^(j-1);
    lo = zeros(L+M*(N0-1),1);
    hi = zeros(L+M*(N1-1),1);
    for k = 0:N1-1
        hi(M*k+(1:L)) = hi(M*k+(1:L)) + h1(k+1)*x;
    end
    for k = 0:N0-1
        lo(M*k+(1:L)) = lo(M*k+(1:L)) + h0(k+1)*x;
    end
    w{j} = hi;
    x = lo;
end
w{J+1} = x;
end

