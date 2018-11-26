clear;

%% Set parameters

%%% All physical parameters

rho     = 1;
%%% All numerical parameters

resol = 200;
gridSize = resol*20; %max(omega1, omega2);
deltaX = 1/gridSize;
xVec = (1:gridSize)'/gridSize;

%%% Vary the wavelength

omegaList = 10:5:100;
acc = zeros(size(omegaList,2),1);


for step = 1:size(omegaList,2)
    
    omega1 = omegaList(step);
    omega2 = 1.2*omega1;
    
    
    D1 = deltaX^2*rho*omega1^2;
    D2 = deltaX^2*rho*omega2^2;
    muVec = mu_func(xVec)';
    
    %% Calculating the displacement

    u1 = invert_for_u(muVec, D1, 1, 1, gridSize);
    u2 = invert_for_u(muVec, D2, 1, 1, gridSize);

    %%%% Corrupt the displacement field

    snr = 12;
    u1Noise = u1 + max(u1)*randn(size(u1))/snr;
    u2Noise = u2 + max(u2)*randn(size(u2))/snr;

    %% Denoising U

    level = ceil(log2(gridSize));
        
    [muRec, acc2, thresh] = find_right_thresh( u1Noise, u2Noise, D1, D2, gridSize, muVec, level );


    %% Reconstructing Mu

    acc(step) = acc2;
    step
    
end


plot(omegaList, acc)

% return

