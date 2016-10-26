function [mag_cat, phi_cat] = cat_mre_tests(mag, phi)

mag_cat_1 = [];
mag_cat_2 = [];
mag_cat = [];
phi_cat_1 = [];
phi_cat_2 = [];
phi_cat = [];

sz = size(mag{1});
middle_slice = round(sz(3) / 2);

mag_cat_1 = cat(2, mag{1}(:,:,middle_slice), mag{2}(:,:,middle_slice), mag{3}(:,:,middle_slice));
mag_cat_2 = cat(2, mag{4}(:,:,middle_slice), mag{5}(:,:,middle_slice), mag{6}(:,:,middle_slice));
mag_cat = cat(1, mag_cat_1, mag_cat_2);

phi_cat_1 = cat(2, phi{1}(:,:,middle_slice), phi{2}(:,:,middle_slice), phi{3}(:,:,middle_slice));
phi_cat_2 = cat(2, phi{4}(:,:,middle_slice), phi{5}(:,:,middle_slice), phi{6}(:,:,middle_slice));
phi_cat = cat(1, phi_cat_1, phi_cat_2);


