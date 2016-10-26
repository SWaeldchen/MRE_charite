function g = grad_obj_fun_matlabtour(x, y, lambda, epsilon)

grad = @(x)cat(3, x-x([end 1:end-1],:), x-x(:,[end 1:end-1]));
div = @(v)v([2:end 1],:,1)-v(:,:,1) + v(:,[2:end 1],2)-v(:,:,2);
NormEps = @(u,epsilon)sqrt(epsilon^2 + sum(u.^2,3));
Normalize = @(u,epsilon)u./repmat(NormEps(u,epsilon), [1 1 2]);
GradJ = @(x,epsilon)-div( Normalize(grad(x),epsilon) );
Gradf = @(y,x,epsilon)x-y+lambda*GradJ(x,epsilon);
g = Gradf(y, x, epsilon);