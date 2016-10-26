%% demo_PR1
% Verify perfect reconstruction property

%% Get wavelet filters

K = 3; 
[h0, h1, g0, g1] = daubechies_filters(K);

%% Verify perfect reconstruction property

N = 779;
x = rand(1, N);             % x : signal of length N
J = 5;                      % J : number of levels of wavelet transform
w = dwt(x, J, h0, h1);      % w : wavelet coefficients
y = idwt(w, J, g0, g1);     % y : reconstructed signal
y = y(1:N);                 % truncate signal to original length
err = x - y;                % err : reconstruction eror
max(abs(err))               % verify that error is zero

