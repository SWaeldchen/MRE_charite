
% Orts-Dimension
N = 200;


% frequencies in the wave
f= [12, 18, 80];
k = zeros(N,1);
k(f) = 1; k(end-f+2) = 1;

% Indicator function of the observed space
start= 50;
stop = 70;

I = zeros(N,1);
I(start:stop) = 1;
I = diag(I);

% Our observation with noise
y = real(fft(k));
y_obs = I*(y + randn(N,1)/5);

%Our naive inverse fourier result:
k_naive = ifft(y_obs);

%  Iteration settings

itSteps = 5000; % Numer of steps
lambda = 0.01; % regularisation with 1-norm
t = 0.0; % thresholding
alpha = 0.5; %step size 
k_it = zeros(N,1); % starting point

for step = 1:itSteps
    
    update = real(ifft(I*(fft(k_it) - y_obs))) + lambda*sign(k_it);
    k_it = k_it - alpha*update;
    k_it = k_it.*(abs(k_it) >= t);
    
end

% plotting the result

figure
ax1 = subplot(2,1,1);
title(ax1, 'position space');
plot(1:N, y, start:stop, y_obs(start:stop), 'x');
legend('true wave','noisy observation')
ax2 = subplot(2,1,2);
title(ax2, 'momentum space');
plot(1:N, k/norm(k), '-b', 1:N, k_naive/norm(k_naive) , 'g', 1:N, k_it/norm(k_it), '--r');
legend('true wave numbers','naive reconstruction via fft', 'sparse reconstruction')