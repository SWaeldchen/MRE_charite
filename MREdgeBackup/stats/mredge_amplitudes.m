%% function mredge_amplitudes(info, prefs)

%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
% USAGE:
%
% Creates summed amplitude images
%
% INPUTS:
%
% info - an acquisition info structure created by make_acquisition_info
% prefs - mredge preferences file
%
% OUTPUTS:
%
% none

%%
function mredge_amplitudes(info, prefs)

[FT_DIRS, AMP_SUB] = set_dirs(info, prefs);
if ~exist(AMP_SUB, 'dir')
    mkdir(AMP_SUB);
end
NIFTI_EXTENSION = getenv('NIFTI_EXTENSION');
mdev_amp = []; % use a cat strategy, others are possible
    for d = 1:numel(FT_DIRS);
        for f = info.driving_frequencies
            %display([num2str(f), ' Hz']);
            % make use of component order in prefs
            components = cell(3,1);
            for c = 1:3
                wavefield_path = fullfile(FT_DIRS{d}, num2str(f), num2str(c), mredge_filename(f, c, NIFTI_EXTENSION));
                wavefield_vol = load_untouch_nii_eb(wavefield_path);
                components{c} = double(wavefield_vol.img);
            end
            amps = abs(components{1}) + abs(components{2}) + abs(components{3});
			mdev_amp = cat(4, mdev_amp, amps);
			% TEST EB +
			%dummy_vol = load_untouch_nii_eb(fullfile(info.path, 'AN_001', 'Abs_G', 'MDEV.nii'));
            %amp_vol = dummy_vol;
			% TEST EB -
            amp_vol = wavefield_vol;
            amp_vol.img = real(amps); % remove complex datatype
			amp_vol.hdr.dime.datatype = 64;
			amp_folder = fullfile(AMP_SUB, num2str(f));
			if ~exist(amp_folder)
				mkdir(amp_folder);
			end
            amp_path = fullfile(amp_folder, [num2str(f), NIFTI_EXTENSION]);
            save_untouch_nii(amp_vol, amp_path);
        end
    end

%now sum for mdev amplitude
mdev_amp = sum(mdev_amp, 4);
% get nifti placeholder
mdev_vol = wavefield_vol;
mdev_vol.img = real(mdev_amp); %remove complex datatype
mdev_vol.hdr.dime.datatype = 64;

save_untouch_nii(mdev_vol, fullfile(AMP_SUB, ['ALL', NIFTI_EXTENSION]));

end

function [FT_DIRS, AMP_SUB] = set_dirs(info, prefs)

    FT_DIRS = mredge_get_ft_dirs(info, prefs);
    AMP_SUB = mredge_analysis_path(info, prefs, 'Amp');
    
end
