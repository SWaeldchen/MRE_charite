clear all
addpath('/home/realtime/spm12');

A = spm_read_vols(spm_vol('mag_orig.nii'));

BW = logical(A>120);
for sigma = 1:10;

B = imgaussfilt3(A,sigma);

B=B(B.*BW>0);

B=B(:)./(norm(B));

val(sigma) = entropy(B);

end

figure; plot(val);shg