
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

for n = 1:d5
		tempx = x(:,:,:,n);
		tempy = y(:,:,:,n);
		tempz = z(:,:,:,n);
        if hodge_code == 0
			[FRx, FRy, FRz] = curl(tempx, tempy, tempz);
            cx(:,:,:,n) = FRx;
            cy(:,:,:,n) = FRy;
            cz(:,:,:,n) = FRz;
        elseif hodge_code == 1
            disp('hipass butter');
            cx(:,:,:,n) = butter_2d(4, 0.05, tempx, 1);
            cy(:,:,:,n) = butter_2d(4, 0.05, tempy, 1);
            cz(:,:,:,n) = butter_2d(4, 0.05, tempz, 1);
        elseif hodge_code == 2
            disp('lsq hhd');
            curl_comps = hhd_lsqr({tempx, tempy, tempz}, hodge_iter);
            cx(:,:,:,n) = curl_comps{1};
            cy(:,:,:,n) = curl_comps{2};
            cz(:,:,:,n) = curl_comps{3};
        else
            cx(:,:,:,n) = tempx;
            cy(:,:,:,n) = tempy;
            cz(:,:,:,n) = tempz;
        end
		
end

for n = 1:d5
    curlField(:,:,:,1,n) = cx(:,:,:,n);
    curlField(:,:,:,2,n) = cy(:,:,:,n);
    curlField(:,:,:,3,n) = cz(:,:,:,n);
end
		

