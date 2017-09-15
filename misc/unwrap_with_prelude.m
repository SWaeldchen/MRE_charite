function unwrap = unwrap_with_prelude(phase, mag)
if nargin < 2
    mag = ones(size(phase));
end
sz = size(phase);
[phase_resh, n_vols] = resh(phase, 4);
[mag_resh, ~] = resh(mag, 4);
unwrap_img = zeros(size(phase_resh));
phase_resh = normalize_image(phase_resh)*2*pi;

CURR_DIR = pwd;
for n = 1:n_vols
    phase_vol = make_nii(phase_resh(:,:,:,n));
    mag_vol = make_nii(mag_resh(:,:,:,n));
    save_nii(phase_vol, 'phase.nii');
    save_nii(mag_vol, 'mag.nii');
    fsl_command = ['fsl5.0-prelude -vs -p ',fullfile(CURR_DIR, 'phase'),' -a ',fullfile(CURR_DIR, 'mag'),...
    ' -o ',fullfile(CURR_DIR,'unwrap')];
    system(fsl_command);
    unwrap_vol = load_untouch_nii('unwrap.nii.gz');
    unwrap_img(:,:,:,n) = double(unwrap_vol.img);
end


unwrap = reshape(unwrap_img, sz);
delete phase.nii
delete mag.nii
delete unwrap.nii.gz
