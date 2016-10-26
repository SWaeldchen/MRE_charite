% need to first load esp_mdev_lfe_all_results
brain_means = zeros(10,3);

brain_means(1,1) = mean(brain1Mag_MDEV(find(~isnan(zero_to_nan(brain1Mag_MDEV(:).*brain1_binmask(:))))));
brain_means(2,1) = mean(brain2Mag_MDEV(find(~isnan(zero_to_nan(brain2Mag_MDEV(:).*brain2_binmask(:))))));
brain_means(3,1) = mean(brain3Mag_MDEV(find(~isnan(zero_to_nan(brain3Mag_MDEV(:).*brain3_binmask(:))))));
brain_means(4,1) = mean(brain4Mag_MDEV(find(~isnan(zero_to_nan(brain4Mag_MDEV(:).*brain4_binmask(:))))));
brain_means(5,1) = mean(brain5Mag_MDEV(find(~isnan(zero_to_nan(brain5Mag_MDEV(:).*brain5_binmask(:))))));
brain_means(6,1) = mean(brain6Mag_MDEV(find(~isnan(zero_to_nan(brain6Mag_MDEV(:).*brain6_binmask(:))))));
brain_means(7,1) = mean(brain7Mag_MDEV(find(~isnan(zero_to_nan(brain7Mag_MDEV(:).*brain7_binmask(:))))));
brain_means(8,1) = mean(brain8Mag_MDEV(find(~isnan(zero_to_nan(brain8Mag_MDEV(:).*brain8_binmask(:))))));
brain_means(9,1) = mean(brain9Mag_MDEV(find(~isnan(zero_to_nan(brain9Mag_MDEV(:).*brain9_binmask(:))))));
brain_means(10,1) = mean(brain10Mag_MDEV(find(~isnan(zero_to_nan(brain10Mag_MDEV(:).*brain10_binmask(:))))));

brain_means(1,2) = mean(brain1Mag_esp(find(~isnan(zero_to_nan(brain1Mag_esp(:).*brain1_binmask(:))))));
brain_means(2,2) = mean(brain2Mag_esp(find(~isnan(zero_to_nan(brain2Mag_esp(:).*brain2_binmask(:))))));
brain_means(3,2) = mean(brain3Mag_esp(find(~isnan(zero_to_nan(brain3Mag_esp(:).*brain3_binmask(:))))));
brain_means(4,2) = mean(brain4Mag_esp(find(~isnan(zero_to_nan(brain4Mag_esp(:).*brain4_binmask(:))))));
brain_means(5,2) = mean(brain5Mag_esp(find(~isnan(zero_to_nan(brain5Mag_esp(:).*brain5_binmask(:))))));
brain_means(6,2) = mean(brain6Mag_esp(find(~isnan(zero_to_nan(brain6Mag_esp(:).*brain6_binmask(:))))));
brain_means(7,2) = mean(brain7Mag_esp(find(~isnan(zero_to_nan(brain7Mag_esp(:).*brain7_binmask(:))))));
brain_means(8,2) = mean(brain8Mag_esp(find(~isnan(zero_to_nan(brain8Mag_esp(:).*brain8_binmask(:))))));
brain_means(9,2) = mean(brain9Mag_esp(find(~isnan(zero_to_nan(brain9Mag_esp(:).*brain9_binmask(:))))));
brain_means(10,2) = mean(brain10Mag_esp(find(~isnan(zero_to_nan(brain10Mag_esp(:).*brain10_binmask(:))))));

brain_means(1,3) = 1000*mean(brain1_lfe_vol(find(~isnan(zero_to_nan(brain1_lfe_vol(:).*brain1_binmask(:))))));
brain_means(2,3) = 1000*mean(brain2_lfe_vol(find(~isnan(zero_to_nan(brain2_lfe_vol(:).*brain2_binmask(:))))));
brain_means(3,3) = 1000*mean(brain3_lfe_vol(find(~isnan(zero_to_nan(brain3_lfe_vol(:).*brain3_binmask(:))))));
brain_means(4,3) = 1000*mean(brain4_lfe_vol(find(~isnan(zero_to_nan(brain4_lfe_vol(:).*brain4_binmask(:))))));
brain_means(5,3) = 1000*mean(brain5_lfe_vol(find(~isnan(zero_to_nan(brain5_lfe_vol(:).*brain5_binmask(:))))));
brain_means(6,3) = 1000*mean(brain6_lfe_vol(find(~isnan(zero_to_nan(brain6_lfe_vol(:).*brain6_binmask(:))))));
brain_means(7,3) = 1000*mean(brain7_lfe_vol(find(~isnan(zero_to_nan(brain7_lfe_vol(:).*brain7_binmask(:))))));
brain_means(8,3) = 1000*mean(brain8_lfe_vol(find(~isnan(zero_to_nan(brain8_lfe_vol(:).*brain8_binmask(:))))));
brain_means(9,3) = 1000*mean(brain9_lfe_vol(find(~isnan(zero_to_nan(brain9_lfe_vol(:).*brain9_binmask(:))))));
brain_means(10,3) = 1000*mean(brain10_lfe_vol(find(~isnan(zero_to_nan(brain10_lfe_vol(:).*brain10_binmask(:))))));

thigh_means(1,1) = mean(thigh1Mag_MDEV(find(~isnan(zero_to_nan(thigh1Mag_MDEV(:).*thigh1_binmask(:))))));
thigh_means(2,1) = mean(thigh2Mag_MDEV(find(~isnan(zero_to_nan(thigh2Mag_MDEV(:).*thigh2_binmask(:))))));
thigh_means(3,1) = mean(thigh3Mag_MDEV(find(~isnan(zero_to_nan(thigh3Mag_MDEV(:).*thigh3_binmask(:))))));
thigh_means(4,1) = mean(thigh4Mag_MDEV(find(~isnan(zero_to_nan(thigh4Mag_MDEV(:).*thigh4_binmask(:))))));
thigh_means(5,1) = mean(thigh5Mag_MDEV(find(~isnan(zero_to_nan(thigh5Mag_MDEV(:).*thigh5_binmask(:))))));
thigh_means(6,1) = mean(thigh6Mag_MDEV(find(~isnan(zero_to_nan(thigh6Mag_MDEV(:).*thigh6_binmask(:))))));
thigh_means(7,1) = mean(thigh7Mag_MDEV(find(~isnan(zero_to_nan(thigh7Mag_MDEV(:).*thigh7_binmask(:))))));
thigh_means(8,1) = mean(thigh8Mag_MDEV(find(~isnan(zero_to_nan(thigh8Mag_MDEV(:).*thigh8_binmask(:))))));
thigh_means(9,1) = mean(thigh9Mag_MDEV(find(~isnan(zero_to_nan(thigh9Mag_MDEV(:).*thigh9_binmask(:))))));
thigh_means(10,1) = mean(thigh10Mag_MDEV(find(~isnan(zero_to_nan(thigh10Mag_MDEV(:).*thigh10_binmask(:))))));

thigh_means(1,2) = mean(thigh1Mag_esp(find(~isnan(zero_to_nan(thigh1Mag_esp(:).*thigh1_binmask(:))))));
thigh_means(2,2) = mean(thigh2Mag_esp(find(~isnan(zero_to_nan(thigh2Mag_esp(:).*thigh2_binmask(:))))));
thigh_means(3,2) = mean(thigh3Mag_esp(find(~isnan(zero_to_nan(thigh3Mag_esp(:).*thigh3_binmask(:))))));
thigh_means(4,2) = mean(thigh4Mag_esp(find(~isnan(zero_to_nan(thigh4Mag_esp(:).*thigh4_binmask(:))))));
thigh_means(5,2) = mean(thigh5Mag_esp(find(~isnan(zero_to_nan(thigh5Mag_esp(:).*thigh5_binmask(:))))));
thigh_means(6,2) = mean(thigh6Mag_esp(find(~isnan(zero_to_nan(thigh6Mag_esp(:).*thigh6_binmask(:))))));
thigh_means(7,2) = mean(thigh7Mag_esp(find(~isnan(zero_to_nan(thigh7Mag_esp(:).*thigh7_binmask(:))))));
thigh_means(8,2) = mean(thigh8Mag_esp(find(~isnan(zero_to_nan(thigh8Mag_esp(:).*thigh8_binmask(:))))));
thigh_means(9,2) = mean(thigh9Mag_esp(find(~isnan(zero_to_nan(thigh9Mag_esp(:).*thigh9_binmask(:))))));
thigh_means(10,2) = mean(thigh10Mag_esp(find(~isnan(zero_to_nan(thigh10Mag_esp(:).*thigh10_binmask(:))))));

thigh_means(1,3) = 1000*mean(thigh1_lfe_vol(find(~isnan(zero_to_nan(thigh1_lfe_vol(:).*thigh1_binmask(:))))));
thigh_means(2,3) = 1000*mean(thigh2_lfe_vol(find(~isnan(zero_to_nan(thigh2_lfe_vol(:).*thigh2_binmask(:))))));
thigh_means(3,3) = 1000*mean(thigh3_lfe_vol(find(~isnan(zero_to_nan(thigh3_lfe_vol(:).*thigh3_binmask(:))))));
thigh_means(4,3) = 1000*mean(thigh4_lfe_vol(find(~isnan(zero_to_nan(thigh4_lfe_vol(:).*thigh4_binmask(:))))));
thigh_means(5,3) = 1000*mean(thigh5_lfe_vol(find(~isnan(zero_to_nan(thigh5_lfe_vol(:).*thigh5_binmask(:))))));
thigh_means(6,3) = 1000*mean(thigh6_lfe_vol(find(~isnan(zero_to_nan(thigh6_lfe_vol(:).*thigh6_binmask(:))))));
thigh_means(7,3) = 1000*mean(thigh7_lfe_vol(find(~isnan(zero_to_nan(thigh7_lfe_vol(:).*thigh7_binmask(:))))));
thigh_means(8,3) = 1000*mean(thigh8_lfe_vol(find(~isnan(zero_to_nan(thigh8_lfe_vol(:).*thigh8_binmask(:))))));
thigh_means(9,3) = 1000*mean(thigh9_lfe_vol(find(~isnan(zero_to_nan(thigh9_lfe_vol(:).*thigh9_binmask(:))))));
thigh_means(10,3) = 1000*mean(thigh10_lfe_vol(find(~isnan(zero_to_nan(thigh10_lfe_vol(:).*thigh10_binmask(:))))));

liver_means(1,1) = mean(liver1Mag_MDEV(find(~isnan(zero_to_nan(liver1Mag_MDEV(:).*liver1_binmask(:))))));
liver_means(2,1) = mean(liver2Mag_MDEV(find(~isnan(zero_to_nan(liver2Mag_MDEV(:).*liver2_binmask(:))))));
liver_means(3,1) = mean(liver3Mag_MDEV(find(~isnan(zero_to_nan(liver3Mag_MDEV(:).*liver3_binmask(:))))));
liver_means(4,1) = mean(liver4Mag_MDEV(find(~isnan(zero_to_nan(liver4Mag_MDEV(:).*liver4_binmask(:))))));
liver_means(5,1) = mean(liver5Mag_MDEV(find(~isnan(zero_to_nan(liver5Mag_MDEV(:).*liver5_binmask(:))))));
liver_means(6,1) = mean(liver6Mag_MDEV(find(~isnan(zero_to_nan(liver6Mag_MDEV(:).*liver6_binmask(:))))));
liver_means(7,1) = mean(liver7Mag_MDEV(find(~isnan(zero_to_nan(liver7Mag_MDEV(:).*liver7_binmask(:))))));
liver_means(8,1) = mean(liver8Mag_MDEV(find(~isnan(zero_to_nan(liver8Mag_MDEV(:).*liver8_binmask(:))))));
liver_means(9,1) = mean(liver9Mag_MDEV(find(~isnan(zero_to_nan(liver9Mag_MDEV(:).*liver9_binmask(:))))));
liver_means(10,1) = mean(liver10Mag_MDEV(find(~isnan(zero_to_nan(liver10Mag_MDEV(:).*liver10_binmask(:))))));

liver_means(1,2) = mean(liver1Mag_esp(find(~isnan(zero_to_nan(liver1Mag_esp(:).*liver1_binmask(:))))));
liver_means(2,2) = mean(liver2Mag_esp(find(~isnan(zero_to_nan(liver2Mag_esp(:).*liver2_binmask(:))))));
liver_means(3,2) = mean(liver3Mag_esp(find(~isnan(zero_to_nan(liver3Mag_esp(:).*liver3_binmask(:))))));
liver_means(4,2) = mean(liver4Mag_esp(find(~isnan(zero_to_nan(liver4Mag_esp(:).*liver4_binmask(:))))));
liver_means(5,2) = mean(liver5Mag_esp(find(~isnan(zero_to_nan(liver5Mag_esp(:).*liver5_binmask(:))))));
liver_means(6,2) = mean(liver6Mag_esp(find(~isnan(zero_to_nan(liver6Mag_esp(:).*liver6_binmask(:))))));
liver_means(7,2) = mean(liver7Mag_esp(find(~isnan(zero_to_nan(liver7Mag_esp(:).*liver7_binmask(:))))));
liver_means(8,2) = mean(liver8Mag_esp(find(~isnan(zero_to_nan(liver8Mag_esp(:).*liver8_binmask(:))))));
liver_means(9,2) = mean(liver9Mag_esp(find(~isnan(zero_to_nan(liver9Mag_esp(:).*liver9_binmask(:))))));
liver_means(10,2) = mean(liver10Mag_esp(find(~isnan(zero_to_nan(liver10Mag_esp(:).*liver10_binmask(:)))))); %#ok<*FNDSB>

liver_means(1,3) = 1000*mean(liver1_lfe_vol(find(~isnan(zero_to_nan(liver1_lfe_vol(:).*liver1_binmask(:))))));
liver_means(2,3) = 1000*mean(liver2_lfe_vol(find(~isnan(zero_to_nan(liver2_lfe_vol(:).*liver2_binmask(:))))));
liver_means(3,3) = 1000*mean(liver3_lfe_vol(find(~isnan(zero_to_nan(liver3_lfe_vol(:).*liver3_binmask(:))))));
liver_means(4,3) = 1000*mean(liver4_lfe_vol(find(~isnan(zero_to_nan(liver4_lfe_vol(:).*liver4_binmask(:))))));
liver_means(5,3) = 1000*mean(liver5_lfe_vol(find(~isnan(zero_to_nan(liver5_lfe_vol(:).*liver5_binmask(:))))));
liver_means(6,3) = 1000*mean(liver6_lfe_vol(find(~isnan(zero_to_nan(liver6_lfe_vol(:).*liver6_binmask(:))))));
liver_means(7,3) = 1000*mean(liver7_lfe_vol(find(~isnan(zero_to_nan(liver7_lfe_vol(:).*liver7_binmask(:))))));
liver_means(8,3) = 1000*mean(liver8_lfe_vol(find(~isnan(zero_to_nan(liver8_lfe_vol(:).*liver8_binmask(:))))));
liver_means(9,3) = 1000*mean(liver9_lfe_vol(find(~isnan(zero_to_nan(liver9_lfe_vol(:).*liver9_binmask(:))))));
liver_means(10,3) = 1000*mean(liver10_lfe_vol(find(~isnan(zero_to_nan(liver10_lfe_vol(:).*liver10_binmask(:))))));


brain_stds(1,1) = std(brain1Mag_MDEV(find(~isnan(zero_to_nan(brain1Mag_MDEV(:).*brain1_binmask(:))))));
brain_stds(2,1) = std(brain2Mag_MDEV(find(~isnan(zero_to_nan(brain2Mag_MDEV(:).*brain2_binmask(:))))));
brain_stds(3,1) = std(brain3Mag_MDEV(find(~isnan(zero_to_nan(brain3Mag_MDEV(:).*brain3_binmask(:))))));
brain_stds(4,1) = std(brain4Mag_MDEV(find(~isnan(zero_to_nan(brain4Mag_MDEV(:).*brain4_binmask(:))))));
brain_stds(5,1) = std(brain5Mag_MDEV(find(~isnan(zero_to_nan(brain5Mag_MDEV(:).*brain5_binmask(:))))));
brain_stds(6,1) = std(brain6Mag_MDEV(find(~isnan(zero_to_nan(brain6Mag_MDEV(:).*brain6_binmask(:))))));
brain_stds(7,1) = std(brain7Mag_MDEV(find(~isnan(zero_to_nan(brain7Mag_MDEV(:).*brain7_binmask(:))))));
brain_stds(8,1) = std(brain8Mag_MDEV(find(~isnan(zero_to_nan(brain8Mag_MDEV(:).*brain8_binmask(:))))));
brain_stds(9,1) = std(brain9Mag_MDEV(find(~isnan(zero_to_nan(brain9Mag_MDEV(:).*brain9_binmask(:))))));
brain_stds(10,1) = std(brain10Mag_MDEV(find(~isnan(zero_to_nan(brain10Mag_MDEV(:).*brain10_binmask(:))))));

brain_stds(1,2) = std(brain1Mag_esp(find(~isnan(zero_to_nan(brain1Mag_esp(:).*brain1_binmask(:))))));
brain_stds(2,2) = std(brain2Mag_esp(find(~isnan(zero_to_nan(brain2Mag_esp(:).*brain2_binmask(:))))));
brain_stds(3,2) = std(brain3Mag_esp(find(~isnan(zero_to_nan(brain3Mag_esp(:).*brain3_binmask(:))))));
brain_stds(4,2) = std(brain4Mag_esp(find(~isnan(zero_to_nan(brain4Mag_esp(:).*brain4_binmask(:))))));
brain_stds(5,2) = std(brain5Mag_esp(find(~isnan(zero_to_nan(brain5Mag_esp(:).*brain5_binmask(:))))));
brain_stds(6,2) = std(brain6Mag_esp(find(~isnan(zero_to_nan(brain6Mag_esp(:).*brain6_binmask(:))))));
brain_stds(7,2) = std(brain7Mag_esp(find(~isnan(zero_to_nan(brain7Mag_esp(:).*brain7_binmask(:))))));
brain_stds(8,2) = std(brain8Mag_esp(find(~isnan(zero_to_nan(brain8Mag_esp(:).*brain8_binmask(:))))));
brain_stds(9,2) = std(brain9Mag_esp(find(~isnan(zero_to_nan(brain9Mag_esp(:).*brain9_binmask(:))))));
brain_stds(10,2) = std(brain10Mag_esp(find(~isnan(zero_to_nan(brain10Mag_esp(:).*brain10_binmask(:))))));

brain_stds(1,3) = 1000*std(brain1_lfe_vol(find(~isnan(zero_to_nan(brain1_lfe_vol(:).*brain1_binmask(:))))));
brain_stds(2,3) = 1000*std(brain2_lfe_vol(find(~isnan(zero_to_nan(brain2_lfe_vol(:).*brain2_binmask(:))))));
brain_stds(3,3) = 1000*std(brain3_lfe_vol(find(~isnan(zero_to_nan(brain3_lfe_vol(:).*brain3_binmask(:))))));
brain_stds(4,3) = 1000*std(brain4_lfe_vol(find(~isnan(zero_to_nan(brain4_lfe_vol(:).*brain4_binmask(:))))));
brain_stds(5,3) = 1000*std(brain5_lfe_vol(find(~isnan(zero_to_nan(brain5_lfe_vol(:).*brain5_binmask(:))))));
brain_stds(6,3) = 1000*std(brain6_lfe_vol(find(~isnan(zero_to_nan(brain6_lfe_vol(:).*brain6_binmask(:))))));
brain_stds(7,3) = 1000*std(brain7_lfe_vol(find(~isnan(zero_to_nan(brain7_lfe_vol(:).*brain7_binmask(:))))));
brain_stds(8,3) = 1000*std(brain8_lfe_vol(find(~isnan(zero_to_nan(brain8_lfe_vol(:).*brain8_binmask(:))))));
brain_stds(9,3) = 1000*std(brain9_lfe_vol(find(~isnan(zero_to_nan(brain9_lfe_vol(:).*brain9_binmask(:))))));
brain_stds(10,3) = 1000*std(brain10_lfe_vol(find(~isnan(zero_to_nan(brain10_lfe_vol(:).*brain10_binmask(:))))));

thigh_stds(1,1) = std(thigh1Mag_MDEV(find(~isnan(zero_to_nan(thigh1Mag_MDEV(:).*thigh1_binmask(:))))));
thigh_stds(2,1) = std(thigh2Mag_MDEV(find(~isnan(zero_to_nan(thigh2Mag_MDEV(:).*thigh2_binmask(:))))));
thigh_stds(3,1) = std(thigh3Mag_MDEV(find(~isnan(zero_to_nan(thigh3Mag_MDEV(:).*thigh3_binmask(:))))));
thigh_stds(4,1) = std(thigh4Mag_MDEV(find(~isnan(zero_to_nan(thigh4Mag_MDEV(:).*thigh4_binmask(:))))));
thigh_stds(5,1) = std(thigh5Mag_MDEV(find(~isnan(zero_to_nan(thigh5Mag_MDEV(:).*thigh5_binmask(:))))));
thigh_stds(6,1) = std(thigh6Mag_MDEV(find(~isnan(zero_to_nan(thigh6Mag_MDEV(:).*thigh6_binmask(:))))));
thigh_stds(7,1) = std(thigh7Mag_MDEV(find(~isnan(zero_to_nan(thigh7Mag_MDEV(:).*thigh7_binmask(:))))));
thigh_stds(8,1) = std(thigh8Mag_MDEV(find(~isnan(zero_to_nan(thigh8Mag_MDEV(:).*thigh8_binmask(:))))));
thigh_stds(9,1) = std(thigh9Mag_MDEV(find(~isnan(zero_to_nan(thigh9Mag_MDEV(:).*thigh9_binmask(:))))));
thigh_stds(10,1) = std(thigh10Mag_MDEV(find(~isnan(zero_to_nan(thigh10Mag_MDEV(:).*thigh10_binmask(:))))));

thigh_stds(1,2) = std(thigh1Mag_esp(find(~isnan(zero_to_nan(thigh1Mag_esp(:).*thigh1_binmask(:))))));
thigh_stds(2,2) = std(thigh2Mag_esp(find(~isnan(zero_to_nan(thigh2Mag_esp(:).*thigh2_binmask(:))))));
thigh_stds(3,2) = std(thigh3Mag_esp(find(~isnan(zero_to_nan(thigh3Mag_esp(:).*thigh3_binmask(:))))));
thigh_stds(4,2) = std(thigh4Mag_esp(find(~isnan(zero_to_nan(thigh4Mag_esp(:).*thigh4_binmask(:))))));
thigh_stds(5,2) = std(thigh5Mag_esp(find(~isnan(zero_to_nan(thigh5Mag_esp(:).*thigh5_binmask(:))))));
thigh_stds(6,2) = std(thigh6Mag_esp(find(~isnan(zero_to_nan(thigh6Mag_esp(:).*thigh6_binmask(:))))));
thigh_stds(7,2) = std(thigh7Mag_esp(find(~isnan(zero_to_nan(thigh7Mag_esp(:).*thigh7_binmask(:))))));
thigh_stds(8,2) = std(thigh8Mag_esp(find(~isnan(zero_to_nan(thigh8Mag_esp(:).*thigh8_binmask(:))))));
thigh_stds(9,2) = std(thigh9Mag_esp(find(~isnan(zero_to_nan(thigh9Mag_esp(:).*thigh9_binmask(:))))));
thigh_stds(10,2) = std(thigh10Mag_esp(find(~isnan(zero_to_nan(thigh10Mag_esp(:).*thigh10_binmask(:))))));

thigh_stds(1,3) = 1000*std(thigh1_lfe_vol(find(~isnan(zero_to_nan(thigh1_lfe_vol(:).*thigh1_binmask(:))))));
thigh_stds(2,3) = 1000*std(thigh2_lfe_vol(find(~isnan(zero_to_nan(thigh2_lfe_vol(:).*thigh2_binmask(:))))));
thigh_stds(3,3) = 1000*std(thigh3_lfe_vol(find(~isnan(zero_to_nan(thigh3_lfe_vol(:).*thigh3_binmask(:))))));
thigh_stds(4,3) = 1000*std(thigh4_lfe_vol(find(~isnan(zero_to_nan(thigh4_lfe_vol(:).*thigh4_binmask(:))))));
thigh_stds(5,3) = 1000*std(thigh5_lfe_vol(find(~isnan(zero_to_nan(thigh5_lfe_vol(:).*thigh5_binmask(:))))));
thigh_stds(6,3) = 1000*std(thigh6_lfe_vol(find(~isnan(zero_to_nan(thigh6_lfe_vol(:).*thigh6_binmask(:))))));
thigh_stds(7,3) = 1000*std(thigh7_lfe_vol(find(~isnan(zero_to_nan(thigh7_lfe_vol(:).*thigh7_binmask(:))))));
thigh_stds(8,3) = 1000*std(thigh8_lfe_vol(find(~isnan(zero_to_nan(thigh8_lfe_vol(:).*thigh8_binmask(:))))));
thigh_stds(9,3) = 1000*std(thigh9_lfe_vol(find(~isnan(zero_to_nan(thigh9_lfe_vol(:).*thigh9_binmask(:))))));
thigh_stds(10,3) = 1000*std(thigh10_lfe_vol(find(~isnan(zero_to_nan(thigh10_lfe_vol(:).*thigh10_binmask(:))))));

liver_stds(1,1) = std(liver1Mag_MDEV(find(~isnan(zero_to_nan(liver1Mag_MDEV(:).*liver1_binmask(:))))));
liver_stds(2,1) = std(liver2Mag_MDEV(find(~isnan(zero_to_nan(liver2Mag_MDEV(:).*liver2_binmask(:))))));
liver_stds(3,1) = std(liver3Mag_MDEV(find(~isnan(zero_to_nan(liver3Mag_MDEV(:).*liver3_binmask(:))))));
liver_stds(4,1) = std(liver4Mag_MDEV(find(~isnan(zero_to_nan(liver4Mag_MDEV(:).*liver4_binmask(:))))));
liver_stds(5,1) = std(liver5Mag_MDEV(find(~isnan(zero_to_nan(liver5Mag_MDEV(:).*liver5_binmask(:))))));
liver_stds(6,1) = std(liver6Mag_MDEV(find(~isnan(zero_to_nan(liver6Mag_MDEV(:).*liver6_binmask(:))))));
liver_stds(7,1) = std(liver7Mag_MDEV(find(~isnan(zero_to_nan(liver7Mag_MDEV(:).*liver7_binmask(:))))));
liver_stds(8,1) = std(liver8Mag_MDEV(find(~isnan(zero_to_nan(liver8Mag_MDEV(:).*liver8_binmask(:))))));
liver_stds(9,1) = std(liver9Mag_MDEV(find(~isnan(zero_to_nan(liver9Mag_MDEV(:).*liver9_binmask(:))))));
liver_stds(10,1) = std(liver10Mag_MDEV(find(~isnan(zero_to_nan(liver10Mag_MDEV(:).*liver10_binmask(:))))));

liver_stds(1,2) = std(liver1Mag_esp(find(~isnan(zero_to_nan(liver1Mag_esp(:).*liver1_binmask(:))))));
liver_stds(2,2) = std(liver2Mag_esp(find(~isnan(zero_to_nan(liver2Mag_esp(:).*liver2_binmask(:))))));
liver_stds(3,2) = std(liver3Mag_esp(find(~isnan(zero_to_nan(liver3Mag_esp(:).*liver3_binmask(:))))));
liver_stds(4,2) = std(liver4Mag_esp(find(~isnan(zero_to_nan(liver4Mag_esp(:).*liver4_binmask(:))))));
liver_stds(5,2) = std(liver5Mag_esp(find(~isnan(zero_to_nan(liver5Mag_esp(:).*liver5_binmask(:))))));
liver_stds(6,2) = std(liver6Mag_esp(find(~isnan(zero_to_nan(liver6Mag_esp(:).*liver6_binmask(:))))));
liver_stds(7,2) = std(liver7Mag_esp(find(~isnan(zero_to_nan(liver7Mag_esp(:).*liver7_binmask(:))))));
liver_stds(8,2) = std(liver8Mag_esp(find(~isnan(zero_to_nan(liver8Mag_esp(:).*liver8_binmask(:))))));
liver_stds(9,2) = std(liver9Mag_esp(find(~isnan(zero_to_nan(liver9Mag_esp(:).*liver9_binmask(:))))));
liver_stds(10,2) = std(liver10Mag_esp(find(~isnan(zero_to_nan(liver10Mag_esp(:).*liver10_binmask(:)))))); %#ok<*FNDSB>

liver_stds(1,3) = 1000*std(liver1_lfe_vol(find(~isnan(zero_to_nan(liver1_lfe_vol(:).*liver1_binmask(:))))));
liver_stds(2,3) = 1000*std(liver2_lfe_vol(find(~isnan(zero_to_nan(liver2_lfe_vol(:).*liver2_binmask(:))))));
liver_stds(3,3) = 1000*std(liver3_lfe_vol(find(~isnan(zero_to_nan(liver3_lfe_vol(:).*liver3_binmask(:))))));
liver_stds(4,3) = 1000*std(liver4_lfe_vol(find(~isnan(zero_to_nan(liver4_lfe_vol(:).*liver4_binmask(:))))));
liver_stds(5,3) = 1000*std(liver5_lfe_vol(find(~isnan(zero_to_nan(liver5_lfe_vol(:).*liver5_binmask(:))))));
liver_stds(6,3) = 1000*std(liver6_lfe_vol(find(~isnan(zero_to_nan(liver6_lfe_vol(:).*liver6_binmask(:))))));
liver_stds(7,3) = 1000*std(liver7_lfe_vol(find(~isnan(zero_to_nan(liver7_lfe_vol(:).*liver7_binmask(:))))));
liver_stds(8,3) = 1000*std(liver8_lfe_vol(find(~isnan(zero_to_nan(liver8_lfe_vol(:).*liver8_binmask(:))))));
liver_stds(9,3) = 1000*std(liver9_lfe_vol(find(~isnan(zero_to_nan(liver9_lfe_vol(:).*liver9_binmask(:))))));
liver_stds(10,3) = 1000*std(liver10_lfe_vol(find(~isnan(zero_to_nan(liver10_lfe_vol(:).*liver10_binmask(:))))));

b = figure('position', [0 0 480 480], 'Color', [1 1 1]); plot(brain_means, 'linewidth', 2);xlabel('Subj.', 'FontSize', 14); ylabel('$|G^{*}| / \mu~(Pa)$', 'Interpreter', 'LaTeX', 'FontSize', 24);
xlim([1 10]); ylim([1000 4000]); set(gca, 'FontSize', 14, 'YTick', [1000 2000 3000 4000], 'XTick', 1:10); 
export_fig brain-mag-means -eps
l = figure('position', [0 0 480 480], 'Color', [1 1 1]); plot(liver_means, 'linewidth', 2);xlabel('Subj.', 'FontSize', 14); ylabel('$|G^{*}| / \mu~(Pa)$ ', 'Interpreter', 'LaTeX', 'FontSize', 24);
xlim([1 10]); ylim([1000 4000]); set(gca, 'FontSize', 14, 'YTick', [1000 2000 3000 4000], 'XTick', 1:10); 
export_fig liver-mag-means -eps
t = figure('position', [0 0 480 480], 'Color', [1 1 1]); plot(thigh_means, 'linewidth', 2);xlabel('Subj.', 'FontSize', 14); ylabel('$|G^{*}| / \mu~(Pa)$', 'Interpreter', 'LaTeX', 'FontSize', 24);
xlim([1 10]); ylim([500 2500]);set(gca, 'FontSize', 14, 'YTick', [500 1500 2500], 'XTick', 1:10); 
export_fig thigh-mag-means -eps
%legend('MDEV', 'ESP', 'LFE');  
braincorrs = [corr(brain_means(:,1), brain_means(:,2)), corr(brain_means(:,1), brain_means(:,3)), corr(brain_means(:,2), brain_means(:,3))];
livercorrs = [corr(liver_means(:,1), liver_means(:,2)), corr(liver_means(:,1), liver_means(:,3)), corr(liver_means(:,2), liver_means(:,3))];
thighcorrs = [corr(thigh_means(:,1), thigh_means(:,2)), corr(thigh_means(:,1), thigh_means(:,3)), corr(thigh_means(:,2), thigh_means(:,3))];
corrs = [braincorrs; livercorrs; thighcorrs];

