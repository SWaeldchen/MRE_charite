function normeps = normeps_matlabtour(x, epsilon)


grad = @(x)cat(3, x-x([end 1:end-1],:), x-x(:,[end 1:end-1]));
NormEps = @(u,epsilon)sqrt(epsilon^2 + sum(u.^2,3));
u = grad(x);
normeps = NormEps(u, epsilon);
