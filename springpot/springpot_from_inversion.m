function [alpha, mu]=springpot_from_inversion(LSQ_inv, freqs)

if (nargin == 0) %TEST DATA
    mu = 3.9; alf = 0.6; eta = 2.7;
    om = [30 40 50 60 70]*pi*2;
    Gvec = mu^(1-alf)*eta^alf*(1i*om).^alf;
    Gvec = mu.^(1-alf).*(1i*wvec).^alf;
    Gvec_4 = ones(1, 1, 1, 4);
    Gvec_4(1,1,1,1:4) = Gvec;
    Gvec = Gvec_4;
    LSQ_inv = repmat(Gvec, [32, 32, 4]);
else
    om = freqs*2*pi;
end
eta = 1;
sz = size(LSQ_inv);
total_voxels = sz(1)*sz(2)*sz(3);
G_vecs = reshape(LSQ_inv, total_voxels, sz(4));
G_log = log(abs(G_vecs));
f_log = log(om);
f_sum = sum(f_log);
f_sumsq = sum(f_log.^2);
f_num = numel(f_log);
block = [f_sumsq, f_sum; f_sum, f_num];

f_logs = repmat(f_log, [total_voxels, 1]);
oms = repmat(om, [total_voxels, 1]);

A = kron(speye(total_voxels), block);
b = zeros(total_voxels*2, 1);
b(1:2:end,1) = sum(G_log.*f_logs,2);
b(2:2:end,1) = sum(G_log,2);

x = A\b;
alpha = x(1:2:end,1);
alphas = repmat(alpha, [1 f_num]);
alpha = reshape(alpha, sz(1), sz(2), sz(3));
muvec = (  G_vecs ./ ( (eta.^alphas).*(1i*oms).^alphas )  ).^( 1./(1-alphas) );
mu = reshape(muvec(:,1), sz(1), sz(2), sz(3));