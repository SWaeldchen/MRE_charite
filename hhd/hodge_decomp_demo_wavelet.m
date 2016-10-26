
function [cdwt_curl, diff_curl, cdwt_G, diff_G] = hodge_decomp_demo_wavelet(brain_wavefield)

	J = 2;

    cdwt_curl = zeros(size(brain_wavefield));
    diff_curl = zeros(size(brain_wavefield));

    x = brain_wavefield(:,:,:,2);
    y = brain_wavefield(:,:,:,1);
    z = brain_wavefield(:,:,:,3);
    
	[xdx, xdy, xdz] = cdwt_diff_3D(x,J);
	[ydx, ydy, ydz] = cdwt_diff_3D(y,J);
	[zdx, zdy, zdz] = cdwt_diff_3D(z,J);
	cdwt_curl(:,:,:,1) = zdy - ydz;
	cdwt_curl(:,:,:,2) = xdz - zdx;
	cdwt_curl(:,:,:,3) = ydx - xdy;

    
    [cx, cy, cz] = curl(x, y, z);
    diff_curl(:,:,:,2) = cx;
    diff_curl(:,:,:,1) = cy;
    diff_curl(:,:,:,3) = cz;
        
    % A quick wave inversion using the Navier-Helmholtz viscoelastic wave
    % equation
    % G* = rho*omega^2*.wavefield ./ laplacian
    laplacian_operator = zeros(3, 3, 3);
    laplacian_operator(:,:,2) = [0 1 0; 1 -6 1; 0 1 0];
    laplacian_operator(2,2,1) = 1; 
    laplacian_operator(2,2,3) = 1; 
    laplacian_operator = laplacian_operator / (.002).^2; % 2mm is grid size of experiment
    
    cdwt_lap = convn(cdwt_curl, laplacian_operator, 'same');
    diff_lap = convn(diff_curl, laplacian_operator, 'same');
    
    cdwt_G = sum (abs(cdwt_curl),4) * 1000 * (2*pi*25).^2 ./ sum(abs(cdwt_lap), 4); % 25 Hz is shear wave frequency, 1000 is density of soft tissue / water
    diff_G = sum (abs(diff_curl),4) * 1000 * (2*pi*25).^2 ./ sum(abs(diff_lap), 4);
  
    % trim outer slices
    cdwt_G = cdwt_G(:,:,2:end-1);
    diff_G = diff_G(:,:,2:end-1);

