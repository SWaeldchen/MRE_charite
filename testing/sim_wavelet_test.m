
function results = sim_wavleet_test;

    map = ones(400, 400);
    %insert 1
    map(298:302, 298:302) = 2;
    %insert 2
    map(298:302, 318:322) = 2;
    
    k = 0.5:0.05:0.65;
    nk = numel(k);

    GRID = 1;
    RHO = 1000;
    OGS_COEFF = 0.08;
    NOISE_SIGMA = 0.02;
    NITER = 16;

    u = fd_sim_2d(1, map);
    % scale it up a bit -- this gets the amplitudes around the inserts to around 1
    normalization_constant = 1 / (max(abs(u(:))) - min(abs(u(:))));
    u = 10*(u*normalization_constant);
    
    noise_levels = [.0001 .0005 .001 .005 .01 .05 .1];
    n_noise = numel(noise_levels)
    J_levels = 1:4;
    n_J = numel(J_levels);
    ogs_levels = 0.01:0.02:0.2;
    n_ogs = numel(ogs_levels);
    
    results = zeros(size(u,1), size(u,2), n_noise, n_J, n_ogs);
    
    for n = 1:n_noise
      for j = 1:n_J
        for o = 1:n_ogs
          noise = noise_levels(n);
          J = J_levels(j);
          ogs = ogs_levels(o);
          disp([num2str(noise), ' ', num2str(J), ' ', num2str(ogs), ' ']);
          tic
          spins = 2^J;
          u_noise = u + randn(size(u))*noise;
          u_den = DT_2D_spin(u_noise, spins, ogs, J);
          results(:,:,n,j,o) = quick_invert(u_den, 1, GRID);
          toc
        end
      end
    end
    
    
 
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

