function y = tv_cvx_eb(x)
x = double(x);
sz = size(x);
x_vec = x(:);
x_numel = numel(x);
dft_matrix = dftmtx(x_numel);
cvx_begin
    variable x_rec(sz(1), sz(2))
    minimize(norm(x_rec-x))
    subject to
        norm(x_rec-x_rec([end 1:end-1],:),1) + norm(x_rec-x_rec(:,[end 1:end-1]),1) <= 10;
        dft_matrix*
cvx_end
y = x_rec;

figure(1);
set(gcf, 'Name', 'TV CVX EB');
subplot(1, 3, 1); imshow(x, []);
subplot(1, 3, 2); imshow(y, []);
subplot(1, 3, 3); imshow(y - x, []);
impixelinfo