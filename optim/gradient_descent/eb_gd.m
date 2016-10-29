function y = eb_gd(x, niter, tv_weight, smoothing_param)

step_size = 4*(1.8/( 1 + tv_weight*8/smoothing_param ));
%step_size = 1;
y = x;
e = zeros(niter, 1);
for n = 1:niter
    e(n) = evaluate_objective_function(y, x, tv_weight, smoothing_param);
    diff = step_size*gradient_of_objective_function(y, x, tv_weight, smoothing_param);
    y = y - diff;
end

figure(1);
plot(e); axis tight;
figure();
imshow(y, []);

end








