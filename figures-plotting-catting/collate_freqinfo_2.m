means = zeros(120,4);
stds = zeros(120,4);
er = zeros(30,4);
ent = zeros(30,4);
rer = zeros(30,4);
rent = zeros(30,4);
er_std = zeros(30,4);
ent_std = zeros(30,4);
rer_std = zeros(30,4);
rent_std = zeros(30,4);
for n = 1:120
for p = 1:4
    temp = freqinfo{n,p};
    sz = size(temp);
    display([num2str(n), ' has ySize ', num2str(sz(1))]);
	if (n >= 1 && n <= 10) || (n >= 31 && n <= 40) || (n >= 61 && n <= 70) || (n >= 91 && n <= 100)
    	map = temp(indices_brain);
	elseif (n >= 11 && n <= 20) || (n >= 41 && n <= 50) || (n >= 71 && n <= 90) || (n >= 101 && n <= 110)
		map = temp(indices_thigh);
	else
		map = temp(indices_liver);
	end
    means(n,p) = mean(map(:));
    stds(n,p) = std(map(:));
end
end
for n = 1:30
    er(n,1) = means(n,1);
    er(n,2) = means(n+30,1);
    er(n,3) = means(n+60,1);
    er(n,4) = means(n+90,1);
    ent(n,1) = means(n,2);
    ent(n,2) = means(n+30,2);
    ent(n,3) = means(n+60,2);
    ent(n,4) = means(n+90,2);
    rer(n,1) = means(n,3);
    rer(n,2) = means(n+30,3);
    rer(n,3) = means(n+60,3);
    rer(n,4) = means(n+90,3);
    rent(n,1) = means(n,4);
    rent(n,2) = means(n+30,4);
    rent(n,3) = means(n+60,4);
    rent(n,4) = means(n+90,4);
	er_std(n,1) = stds(n,1);
    er_std(n,2) = stds(n+30,1);
    er_std(n,3) = stds(n+60,1);
    er_std(n,4) = stds(n+90,1);
    ent_std(n,1) = stds(n,2);
    ent_std(n,2) = stds(n+30,2);
    ent_std(n,3) = stds(n+60,2);
    ent_std(n,4) = stds(n+90,2);
    rer_std(n,1) = stds(n,3);
    rer_std(n,2) = stds(n+30,3);
    rer_std(n,3) = stds(n+60,3);
    rer_std(n,4) = stds(n+90,3);
    rent_std(n,1) = stds(n,4);
    rent_std(n,2) = stds(n+30,4);
    rent_std(n,3) = stds(n+60,4);
    rent_std(n,4) = stds(n+90,4);
end
leg_entries = {'ESP', 'ESP', 'MDEV', 'MDEV'};
size(er)
size(er_std)
figure('Color', 'w')
subplot(2,1,1); hold on; plot(1:30, rer(:,1), 'b', 'LineWidth', 3); plot(1:30, rer(:,3), 'g', 'LineWidth', 3); errorbar(1:30, rer(:,1), rer_std(:,1), 'b'); errorbar(1:30, rer(:,3), rer_std(:,3), 'g');  legend(leg_entries([1,3])); [h_mag t_mag] = ttest(rer(:,1), rer(:,3)); title('RER $|G^{*}|~(p < 1 \times 10^{-9})$', 'Interpreter', 'LaTeX', 'FontWeight', 'Bold', 'FontSize', 24); ylim([0 0.02]); xlim([1 30]); ylabel('Ratio'); hold off;

subplot(2,1,2); hold on; plot(1:30, rer(:,2), 'b', 'LineWidth', 3); plot(1:30, rer(:,4), 'g', 'LineWidth', 3); errorbar(1:30, rer(:,2), rer_std(:,2), 'b'); errorbar(1:30, rer(:,4), rer_std(:,4), 'g'); legend(leg_entries([2,4])); [h_phi t_phi] = ttest(rer(:,2), rer(:,4)); title('RER $\phi~(p < 1 \times 10^{-3})$', 'Interpreter', 'LaTeX', 'FontWeight', 'Bold', 'FontSize', 24); ylim([0 0.04]); xlim([1 30]); ylabel('Ratio'); hold off

