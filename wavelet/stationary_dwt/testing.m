%% TESTING MODULE
[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;
[h0, h1, g0, g1] = daubf(3);

lena = double(imread('lena.tif'));
brain = load('brain');
brain = brain.brain;

%% 2D uDWT
disp('Testing 2D uDWT...');
tic
lena_udwt = iudwt2D(udwt2D(lena, 3, h0, h1), 3, g0, g1);
rmse = norm(lena_udwt(:) - lena(:)) / numel(brain(:));
disp(['RMSE: ', num2str(rmse)]);
toc
disp('--');

%% 2D uCDDWT
disp('Testing 2D uCDDWT...');
tic
lena_ucddwt = icplxdual2D_u(cplxdual2D_u(lena, 3, Faf, af), 3, Fsf, sf);
rmse = norm(lena_ucddwt(:) - lena(:)) / numel(brain(:));
disp(['RMSE: ', num2str(rmse)]);
toc
disp('--');

%% 3D uDWT
disp('Testing 3D uDWT...');
tic
brain_udwt = iudwt3D(udwt3D(brain, 3, h0, h1), 3, g0, g1);
rmse = norm(brain_udwt(:) - brain(:)) / numel(brain(:));
disp(['RMSE: ', num2str(rmse)]);
toc
disp('--');


%% 3D uCDDWT
disp('Testing 3D uCDDWT...');
tic
brain_ucddwt = icplxdual3D_u(cplxdual3D_u(brain, 3, Faf, af), 3, Fsf, sf);
rmse = norm(brain_ucddwt(:) - brain(:)) / numel(brain(:));
disp(['RMSE: ', num2str(rmse)]);
toc
disp('--')
