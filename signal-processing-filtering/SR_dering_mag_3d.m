function [y] = SR_dering_mag_3d(x)

% de-ring
x_fft = fftn(x);

for m = 1:size(x,1)/2
    for n = 1:size(x,2)/2
        for p = 1
            dist = sqrt(m^2 + n^2 + p^2);
            if ( dist > 96 && abs(x_fft(m,n,p)) > 10000000 )
                x_fft(m,n,p) = 0;
                x_fft(512-m+2,n,p) = 0;
                x_fft(m,512-n+2,p) = 0;
                x_fft(512-m+2, 512-n+2,p) = 0;
            end
        end
    end
end

        
y = ifftn(x_fft);
%recalibrate
medfilt_x = medfilt3(x, [3 3 3]);
min_x = min(medfilt_x(:));
max_x = max(medfilt_x(:));
medfilt_y = medfilt3(y, [3 3 3]);
min_y = min(medfilt_y(:));
min_diff = min_x - min_y;
y = y + min_diff;
medfilt_y = medfilt3(y, [3 3 3]);
max_y = max(medfilt_y(:));
y = y / max_y * max_x;