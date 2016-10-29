function mat_tour_gd

n = 256;
lena = load('lena512.mat');
lena = lena.lena512;
x0 = lena / (max(lena(:)) - min(lena(:)));
sigma = .1;
y = x0 + randn(size(lena))*sigma;
grad = @(x)cat(3, x-x([end 1:end-1],:), x-x(:,[end 1:end-1]));
div = @(v)v([2:end 1],:,1)-v(:,:,1) + v(:,[2:end 1],2)-v(:,:,2);
delta = @(x)div(grad(x));
niter = 500;
lambda = 0.1;
epsilon = 1e-3;
NormEps = @(u,epsilon)sqrt(epsilon^2 + sum(u.^2,3));
Normalize = @(u,epsilon)u./repmat(NormEps(u,epsilon), [1 1 2]);
GradJ = @(x,epsilon)-div( Normalize(grad(x),epsilon) );
Gradf = @(y,x,epsilon)x-y+lambda*GradJ(x,epsilon);
J = @(x,epsilon)sum(sum(NormEps(grad(x),epsilon)));
f = @(y,x,epsilon)1/2*norm(x-y,'fro')^2 + lambda*J(x,epsilon);
tau = 1.8/( 1 + lambda*8/epsilon );
tau = tau*4;
x = y;
E = [];
for i=1:niter
    E(end+1) = f(y,x,epsilon); %#ok<AGROW>
    x = x - tau*Gradf(y,x,epsilon);
end
figure(1);
h = plot(E);
min(E(:))
ylim([0 2000]);
set(h, 'LineWidth', 2);
figure(2);
imshow(x, []);