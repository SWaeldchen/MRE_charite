function [cine] = make_quick_cine()

cine = zeros(8, 512);
expVec = exp(-(1:512)/256);
for n = 1:8
    a = sinVec(512, 256, n*64);
    cine(n,:) = a .* expVec;
end
figure(); plot(1:512, cine');
legend('T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8');
xlim([0 512]);
xlabel('Location');
