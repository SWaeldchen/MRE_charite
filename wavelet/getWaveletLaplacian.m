
function U_laplacian = getWaveletLaplacian(U, spacing)
    U_lapX = zeros(size(U));
    U_lapY = zeros(size(U));
    U_lapZ = zeros(size(U));
    for n = 1:size(U,4)
		U_lapX(:,:,:,n) = direc_deriv(U(:,:,:,n), 3, 2)/spacing(1)^2;
		U_lapY(:,:,:,n) = shiftdim(direc_deriv(shiftdim(U(:,:,:,n),1), 3, 2),2)/spacing(2)^2;
		U_lapZ(:,:,:,n) = shiftdim(direc_deriv(shiftdim(U(:,:,:,n),2), 3, 2),1)/spacing(3)^2;
    end
	U_laplacian = U_lapX + U_lapY + U_lapZ;
end

