function y = sfb2D_A_u(lo, hi, j, g0, g1, d)

% 2D Synthesis Filter Bank
% (along single dimension only)
%
% y = sfb2D_A(lo, hi, sf, d);
% sf - synthesis filters
% d  - dimension of filtering
% see afb2D_A


if d == 2
   lo = lo';
   hi = hi';
end

R = sqrt(2);
g0 = g0/R;
g1 = g1/R;

N0 = length(g0);
N1 = length(g1);
N = N0 + N1;

sz0 = size(lo);
L0 = sz0(2);
sz1 = size(hi);
L1 = sz1(2);

M = 2^(j-1);

y0 = zeros(sz0(1),L0+M*(N0-1));
y1 = zeros(sz1(1),L1+M*(N1-1));

for k = 0:N0-1
    y0(:,M*k+(1:L0)) = y0(:,M*k+(1:L0)) + g0(k+1)*lo;
end

for k = 0:N1-1
    y1(:,M*k+(1:L1)) = y1(:,M*k+(1:L1)) + g1(k+1)*hi;
end

% Add signals (make sure they are equal length).
% We assume 'lo' is longer than 'hi' because
% in a wavelet transform the lo/hi split is
% iterated on the 'lo' signal which increases its length.
y = y0(:, 1:size(y1, 2));
y(1:size(y1,1), 1:size(y1,2)) = y(1:size(y1,1), 1:size(y1,2)) + y1;

L = M*(N/2-1);
y = y(:, L+1:end);



if d == 2
   y = y';
end


