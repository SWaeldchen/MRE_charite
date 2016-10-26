[x y z] = meshgrid(1:128, 1:128, 1:16);
xc = cos((x*32)*2*pi/128);
yc = cos((y*32)*2*pi/128);
zc = cos((z*32)*2*pi/128);
i = zeros(128,128,16,16);
j = zeros(128,128,16,16);
k = zeros(128,128,16,16);