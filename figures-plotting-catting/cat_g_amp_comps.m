function [g_montage, amp_montage, wave_montage, amp_summed, g_atfreq, mdev, laplacian_] = cat_g_amp_comps(f, MIJ)
freq = num2str(f);

g_montage = [];
amp_montage = [];
wave_montage = [];
amp_summed = load_untouch_nii(['Amp/',freq,'/', freq,'.nii.gz']); 
mdev = load_untouch_nii(['Abs_G/MDEV.nii.gz']); 
g_atfreq = load_untouch_nii(['Abs_G/',freq,'/',freq,'.nii.gz']);

for n = 1:3
    g = load_untouch_nii(['Abs_G/',freq,'/', num2str(n), '/', freq, '_', num2str(n), '.nii.gz']); 
    g_montage = cat(1, g_montage, g.img);
    amp = load_untouch_nii(['FT/', freq,'/', num2str(n), '/' , freq, '_', num2str(n), '.nii.gz']); 
    amp_montage = cat(1, amp_montage, abs(amp.img));
    wave_montage = cat(1, wave_montage, amp.img);

end

laplacian_ = abs(lap(amp_montage));

openImage(g_montage, MIJ, ['G Montage', freq]);
openImage(amp_montage, MIJ, ['Amp ',freq]);
openImage(amp_summed.img, MIJ, 'Amp Summed');
openImage(mdev.img, MIJ, 'MDEV');
openImage(g_atfreq.img, MIJ, ['G ',freq]);
openImage(laplacian_, MIJ, 'Lap Amp');