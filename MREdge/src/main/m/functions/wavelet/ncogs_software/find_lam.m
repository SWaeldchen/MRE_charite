function lam0 = find_lam( s, pen, realcompl, K1, K2, Nit)

% lam0 = find_lam( s, pen, realcompl, K1, K2, Nit)
%
% Provides the lam for a given desired output standard deviation
% for 25 iterations of OGS.
%
% Input:
%        s : desired std
%        pen = 'abs', 'log', 'atan'
%        realcompl = 'real', 'complex'
%        K1, K2: group size
% Output: 
%        lam0: estimated lambda
%
% Po-Yu Chen and Ivan Selesnick
% August 2013

% K1_v = [1 1 1 1 1 2 2 2 2 3 3 3 4 4 5 2];
% K2_v = [1 2 3 4 5 2 3 4 5 3 4 5 4 5 5 8];

if K1 > K2
    temp = K1;
    K1 = K2;
    K2 = temp;
end


if     (K1 == 1 && K2 == 1)
    i = 1;
elseif (K1 == 1 && K2 == 2)
    i = 2;
elseif (K1 == 1 && K2 == 3)
    i = 3;
elseif (K1 == 1 && K2 == 4)
    i = 4;
elseif (K1 == 1 && K2 == 5)
    i = 5;
elseif (K1 == 2 && K2 == 2)
    i = 6;
elseif (K1 == 2 && K2 == 3)
    i = 7;
elseif (K1 == 2 && K2 == 4)
    i = 8;
elseif (K1 == 2 && K2 == 5)
    i = 9;
elseif (K1 == 3 && K2 == 3)
    i = 10;
elseif (K1 == 3 && K2 == 4)
    i = 11;
elseif (K1 == 3 && K2 == 5)
    i = 12;
elseif (K1 == 4 && K2 == 4)
    i = 13;
elseif (K1 == 4 && K2 == 5)
    i = 14;
elseif (K1 == 5 && K2 == 5)
    i = 15;
elseif (K1 == 2 && K2 == 8)
    i = 16;
else
    fprintf('No data')
    return
end

Nit = 25;

% txt_lam = sprintf('./lambda_data/lam_%s_%s_Nit_%2d.txt', pen, realcompl, Nit);
% txt_std = sprintf('./lambda_data/std_%s_%s_Nit_%2d.txt', pen, realcompl, Nit);

txt_lam = sprintf('lambda_data/lam_%s_%s_Nit_%2d.txt', pen, realcompl, Nit);
txt_std = sprintf('lambda_data/std_%s_%s_Nit_%2d.txt', pen, realcompl, Nit);

Lam = load(txt_lam);
lam = Lam(:, 3:end);

STD = load(txt_std);
std_v = STD(:, 3:end);    
    

if s < min(std_v(i, :))
    x1 = lam(i, end-1);
    x2 = lam(i, end);
    z1 = log(std_v(i, end-1));
    z2 = log(std_v(i, end));
    m = (x2-x1)/(z2-z1);
    lam0 = x1 + m*(log(s)-z1);
    lam_v1 = [lam(i, :) lam0];
    std_v1 = [std_v(i, :) s];
else
    lam0 = interp1(log(std_v(i, :)), lam(i, :), log(s));
    lam_v1 = lam(i, :);
    std_v1 = std_v(i, :);
end


% figure

h = semilogx(std_v1, lam_v1, 'sk', s, lam0, 'ro', std_v1, lam_v1, 'k');

% semilogx(std_v1, lam_v1, '.-k', s, lam0, 'ro');

legend('Samples', 'Interpolation');
xlabel('Standard deviation')
ylabel('\lambda')
xlim(std_v1([end 1]).* [0.7 1.3]);

shg



