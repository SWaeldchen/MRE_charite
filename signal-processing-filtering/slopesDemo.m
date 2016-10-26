freqs = [300 400 500 600];
alpha = 0.25;
% DEMO 1
mu = [3000];
eta = [3];
figure();
hold on;
medians = zeros(numel(eta),1);
for m = 1:numel(eta)
    
    %for n = 1:numel(mu)
        [vals] = makeSpringPotVals(alpha, mu(1), eta, freqs);
        [mus, etas] = springpot_slope_test(real(vals), imag(vals), freqs, alpha);
        logmus = log(mus);
        logetas = log(etas);
        plot(logmus, logetas);
        gradientEstimate = median(gradient(logetas) ./ gradient(logmus));
        if (abs(gradientEstimate)>0.1)
            display(gradientEstimate); 
        end
        medians(m) = median(logetas);
    %end
   
end
 hold off;
