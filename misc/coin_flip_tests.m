function coin_flip_tests

TESTS = 1000;
p_values = zeros(TESTS, 1);
type_1_errors = zeros(TESTS, 1);

FLIPS = 100;
flip = @(x)ceil(rand(x,1)*2);

for n = 1:TESTS
    group1 = flip(FLIPS);
    group2 = flip(FLIPS)+0.1;
    [h, p] = ttest2(group1, group2);
    p_values(n) = p;
    type_1_errors(n) = h;
end

type_1_error_rate =  round((numel(find(type_1_errors == 1))/TESTS)*100)/100;
figure(1); 
subplot(3, 1, 1); plot(p_values); title('P values');
subplot(3, 1, 2); histogram(p_values); title('Histogram of P values');
subplot(3, 1, 3); histogram(type_1_errors); 
title(['At \alpha=0.05, prob. type 1 error: ', num2str(type_1_error_rate)]);