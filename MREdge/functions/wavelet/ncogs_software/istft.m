function x = istft(X, R, N)
% Inverse short-time Fourier transform
% x = istft(X, R, N)
% Inverse of 'stft'
%
% INPUT
%   X : STFT coefficients
%   R : block length (and length of FFT)
%   N : length of signal
%
% OUTPUT
%   x : time-domain signal

n = (1:R) - 0.5;
win = sqrt(R)*sin(pi*n/R);

M = size(X, 2);
x = zeros(1, R/2*(M+1));
% X = ifft(X, R, 2);
X = ifft(X);
i = 0;
for m = 1:M
    x(i+(1:R)) = x(i+(1:R)) + win .* X(:, m).';
    i = i + R/2;
end
x = x(R/2+(1:N));

% Ivan Selesnick
% selesi@poly.edu

