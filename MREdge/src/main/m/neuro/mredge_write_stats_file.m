function mredge_write_stats_file(stats, label_stats_path)
% Writes summary stats to specified path
% 
% INPUTS:
%
%   stats - struct containing summary stats
%
% OUTPUTS:
%
%   struct of labelled summary stats
%
% SEE ALSO:
%
%   mredge_brain_analysis, mredge_avg_mag_to_mni,
%   mredge_coreg_param_to_mni, mredge_mni_to_label_space,
%   mredge_label_brain
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
if ~exist(label_stats_path, 'file')
    label_fileID = fopen(label_stats_path, 'w');
else
    label_fileID = fopen(label_stats_path, 'a');
end
fprintf(label_fileID, '%s\n', 'Label,NumVoxels,Mean,Median,Std,Min,Max');
for n = 1:numel(stats)
    if stats(n).num_voxels > 0
        fprintf(label_fileID, '%s,%d,%1.3f,%1.3f,%1.3f,%1.3f,%1.3f\n', stats(n).label, stats(n).num_voxels, stats(n).mean, stats(n).median, stats(n).std, stats(n).min, stats(n).max);
    end
end
fclose('all');
    