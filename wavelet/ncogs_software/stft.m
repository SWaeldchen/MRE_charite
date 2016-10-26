function X = stft(x, R)
% Short-time Fourier transform with 50% overlapping
% X = stft(x, R)
%
% INPUT
%   x : time-domain signal
%   R : block length (is also length of FFT)
% Note: R must be even
%
% OUTPUT
%   X : STFT coefficients
%
% % Example
% N = 500;
% x = exp(sqrt(-1)*0.002*(1:N).^2);
% R = 64;
% X = stft(x, R);
% y = istft(X, R, N);
% max(abs(x - y))           % verify perfect reconstruction property
% figure(1), clf
% imagesc([0 N], [-0.5 0.5], fftshift(abs(X), 1))
% axis xy
% xlim([0 N])
% ylim([-0.5 0.5])
% xlabel('Time')
% ylabel('Frequency')

n = (1:R) - 0.5;
win = sin(pi*n/R)/sqrt(R);              % win : window

x = x(:).';                             % ensure x is row vector
N = length(x);
L = ceil(2*N/R)*R/2;
x = [zeros(1,R/2) x zeros(1,L-N+R/2)];
M = 2*L/R + 1;                          % M : number of blocks

X = zeros(R, M);
for m = 1:M                             % m : block index
    X(:, m) = win .* x((m-1)*R/2+(1:R));
end
X = fft(X);

% Note: the loop can be replaced with 'bsxfun', but it is not available
% in all versions of Matlab.  X = bsxfun(@times, X, win');


% Ivan Selesnick
% selesi@poly.edu

