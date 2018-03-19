function [res] = SR_dering_mag(x)

szx = size(x);
res = zeros(szx);
for z = 1:szx(3)
    % de-ring
    x_cos = dct2(x(:,:,z));
    y = zeros(size(x_cos));
    for m = 1:size(x_cos,1)
        for n = 1:size(x_cos,2)
            pos = sqrt((512-m)^2 + (512-n)^2) * 64 * exp(-(m^2 + n^2) / 96^2) + 60;
            if (abs(x_cos(m,n)) > pos)
                y(m,n) = 0;
            else
                y(m,n) = x_cos(m,n);
            end
        end
    end
    y = idct2(y);

    
    res(:,:,z) = y;
    
end
