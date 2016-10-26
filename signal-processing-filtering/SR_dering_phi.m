function [y] = SR_dering_phi(x)

% de-ring
x_cos = dct2(x);
y = zeros(size(x));
for m = 1:size(x,1)
    for n = 1:size(x,2)
        pos = 8 * exp(-(m^2 + n^2) / 96^2) + 0.1;
        if (abs(x_cos(m,n)) > pos)
            y(m,n) = 0;
        else
            y(m,n) = x_cos(m,n);
        end
    end
end
y = idct2(y);

%recalibrate
medfilt_x = medfilt2(x, [3 3]);
min_x = min(min(medfilt_x));
max_x = max(max(medfilt_x));
medfilt_y = medfilt2(y, [3 3]);
min_y = min(min(medfilt_y));
min_diff = min_x - min_y;
y = y + min_diff;
medfilt_y = medfilt2(y, [3 3]);
max_y = max(max(medfilt_y));
y = y / max_y * max_x;