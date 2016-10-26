function springpot_comparison

wvec = ([25 37.5 50 62.5]*2*pi)';

% TEST DATA 1 - PERFECT ANALYTIC

mu_ = 3000; alpha_ = 0.6; eta = 5;
G_analytic = mu_^(1-alpha_)*eta^alpha_*(1i*wvec).^alpha_;

% TEST DATA 2 - IN VIVO SINGLE VOXEL

G_invivo = 1000*[0.4754 + 1i*0.3884; 2.4939 + 1i*1.0347; ...
    2.6670 + 1i*2.8198; 3.034 + 1i*4.1278];

%% MATRIX METHOD
m = length(wvec);
v = log(wvec);
S = sum(v);
A(1,1) = sum(v.^2);
A(2,1) = S;
A(1,2) = S;
A(2,2) = m;

% ANALYTIC
Z = log(abs(G_analytic));
b(1,1) = sum(Z.*v);
b(2,1) = sum(Z);
x = A\b;

alpha = x(1);
mu1 = (1i*wvec).^alpha; mu2 = eta.^alpha; mu3 = G_analytic ./ (mu1.*mu2);
mu = round(mu3.^(1/(1-alpha)));

display(['Matrix method, analytic data: alpha ', num2str(alpha), ' mu ', ...
    num2str(mu(1))]);

% IN VIVO

Z = log(abs(G_invivo));
b(1,1) = sum(Z.*v);
b(2,1) = sum(Z);
x = A\b;

alpha = x(1);
mu1 = (1i*wvec).^alpha; mu2 = eta.^alpha; mu3 = G_invivo ./ (mu1.*mu2);
mu = round(mu3.^(1/(1-alpha)));

display(['Matrix method, in vivo data: alpha ', num2str(alpha), ' mu ', ...
    num2str(mu(1))]);

%% BRUTE FORCE METHOD

muRange = 100:100:20000;
alphaRange = 0.2: 0.01: 0.8;
[mu, alpha, omega] = ndgrid(muRange, alphaRange, wvec);

% ANALYTIC
[~, ~, Gobs] = ndgrid(muRange, alphaRange, G_analytic);
Gmod = mu.^(1-alpha) .* eta.^(alpha) .* (1i*omega).^alpha;
delta = sqrt(sum(  abs(Gmod - Gobs).^2, 3   ));
[~, index] = min(delta(:));
optAlpha = alpha(index);
optMu = mu(index);
display(['Brute force method, analytic data: alpha ', num2str(optAlpha), ' mu ', ...
    num2str(optMu)]);

% IN VIVO
[~, ~, Gobs] = ndgrid(muRange, alphaRange, G_invivo);
Gmod = mu.^(1-alpha) .* eta.^(alpha) .* (1i*omega).^alpha;
delta = sqrt(sum(  abs(Gmod - Gobs).^2, 3   ));
[~, index] = min(delta(:));
optAlpha = alpha(index);
optMu = mu(index);
display(['Brute force method, in vivo data: alpha ', num2str(optAlpha), ' mu ', ...
    num2str(optMu)]);

