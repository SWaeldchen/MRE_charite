
function curlField = hodge_decomp(waveField, hodge_code, hodge_iter)

sz = size(waveField);
curlField = zeros(sz);

if numel(sz) < 5
	d5 = 1;
else
	d5 = sz(5);
end
x = squeeze(waveField(:,:,:,2,:));
y = squeeze(waveField(:,:,:,1,:));
z = squeeze(waveField(:,:,:,3,:));

cx = x;
cy = y;
cz = z;

parfor n = 1:d5
		tempx = x(:,:,:,n);
		tempy = y(:,:,:,n);
		tempz = z(:,:,:,n);
        if hodge_code == 0
			[FRx, FRy, FRz] = curl(tempx, tempy, tempz);
        elseif hodge_code == 1
            disp('lsq hhd');
            [~, ~, ~, FRx, FRy, FRz] = hhd_curl_guess(tempx, tempy, tempz, hodge_iter);
        end
		cx(:,:,:,n) = FRx;
		cy(:,:,:,n) = FRz;
		cz(:,:,:,n) = FRy;
end

for n = 1:d5
    curlField(:,:,:,1,n) = cx(:,:,:,n);
    curlField(:,:,:,2,n) = cy(:,:,:,n);
    curlField(:,:,:,3,n) = cz(:,:,:,n);
end
		

