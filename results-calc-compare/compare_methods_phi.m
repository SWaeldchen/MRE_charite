% need to first load esp_mdev_lfe_all_results
brain_means = zeros(10,2);
liver_means = zeros(10,2);
thigh_means = zeros(10,2);

brain_means(1,1) = mean(brain1Phi_MDEV(find(~isnan(zero_to_nan(brain1Phi_MDEV(:).*brain1_binmask(:))))));
brain_means(2,1) = mean(brain2Phi_MDEV(find(~isnan(zero_to_nan(brain2Phi_MDEV(:).*brain2_binmask(:))))));
brain_means(3,1) = mean(brain3Phi_MDEV(find(~isnan(zero_to_nan(brain3Phi_MDEV(:).*brain3_binmask(:))))));
brain_means(4,1) = mean(brain4Phi_MDEV(find(~isnan(zero_to_nan(brain4Phi_MDEV(:).*brain4_binmask(:))))));
brain_means(5,1) = mean(brain5Phi_MDEV(find(~isnan(zero_to_nan(brain5Phi_MDEV(:).*brain5_binmask(:))))));
brain_means(6,1) = mean(brain6Phi_MDEV(find(~isnan(zero_to_nan(brain6Phi_MDEV(:).*brain6_binmask(:))))));
brain_means(7,1) = mean(brain7Phi_MDEV(find(~isnan(zero_to_nan(brain7Phi_MDEV(:).*brain7_binmask(:))))));
brain_means(8,1) = mean(brain8Phi_MDEV(find(~isnan(zero_to_nan(brain8Phi_MDEV(:).*brain8_binmask(:))))));
brain_means(9,1) = mean(brain9Phi_MDEV(find(~isnan(zero_to_nan(brain9Phi_MDEV(:).*brain9_binmask(:))))));
brain_means(10,1) = mean(brain10Phi_MDEV(find(~isnan(zero_to_nan(brain10Phi_MDEV(:).*brain10_binmask(:))))));

brain_means(1,2) = mean(brain1Phi_esp(find(~isnan(zero_to_nan(brain1Phi_esp(:).*brain1_binmask(:))))));
brain_means(2,2) = mean(brain2Phi_esp(find(~isnan(zero_to_nan(brain2Phi_esp(:).*brain2_binmask(:))))));
brain_means(3,2) = mean(brain3Phi_esp(find(~isnan(zero_to_nan(brain3Phi_esp(:).*brain3_binmask(:))))));
brain_means(4,2) = mean(brain4Phi_esp(find(~isnan(zero_to_nan(brain4Phi_esp(:).*brain4_binmask(:))))));
brain_means(5,2) = mean(brain5Phi_esp(find(~isnan(zero_to_nan(brain5Phi_esp(:).*brain5_binmask(:))))));
brain_means(6,2) = mean(brain6Phi_esp(find(~isnan(zero_to_nan(brain6Phi_esp(:).*brain6_binmask(:))))));
brain_means(7,2) = mean(brain7Phi_esp(find(~isnan(zero_to_nan(brain7Phi_esp(:).*brain7_binmask(:))))));
brain_means(8,2) = mean(brain8Phi_esp(find(~isnan(zero_to_nan(brain8Phi_esp(:).*brain8_binmask(:))))));
brain_means(9,2) = mean(brain9Phi_esp(find(~isnan(zero_to_nan(brain9Phi_esp(:).*brain9_binmask(:))))));
brain_means(10,2) = mean(brain10Phi_esp(find(~isnan(zero_to_nan(brain10Phi_esp(:).*brain10_binmask(:))))));

thigh_means(1,1) = mean(thigh1Phi_MDEV(find(~isnan(zero_to_nan(thigh1Phi_MDEV(:).*thigh1_binmask(:))))));
thigh_means(2,1) = mean(thigh2Phi_MDEV(find(~isnan(zero_to_nan(thigh2Phi_MDEV(:).*thigh2_binmask(:))))));
thigh_means(3,1) = mean(thigh3Phi_MDEV(find(~isnan(zero_to_nan(thigh3Phi_MDEV(:).*thigh3_binmask(:))))));
thigh_means(4,1) = mean(thigh4Phi_MDEV(find(~isnan(zero_to_nan(thigh4Phi_MDEV(:).*thigh4_binmask(:))))));
thigh_means(5,1) = mean(thigh5Phi_MDEV(find(~isnan(zero_to_nan(thigh5Phi_MDEV(:).*thigh5_binmask(:))))));
thigh_means(6,1) = mean(thigh6Phi_MDEV(find(~isnan(zero_to_nan(thigh6Phi_MDEV(:).*thigh6_binmask(:))))));
thigh_means(7,1) = mean(thigh7Phi_MDEV(find(~isnan(zero_to_nan(thigh7Phi_MDEV(:).*thigh7_binmask(:))))));
thigh_means(8,1) = mean(thigh8Phi_MDEV(find(~isnan(zero_to_nan(thigh8Phi_MDEV(:).*thigh8_binmask(:))))));
thigh_means(9,1) = mean(thigh9Phi_MDEV(find(~isnan(zero_to_nan(thigh9Phi_MDEV(:).*thigh9_binmask(:))))));
thigh_means(10,1) = mean(thigh10Phi_MDEV(find(~isnan(zero_to_nan(thigh10Phi_MDEV(:).*thigh10_binmask(:))))));

thigh_means(1,2) = mean(thigh1Phi_esp(find(~isnan(zero_to_nan(thigh1Phi_esp(:).*thigh1_binmask(:))))));
thigh_means(2,2) = mean(thigh2Phi_esp(find(~isnan(zero_to_nan(thigh2Phi_esp(:).*thigh2_binmask(:))))));
thigh_means(3,2) = mean(thigh3Phi_esp(find(~isnan(zero_to_nan(thigh3Phi_esp(:).*thigh3_binmask(:))))));
thigh_means(4,2) = mean(thigh4Phi_esp(find(~isnan(zero_to_nan(thigh4Phi_esp(:).*thigh4_binmask(:))))));
thigh_means(5,2) = mean(thigh5Phi_esp(find(~isnan(zero_to_nan(thigh5Phi_esp(:).*thigh5_binmask(:))))));
thigh_means(6,2) = mean(thigh6Phi_esp(find(~isnan(zero_to_nan(thigh6Phi_esp(:).*thigh6_binmask(:))))));
thigh_means(7,2) = mean(thigh7Phi_esp(find(~isnan(zero_to_nan(thigh7Phi_esp(:).*thigh7_binmask(:))))));
thigh_means(8,2) = mean(thigh8Phi_esp(find(~isnan(zero_to_nan(thigh8Phi_esp(:).*thigh8_binmask(:))))));
thigh_means(9,2) = mean(thigh9Phi_esp(find(~isnan(zero_to_nan(thigh9Phi_esp(:).*thigh9_binmask(:))))));
thigh_means(10,2) = mean(thigh10Phi_esp(find(~isnan(zero_to_nan(thigh10Phi_esp(:).*thigh10_binmask(:))))));

liver_means(1,1) = mean(liver1Phi_MDEV(find(~isnan(zero_to_nan(liver1Phi_MDEV(:).*liver1_binmask(:))))));
liver_means(2,1) = mean(liver2Phi_MDEV(find(~isnan(zero_to_nan(liver2Phi_MDEV(:).*liver2_binmask(:))))));
liver_means(3,1) = mean(liver3Phi_MDEV(find(~isnan(zero_to_nan(liver3Phi_MDEV(:).*liver3_binmask(:))))));
liver_means(4,1) = mean(liver4Phi_MDEV(find(~isnan(zero_to_nan(liver4Phi_MDEV(:).*liver4_binmask(:))))));
liver_means(5,1) = mean(liver5Phi_MDEV(find(~isnan(zero_to_nan(liver5Phi_MDEV(:).*liver5_binmask(:))))));
liver_means(6,1) = mean(liver6Phi_MDEV(find(~isnan(zero_to_nan(liver6Phi_MDEV(:).*liver6_binmask(:))))));
liver_means(7,1) = mean(liver7Phi_MDEV(find(~isnan(zero_to_nan(liver7Phi_MDEV(:).*liver7_binmask(:))))));
liver_means(8,1) = mean(liver8Phi_MDEV(find(~isnan(zero_to_nan(liver8Phi_MDEV(:).*liver8_binmask(:))))));
liver_means(9,1) = mean(liver9Phi_MDEV(find(~isnan(zero_to_nan(liver9Phi_MDEV(:).*liver9_binmask(:))))));
liver_means(10,1) = mean(liver10Phi_MDEV(find(~isnan(zero_to_nan(liver10Phi_MDEV(:).*liver10_binmask(:))))));

liver_means(1,2) = mean(liver1Phi_esp(find(~isnan(zero_to_nan(liver1Phi_esp(:).*liver1_binmask(:))))));
liver_means(2,2) = mean(liver2Phi_esp(find(~isnan(zero_to_nan(liver2Phi_esp(:).*liver2_binmask(:))))));
liver_means(3,2) = mean(liver3Phi_esp(find(~isnan(zero_to_nan(liver3Phi_esp(:).*liver3_binmask(:))))));
liver_means(4,2) = mean(liver4Phi_esp(find(~isnan(zero_to_nan(liver4Phi_esp(:).*liver4_binmask(:))))));
liver_means(5,2) = mean(liver5Phi_esp(find(~isnan(zero_to_nan(liver5Phi_esp(:).*liver5_binmask(:))))));
liver_means(6,2) = mean(liver6Phi_esp(find(~isnan(zero_to_nan(liver6Phi_esp(:).*liver6_binmask(:))))));
liver_means(7,2) = mean(liver7Phi_esp(find(~isnan(zero_to_nan(liver7Phi_esp(:).*liver7_binmask(:))))));
liver_means(8,2) = mean(liver8Phi_esp(find(~isnan(zero_to_nan(liver8Phi_esp(:).*liver8_binmask(:))))));
liver_means(9,2) = mean(liver9Phi_esp(find(~isnan(zero_to_nan(liver9Phi_esp(:).*liver9_binmask(:))))));
liver_means(10,2) = mean(liver10Phi_esp(find(~isnan(zero_to_nan(liver10Phi_esp(:).*liver10_binmask(:)))))); %#ok<*FNDSB>


b = figure('position', [0 0 480 480], 'Color', [1 1 1]); plot(brain_means, 'linewidth', 2);xlabel('Subj.', 'FontSize', 14); ylabel('$\phi~(Rad)$', 'Interpreter', 'LaTeX','FontSize', 24);
xlim([1 10]); ylim([0.5 1]); set(gca, 'FontSize', 14, 'YTick', [0.5 0.75 1], 'XTick', 1:10); 
export_fig brain-phi-means -eps
l = figure('position', [0 0 480 480], 'Color', [1 1 1]); plot(liver_means, 'linewidth', 2);xlabel('Subj.', 'FontSize', 14); ylabel('$\phi~(Rad)$', 'Interpreter', 'LaTeX','FontSize', 24);
xlim([1 10]); ylim([0.5 1]); set(gca, 'FontSize', 14, 'YTick', [0.5 0.75 1], 'XTick', 1:10); 
export_fig liver-phi-means -eps
t = figure('position', [0 0 480 480], 'Color', [1 1 1]); plot(thigh_means, 'linewidth', 2);xlabel('Subj.', 'FontSize', 14); ylabel('$\phi~(Rad)$', 'Interpreter', 'LaTeX','FontSize', 24);
xlim([1 10]); ylim([0.5 1]);set(gca, 'FontSize', 14, 'YTick', [0.5 0.75 1], 'XTick', 1:10); 
export_fig thigh-phi-means -eps
%legend('MDEV', 'ESP', 'LFE');  
braincorrs = [corr(brain_means(:,1), brain_means(:,2))];
livercorrs = [corr(liver_means(:,1), liver_means(:,2))];
thighcorrs = [corr(thigh_means(:,1), thigh_means(:,2))];
corrs = [braincorrs; livercorrs; thighcorrs];


