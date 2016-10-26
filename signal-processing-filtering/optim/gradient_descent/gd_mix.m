function gd_mix(x, niter, lambda, epsilon)

%step_size = 1.8/( 1 + tv_weight*8/smoothing_param );
y_eb = x;
y_tour = x;
e_eb = zeros(niter, 1);
e_tour = zeros(niter, 1);

grad = @(x)cat(3, x-x([end 1:end-1],:), x-x(:,[end 1:end-1]));
div = @(v)v([2:end 1],:,1)-v(:,:,1) + v(:,[2:end 1],2)-v(:,:,2);

NormEps = @(u,epsilon)sqrt(epsilon^2 + sum(u.^2,3));
Normalize = @(u,epsilon)u./repmat(NormEps(u,epsilon), [1 1 2]);
GradJ = @(x,epsilon)-div( Normalize(grad(x),epsilon) );
Gradf = @(y,x,epsilon)x-y+lambda*GradJ(x,epsilon);
J = @(x,epsilon)sum(sum(NormEps(grad(x),epsilon)));
f = @(y,x,epsilon)1/2*norm(x-y,'fro')^2 + lambda*J(x,epsilon);
tau = 1.8/( 1 + lambda*8/epsilon );
tau = tau*4;

for n = 1:niter
    e_eb(n) = evaluate_objective_function(y_eb, x, lambda, epsilon);
    e_tour(n) = f(x,y_tour,epsilon);
    diff_eb = tau*gradient_of_objective_function(y_eb, x, lambda, epsilon);
    diff_tour = tau*Gradf(x,y_tour,epsilon);
    y_tour = y_tour - diff_tour;
    y_eb = y_eb - diff_eb;
end

figure(1);
subplot(2, 1, 1); plot(e_eb); axis tight;
subplot(2, 1, 2); plot(e_tour); axis tight;
figure(2);
subplot(2, 1, 1); imshow(y_eb, []);
subplot(2, 1, 2); imshow(y_tour, []);

end








