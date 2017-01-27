function mags = lsqr_test(U, freqvec, spacing)


niters = 100;

W1 = 1;
W2 = 1;
W3 = 5;
mags = cell(2,2,3);
TWOD = 0;
fID = fopen('hodge.csv', 'w');
fprintf(fID, 'W1, W2, W3 \n');
for w1 = 1
    for w2 = 1
        for w3 = 1
                [mags{w1,w2,w3}, ~, flag, relres] = finish_from_hodge(U, freqvec, spacing, 2, niters, W1(w1), W2(w2), W3(w3), TWOD);
                fprintf(fID, '%d, %d, %d %d %0.3f \n',W1(w1), W2(w2), W3(w3), flag, relres);
        end
    end
end
