function [] = loop_over_freqs_and_components_4d_nii(info, prefs, fun, IN_DIR_descr, OUT_DIR_descr)
% loop_over_freqs_and_components_4d_nii(info, prefs, fun, IN_DIR_descr, OUT_DIR_descr)
% Loop over all frequencies and field components. Apply funcion handle fun
% to every volume


[IN_DIR, OUT_DIR] = set_dirs(info, prefs);
NIF_EXT = getenv('NIFTI_EXTENSION');

comps = get_components_numerical(prefs.component_order);

parfor f_num = 1:numel(info.driving_frequencies)
    f = info.driving_frequencies(f_num);
    disp([num2str(f), ' Hz']);
    for q = 1:3
        c = comps(q); % c is the correct index of the component, i.e. 1->x, 1->y, 3->z
        display(num2str(c));
        wavefield_path = fullfile(IN_DIR, num2str(f), num2str(c), mredge_filename(f, c, NIF_EXT)); %#ok<PFBNS>
        wavefield_vol = load_untouch_nii_eb(wavefield_path);
        wavefield_img = wavefield_vol.img;
        %resid_vol = wavefield_vol;
        
        
        wavefield_img = fun(wavefield_img);
        
        wavefield_vol.img = wavefield_img;
        
        % prepare a 8-dim array representing the size of the image (in case
        % it was changed).
        si = [3 size(wavefield_img)];
        while (length(si) < 8)
           si = [si 1]; 
        end
        
        wavefield_vol.hdr.dime.dim = si;
        
        wavefield_out_path = fullfile(OUT_DIR, num2str(f), num2str(c), mredge_filename(f, c, NIF_EXT)); %#ok<PFBNS>
        out_dir = fullfile(OUT_DIR, num2str(f), num2str(c));  %#ok<PFBNS>
        if ~exist(out_dir, 'dir')
            mkdir(out_dir);
        end
        save_untouch_nii(wavefield_vol, wavefield_out_path);

    end
end

function [IN_DIR, OUT_DIR] = set_dirs(info, prefs)
    IN_DIR = mredge_analysis_path(info,prefs,IN_DIR_descr);
    OUT_DIR = mredge_analysis_path(info,prefs,OUT_DIR_descr);
end

end

