dering = zeros(size(mag_lin));
for n = 1:10
dering(:,:,n) = wavelet_dering_cdwt(mag_lin(:,:,n), thresh, 1);
end
openImage(dering, MIJ);