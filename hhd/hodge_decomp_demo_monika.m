
function [lsq_curl, diff_curl, lsq_G, diff_G] = hodge_decomp_demo_monika(brain_wavefield)

    lsq_curl = zeros(size(brain_wavefield));
    diff_curl = zeros(size(brain_wavefield));

    x = brain_wavefield(:,:,:,2);
    y = brain_wavefield(:,:,:,1);
    z = brain_wavefield(:,:,:,3);
    [~,~,~,FRxR, FRyR, FRzR] = hhd_EB(real(x), real(y), real(z));
    [~,~,~,FRxI, FRyI, FRzI] = hhd_EB(imag(x), imag(y), imag(z));
    lsq_curl(:,:,:,2) = FRxR + 1i*FRxI;
    lsq_curl(:,:,:,3) = FRzR + 1i*FRzI;
    lsq_curl(:,:,:,1) = FRyR + 1i*FRyI;
    
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
    
    lsq_lap = convn(lsq_curl, laplacian_operator, 'same');
    diff_lap = convn(diff_curl, laplacian_operator, 'same');
    
    lsq_G = sum (abs(lsq_curl),4) * 1000 * (2*pi*25).^2 ./ sum(abs(lsq_lap), 4); % 25 Hz is shear wave frequency, 1000 is density of soft tissue / water
    diff_G = sum (abs(diff_curl),4) * 1000 * (2*pi*25).^2 ./ sum(abs(diff_lap), 4);
  
    % trim outer slices
    lsq_G = lsq_G(:,:,2:end-1);
    diff_G = diff_G(:,:,2:end-1);

