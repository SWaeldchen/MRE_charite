function y = tik_lsq(x, lam)

fidel = speye(numel(x));
lam1 = fidel;
lam1(2:end,:) = lam1(2:end,:) -fidel(1:end-1,:);
lam1 = lam1 * lam;

lam2 = fidel;
lam2(size(x,1)+1:end,:) = lam2(size(x,1)+1:end,:)-fidel(1:(end-size(x,1)),:);
lam2 = lam2 * lam;

A = [fidel; lam1; lam2];
x_pad = [x(:); zeros(size(A,1) - numel(x(:)),1)];
y = A \ x_pad;

y = reshape(y, size(x));