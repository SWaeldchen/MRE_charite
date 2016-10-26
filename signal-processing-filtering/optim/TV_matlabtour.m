function y = TV_matlabtour(x, epsilon)
grad = @(x)cat(3, x-x([end 1:end-1],:), x-x(:,[end 1:end-1]));
NormEps = @(u,epsilon)sqrt(epsilon^2 + sum(u.^2,3));
J = @(x,epsilon)sum(sum(NormEps(grad(x),epsilon)));
y = J(x, epsilon);