% MREdge demo
% Analyzes a seven-frequency brain acquisition
% Elastograms estimated using finite-volume inversion
% (Manuscript in preparation)
% Commented instructions process a second brain from a
% different protocol, with a second inversion method
% To run, cd to MREdge_demo_data directory
% Data available at elastography.de

acquisition_path = 'cvk-brain';
%acquisition_path = 'yk-brain';
phase_index = 4; %series 4 in the DICOMs is the MRE phase
magnitude_index = 3; %series 3 in the DICOMs is the MRE magnitude
%phase_index = 5;  
%magnitude_index = 4;  series 4 in the DICOMs is the MRE magnitude
driving_frequencies = [20 25 30 40 50 35 45];
%driving_frequencies = [60 30 50 40 45 35 55];
voxel_spacing = [.002 .002 .002];
info = mredge_info(acquisition_path, ...
    'driving_frequencies', driving_frequencies, ...
    'voxel_spacing', voxel_spacing, ...
    'phase', phase_index, ...
    'magnitude', magnitude_index);
%info.fd_import = 0;
info.fd_import = 1;
prefs = mredge_prefs;
prefs.analysis_descriptor = 'DEMO';
prefs.denoise_settings.threshold_gain = 2;
prefs.inversion_strategy = 'sfwi';
%prefs.inversion_strategy = 'mdev';

outputs = mredge(info, prefs);
figure();
subplot(1, 2, 1); title('Example Wavefield'); imshow(real(outputs.wavefields(:,:,98)), []);
subplot(1, 2, 2); title('Elastogram For Same Slice'); imshow(real(outputs.elastograms{1}(:,:,8)), ... 
'displayrange', [0 3000], 'colormap', jet(100));
    
    