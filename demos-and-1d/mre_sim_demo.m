
function mre_sim_demo

    map = ones(400, 400);
    %insert 1
    map(298:302, 298:302) = 2;
    %insert 2
    map(298:302, 318:322) = 2;
    grid = .001;
    
    k = 0.5:0.05:0.65;
    nk = numel(k);

    RHO = 1000;
    OGS_COEFF = 0.08;
    NOISE_SIGMA = 0.02;
    NITER = 16;

    u = fd_sim_2d(1, map);
    % scale it up a bit -- this gets the amplitudes around the inserts to around 1
    normalization_constant = 1 / (max(abs(u(:))) - min(abs(u(:))));
    u = 10*(u*normalization_constant);
    
    % noise free case
    g_no_noise = quick_invert(u, 1,grid);
    
       
    
    %add 1 per cent noise comparable to in vivo acquisitions
    u_noise = u + randn(size(u))*NOISE_SIGMA;
    % denoise lowpass
    u_denoise_lowpass = lowpass_butter_2d(u_noise, 4, 0.07);
    g_denoise_lowpass = quick_invert(u_denoise_lowpass,1,grid);
    % denoise wavelet
    u_denoise_wavelet = DT_2D_spin(u_noise, 16, OGS_COEFF, 4);
    g_denoise_wavelet = quick_invert(u_denoise_wavelet,1,grid);

    figure(1);
    subplot(3, 3, 1); imshow(g_no_noise, [0 6]); title('Noise free stiffness recovery');
    subplot(3, 3, 2); imshow(g_denoise_lowpass, [0 6]); title('lowpass denoised stiffness, single freq');
    subplot(3, 3, 3); imshow(g_denoise_wavelet, [0 5]); title('Wavelet denoised stiffness, single freq');
    
    
    
    %noise free MDEV
    
    for n = 1:nk
        tic
        u = fd_sim_2d(k(n), map);
        normalization_constant = 1 / (max(abs(u(:))) - min(abs(u(:))));
        u = display_region(2*(u*normalization_constant));
        % OR
        absg_num(:,:,n) = RHO * (2*pi*k(n))^2. * abs(u); %#ok<*AGROW>
        absg_denom(:,:,n) = abs(lap(u)) / grid^2;
        % SR
        u_down = u(1:4:end, 1:4:end);
        grid_down = grid * 4;
        absg_down_num(:,:,n) = RHO * (2*pi*k(n))^2. * abs(u_down);
        absg_down_denom(:,:,n) = abs(lap(u_down)) / grid_down^2;
        u_sr = iterative_bicubic(u_down, NITER, 4);
        absg_sr_num(:,:,n) = RHO * (2*pi*k(n))^2. * abs(u_sr);
        absg_sr_denom(:,:,n) = abs(lap(u_sr)) / grid^2;
        toc
    end
    abs_G = sum(absg_num,3) ./ sum(absg_denom,3);
    abs_G_down = sum(absg_down_num,3) ./ sum(absg_down_denom,3);
    abs_G_sr = sum(absg_sr_num,3) ./ sum(absg_sr_denom,3);

    subplot(3, 3, 4); imshow(abs_G, [0 6]); title('MDEV noiseless recovery');
    subplot(3, 3, 5); imshow(abs_G_down, [0 6]); title('MDEV noiselsss recovery downsampled');
    subplot(3, 3, 6); imshow(abs_G_sr, [0 6]); title('MDEV noiseless SR recovery');


    
    for n = 1:nk
        tic
        u = fd_sim_2d(k(n), map);
        normalization_constant = 1 / (max(abs(u(:))) - min(abs(u(:))));
        u = display_region(2*(u*normalization_constant));
        u_noise = u + randn(size(u))*NOISE_SIGMA;
        % OR
        u_den = DT_2D_spin(u_noise, 4, OGS_COEFF, 2);
        absg_num(:,:,n) = RHO * (2*pi*k(n))^2. * abs(u_den); %#ok<*AGROW>
        absg_denom(:,:,n) = abs(lap(u_den)) / grid^2;
        % SR
        u_down = u_noise(1:4:end, 1:4:end);
        u_down_den = DT_2D_spin(u_down, 4, OGS_COEFF, 2);
        grid_down = grid * 4;
        absg_down_num(:,:,n) = RHO * (2*pi*k(n))^2. * abs(u_down_den);
        absg_down_denom(:,:,n) = abs(lap(u_down_den)) / grid_down^2;
        u_sr = iterative_bicubic(u_down_den, NITER, 4);
        absg_sr_num(:,:,n) = RHO * (2*pi*k(n))^2. * abs(u_sr);
        absg_sr_denom(:,:,n) = abs(lap(u_sr)) / grid^2;
        toc
    end
    abs_G = sum(absg_num,3) ./ sum(absg_denom,3);
    abs_G_down = sum(absg_down_num,3) ./ sum(absg_down_denom,3);
    abs_G_sr = sum(absg_sr_num,3) ./ sum(absg_sr_denom,3);

    subplot(3, 3, 7); imshow(abs_G, [0 6]); title('MDEV recovery');
    subplot(3, 3, 8); imshow(abs_G_down, [0 6]); title('MDEV recovery downsampled');
    subplot(3, 3, 9); imshow(abs_G_sr, [0 6]); title('MDEV SR recovery');

  
 
end

function cropped_image = display_region(image, ds)
if nargin < 2
    ds = 0; 
end
if ds == 0
    cropped_image = image(241:368, 241:368);
else
    cropped_image = image(61:92, 61:92);
end

end

