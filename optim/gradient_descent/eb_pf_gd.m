function y = eb_pf_gd(x, niter, lambda, epsilon)

%Denoising with relaxed partial Fourier equality constraint

step_size = 4*(1.8/( 1 + lambda*8/epsilon ));
%step_size = 1;
y = x;
e = zeros(niter, 1);
for n = 1:niter
    e(n) = evaluate_objective_function(y, x, lambda, epsilon);
    diff = step_size*gradient_of_objective_function(y, x, lambda, epsilon);
    y = y - diff;
end

figure(1);
plot(e); axis tight;
figure(2);
imshow(y, []);

end








