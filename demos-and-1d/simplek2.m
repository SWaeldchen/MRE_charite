function simplek2

set(0, 'defaultLineLineWidth', 3);
testvec = [1 1 1 1 1 2 2 2 2 1 1 1 1];
testvec = cumsum(testvec)*pi/8;
n = numel(testvec);
sf = 16;
teste = exp(1i*testvec);
testangle = unwrap(angle(teste))
testpg = conv(testangle, [1 -1], 'same')
testlap = lap(teste);
testabslap = abs(testlap)
testres = abs(sqrt( - testlap ./ teste ))
testinterp = interp1(1:n, teste, 1:(1/sf):n,'cubic');
testinterplap = interp1(1:n, testlap, 1:(1/sf):n,'cubic');
testinterpres = abs(sqrt(-testinterplap ./ testinterp));
[b,a] = butter(4, 0.25);
testinterp2 = filter(b, a, testinterp);
testinterplap2 = filter(b,a,testinterplap);
testinterpres2 = abs(sqrt(-testinterplap2 ./ testinterp2));
valid = 2:9
validinterp = [9:numel(testinterp)-4];
figure(3); 
subplot(4, 1, 1); plot(real(teste)); hold on; plot(imag(teste), 'r'); hold off; xlim([3 n-2]); title('Complex Wave', 'FontSize', 24);
set(gca, 'xtick', [], 'ytick', [-1 1]);
subplot(4, 1, 2); plot(testpg, 'k'); ylim([0 1]); xlim([3 n-2]); title('k_{pg}', 'FontSize', 24);
set(gca, 'xtick', [], 'ytick', [0 1]);
subplot(4, 1, 3); plot(testres, 'k'); ylim([0 1]); xlim([3 n-2]); title('k_{or}', 'FontSize', 24); 
set(gca, 'xtick', [], 'ytick', [0 1]);
subplot(4, 1, 4); plot(testinterpres, 'k'); ylim([0 1]); xlim([sf*2 n*sf-sf*2]); title('k_{sr}', 'FontSize', 24);
set(gca, 'xtick', [], 'ytick', [0 1]);
