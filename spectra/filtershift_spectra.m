finalmont = [];

for n = 1:10
    af_temp = circshift(af, [n 0]);
    af11 = af{1}(:,1);
    af12 = af{1}(:,2);
    af21 = af{2}(:,1);
    af22 = af{2}(:,2);
    %af11 = circshift(af11, [n 0]);
    af12 = circshift(af12, [n 0]);
    %af21 = circshift(af21, [n 0]);
    af22 = circshift(af22, [n 0]);
    mont = plot_dt_spectra(af11, af12, af21, af22);
    finalmont = cat(3, finalmont, mont);
end