function folder_name = mredge_analysis_folder_name(prefs)

folder_name = ['AN_', sprintf('%.3d', prefs.analysis_number), '_', sprintf('%s', prefs.analysis_descriptor)];