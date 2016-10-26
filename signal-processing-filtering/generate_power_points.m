function cuts = generate_power_points(im)

%generates subtraction images at -2db, -3db, -4db and -5db

cuts = cell(4,1);

im_ft = fftshift(fft2(im));
im_ft_db = log(normalizeImage(abs(im_ft))) ./ log(10);

cut_2db_ft = im_ft;
cut_2db_ft(im_ft_db<-2) = 0;
cut_2db = ifft2(ifftshift(cut_2db_ft));

cut_3db_ft = im_ft;
cut_3db_ft(im_ft_db<-3) = 0;
cut_3db = ifft2(ifftshift(cut_3db_ft));

cut_4db_ft = im_ft;
cut_4db_ft(im_ft_db<-4) = 0;
cut_4db = ifft2(ifftshift(cut_4db_ft));

cut_5db_ft = im_ft;
cut_5db_ft(im_ft_db<-5) = 0;
cut_5db = ifft2(ifftshift(cut_5db_ft));

cuts{1} = im - cut_2db;
cuts{2} = im - cut_3db;
cuts{3} = im - cut_4db;
cuts{4} = im - cut_5db;
