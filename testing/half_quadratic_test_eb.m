% A demo for showing the current progress with the 2+D half quadratic
% method. First a similar 1D wave with edge test signal, then a small 
% standard image to show the problems that are coming up in 2D

%set params for demo
a = .01; % I believe this is the alpha parameter in the book
b = .001; % I belive this is step size?
c = 0; % automatic

%% test 1D case

% make a 1D test signal y - wave with edge
grid = linspace(1, 3*pi, 64);
y = [sin(grid) fliplr(sin(grid(2:end)))]';
L = length(y);

% generate SR
SR = 4; % super-resolve to 4 times original size
x0 = zeros(SR*L, 1);
A = additive_sr_matrix(size(y), SR);
mxiter_1D = 100; % more than enough only takes a few iterations
[x, it, Co] = HQ_Additive(x0, y, A, 'hub', a, b, c, [], mxiter_1D);

% plot results
figure(1)
subplot(2, 2, 1); plot(y); title('Original Signal');
subplot(2, 2, 3); plot(x); title(['4XSR, iter: ',num2str(it)]);

%% test 2D case

% load a very small image
load('cameraman_ds.mat');
y = cameraman_ds;
sz = size(y);

% generate SR
SR = 2; % memory limitations of dense H1 matrix
sz_super = sz*SR;
x0 = zeros(sz_super);
A = additive_sr_matrix(sz, SR);
mxiter_2D = 10; % only iterate a few times, so you can see it is blowing up
[x, it, Co] = HQ_Additive(x0, y, A, 'hub', a, b, c, [], mxiter_2D);

%plot results
figure(1)
subplot(2, 2, 2); imshow(y, []); title('Original Image');
subplot(2, 2, 4); imshow(x, []); title(['4XSR, iter: ', num2str(it)]);