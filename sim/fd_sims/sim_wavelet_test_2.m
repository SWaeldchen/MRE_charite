
function results = sim_wavelet_test_2

    map = ones(400, 400);
    %insert 1
    map(298:300, 298:300) = 2;
    %insert 2
    map(298:300, 304:306) = 2;
    
    k = 0.5:0.05:0.65;
    nk = numel(k);

    GRID = .001;
    RHO = 1000;

    u = fd_sim_2d(1, map);
    % scale it up a bit -- this gets the amplitudes around the inserts to around 1
    normalization_constant = 1 / (max(abs(u(:))) - min(abs(u(:))));
    u = 10*(u*normalization_constant);
    
    noise_levels = [.01:.01:.05];
    n_noise = numel(noise_levels);
    %J_levels = 3:4;
    %n_J = numel(J_levels);
    ogs_levels = 0.08:0.01:0.12;
    n_ogs = numel(ogs_levels);
    butter_cuts = .03:.02:.09;
    n_cuts = numel(butter_cuts);
    
       
    results_butter = zeros(size(u,1), size(u,2), n_noise, n_cuts);
    
    for n = 1:n_noise
      for c = 1:n_cuts
          tic
          noise = noise_levels(n);
          cut = butter_cuts(c);
          u_noise = u + randn(size(u))*noise;
          u_den = lowpass_butter_2d(4, cut, u_noise);
          results_butter(:,:,n,c) = quick_invert(u_den, 1, GRID);
          toc
      end
    end
    
    results_ogs = zeros(size(u,1), size(u,2), n_noise, n_ogs);
    
    for n = 1:n_noise
      %for j = 1:n_J
        for o = 1:n_ogs
          noise = noise_levels(n);
          ogs = ogs_levels(o);
          tic
          spins = 2^4;
          u_noise = u + randn(size(u))*noise;
          u_den = DT_2D_spin(u_noise, spins, ogs, 4);
          results_ogs(:,:,n,o) = quick_invert(u_den, 1, GRID);
          toc
        end
      %end
    end

    results = {results_butter, results_ogs};
    
 
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

