function oss_snr_cal_method1(phase_unwrapped, spacing)
[n_amp]=nampCal(phase_unwrapped);
[oss_n]=ossNoiseCal(n_amp,spacing);
[oss_s]= ossSigCal(phase_unwrapped, spacing);
oss_snr=oss_s./oss_n;

figure;imagesc(mean(mean(oss_snr(:,:,:,:),3),4));colormap('hot'); axis image; axis off;