function laplacian = get3dLaplacian

laplacian = zeros(3,3,3);
laplacian(2,2,1) = 1;
laplacian(2,2,3) = 1;
laplacian(:,:,2) = [0 1 0; 1 -6 1; 0 1 0];
