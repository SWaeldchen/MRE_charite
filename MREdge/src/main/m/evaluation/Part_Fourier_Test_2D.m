
% Orts-Dimension
l_x = 201;
l_y = 201;

% frequencies in the wave

k_x = [5, -5, 6, -6] + +ceil(l_x/2); %[1; -2; 10];
k_y = [4, -4, 3, -3] + ceil(l_y/2); %[4; 3; -2];
k_val = [1, 1,1, 1]; %[1, 1, 1];

k_mat = sparse(k_x, k_y, k_val, l_x, l_y, 4);

% spy(k_mat)
% return

% Indicator function of the observed space

obs_x = [4, 45];
obs_y = [12, 62];

I = zeros(l_x, l_y);
I(obs_x(1):obs_x(2), obs_y(1):obs_y(2)) = 1;
%I = diag(I(:));

% Our observation with noise
y = real(fft2(full(flip_for_fft(k_mat, "for"))));

% imagesc(y)
% return

y_obs = I.*(y + randn(l_x,l_y)/5);
% 
% imagesc(y_obs)
% return

%Our naive inverse fourier result:
k_naive = flip_for_fft(abs(ifft2(y_obs)), "back");

% imagesc(flip_for_fft(abs(k_naive), "back"))
% return

%  Iteration settings

itSteps = 500; % Numer of steps
lambda = 0.01; % regularisation with 1-norm
t = 0.0; % thresholding
alpha = 0.5; %step size 
k_it = zeros(l_x, l_y); % starting point

for step = 1:itSteps
    
    update = real(ifft2(I.*fft2(k_it) - y_obs)) + lambda*sign(k_it);
    k_it = k_it - alpha*update;
    k_it = k_it.*(abs(k_it) >= t);
    
    norm(flip_for_fft(k_it, "back") - k_mat)
    
end

k_it = flip_for_fft(k_it, "back");


figure

ax1 = subplot(2,3,1);
imagesc(y);
ax2 = subplot(2,3,2);
imagesc(y_obs);
% ax3 = subplot(2,3,3);
% imagesc(k_it);

ax4 = subplot(2,3,4);
imagesc(k_mat);
ax5 = subplot(2,3,5);
imagesc(k_naive);
ax6 = subplot(2,3,6);
imagesc(k_it);

% plotting the result

% figure
% ax1 = subplot(2,1,1);
% title(ax1, 'position space');
% plot(1:N, y, start:stop, y_obs(start:stop), 'x');
% legend('true wave','noisy observation')
% ax2 = subplot(2,1,2);
% title(ax2, 'momentum space');
% plot(1:N, k/norm(k), '-b', 1:N, k_naive/norm(k_naive) , 'g', 1:N, k_it/norm(k_it), '--r');
% legend('true wave numbers','naive reconstruction via fft', 'sparse reconstruction')