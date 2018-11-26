clear;

%% Set parameters

%%% All physical parameters

rho     = 1;
omega1 = 50;
omega2 = 1.2*omega1;
    
%%% All numerical parameters

resol = 200;
gridSize = resol*20; %max(omega1, omega2);
deltaX = 1/gridSize;
xVec = (1:gridSize)'/gridSize;

    
D1 = deltaX^2*rho*omega1^2;
D2 = deltaX^2*rho*omega2^2;
muVec = mu_func(xVec)';

%%% Vary the wavelength

snrList = 3:1:20;
acc = zeros(size(snrList,2),1);


%% Calculating the displacement

u1 = invert_for_u(muVec, D1, 1, 1, gridSize);
u2 = invert_for_u(muVec, D2, 1, 1, gridSize);


for step = 1:size(snrList,2)
    
    for run = 1:10
    
        %%%% Corrupt the displacement field

        snr = snrList(step);
        u1Noise = u1 + max(u1)*randn(size(u1))/snr;
        u2Noise = u2 + max(u2)*randn(size(u2))/snr;

        %% Denoising U

        level = ceil(log2(gridSize));
        
        [muRec, acc2, thresh] = find_right_thresh( u1Noise, u2Noise, D1, D2, gridSize, muVec, level );

        %% Reconstructing Mu

        acc(step) = acc(step) + acc2;
    end
    
    step
    
    acc(step) = acc(step)/10;
    
end

plot(snrList, acc);

