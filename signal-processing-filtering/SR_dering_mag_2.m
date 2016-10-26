function [res] = SR_dering_mag_2(x)

szx = size(x);
res = zeros(szx);
x_cos = zeros(size(x));

tic
for z = 1:szx(3)
    % de-ring
    x_cos(:,:,z) = dct2(x(:,:,z));
end
toc
tic
for i = 1:szx(1)
    for j = 1:szx(2)
    x_cos(i,j,:) = dct(x_cos(i,j,:));
    end
end
toc
for m = 1:size(x_cos,1)
    for n = 1:size(x_cos,2)
        for p = 1:size(x_cos,3)
            thresh = 2000 - sqrt(p/size(x_cos,3))*1900;
            dist = sqrt(m^2 + n^2);
            if (dist > 200) 
                if abs(x_cos(m,n,p)) > thresh
                    x_cos(m,n,p) = 0;
                end
            end
        end
    end
end
y = zeros(size(x_cos));
for z = 1:szx(3)
    % de-ring
    y(:,:,z) = idct2(x_cos(:,:,z));
end
toc
tic
res = zeros(size(y));
cap = szx(3) / 4;
for i = 1:szx(1)
    for j = 1:szx(2)
    res(i,j,1:cap) = y(i,j,1:cap);
    res(i,j,:) = idct(res(i,j,:));
    end
end
res = y;