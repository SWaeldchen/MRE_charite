function [res] = SR_dering_mag_3(x)

szx = size(x);
res = zeros(szx);
for z = 1:szx(3)
    % de-ring
    x_cos = dct2_eb(x(:,:,z));
    y = zeros(size(x_cos));
    for m = 1:size(x_cos,1)
        for n = 1:size(x_cos,2)
            pos = sqrt((szx(1)-m)^2 + (szx(2)-n)^2) * 64 * exp(-(m^2 + n^2) / 96^2) + 60;
            if (abs(x_cos(m,n)) > pos)
                y(m,n) = 0;
            else
                y(m,n) = x_cos(m,n);
            end
        end
    end
    y = idct2_eb(y);
    %{
    %recalibrate
    medfilt_x = medfilt2_eb(x(:,:,z), [3 3]);
    min_x = min(min(medfilt_x));
    max_x = max(max(medfilt_x));
    medfilt_y = medfilt2_eb(y, [3 3]);
    min_y = min(min(medfilt_y));
    min_diff = min_x - min_y;
    y = y + min_diff;
    medfilt_y = medfilt2_eb(y, [3 3]);
    max_y = max(max(medfilt_y));
    y = y / max_y * max_x;
    %}
    res(:,:,z) = y;
end
for i = 1:szx(1)
    for j = 1:szx(2)
        strip = res(i,j,:);
        strip_dct = dct_eb(strip);
        strip_dct(12:end) = 0;
        res(i,j,:) = idct_eb(strip_dct);
    end
end



%sparsify
%res = medfilt3(res, [5 5 5]);
%for z = 1:szx(3)
%    res(:,:,z) = DT_2D(res(:,:,z), 150);
%end