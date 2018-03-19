
function curlField = kmdev_lsq_hhd( waveField)

curlField = zeros(size(waveField));
sz = size(waveField);
%{
for n = 1:sz(5)
	for k = 1:sz(3);
		tempx = waveField(:,:,k,2,n);
		tempy = waveField(:,:,k,1,n);
		tempz = waveField(:,:,k,3,n);
		%[~,~,~,FRx, FRy, FRz] = hhd_2d_EB(tempx, tempy, tempz);
		curlField(:,:,k,2,n) = FRx;
		curlField(:,:,k,3,n) = FRz;
		curlField(:,:,k,1,n) = FRy;
	end
end
%}

if numel(sz) < 5
	d5 = 1;
else
	d5 = sz(5);
end

for n = 1:d5
		tempx = waveField(:,:,:,2,n);
		tempy = waveField(:,:,:,1,n);
		tempz = waveField(:,:,:,3,n);
		[~,~,~,FRx, FRy, FRz] = hhd_EB(tempx, tempy, tempz);
		%[FRxR, FRyR, FRzR] = dfwavelet_thresh_SURE_MAD_spin(real(tempx),real(tempy),real(tempz),[8 8 8],[1,1,1],3,1);
		%[FRxI, FRyI, FRzI] = dfwavelet_thresh_SURE_MAD_spin(imag(tempx),imag(tempy),imag(tempz),[8 8 8],[1,1,1],3,1);
		%curlField(:,:,:,2,n) = FRxR + 1i*FRxI;
		%curlField(:,:,:,3,n) = FRzR + 1i*FRzI;
		%curlField(:,:,:,1,n) = FRyR + 1i*FRyI;
		[FRx, FRy, FRz] = curl(tempx, tempy, tempz);
		curlField(:,:,:,2,n) = FRx;
		curlField(:,:,:,3,n) = FRz;
		curlField(:,:,:,1,n) = FRy;
end

