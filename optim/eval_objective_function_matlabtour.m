function y = eval_objective_function_matlabtour(y, x, epsilon, lambda)
grad = @(x)cat(3, x-x([end 1:end-1],:), x-x(:,[end 1:end-1]));
NormEps = @(u,epsilon)sqrt(epsilon^2 + sum(u.^2,3));
J = @(x,epsilon)sum(sum(NormEps(grad(x),epsilon)));
f = @(y,x,epsilon)1/2*norm(x-y,'fro')^2 + lambda*J(x,epsilon);
y = f(y, x, epsilon);