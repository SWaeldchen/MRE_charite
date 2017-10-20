
function convert_ri2pm(RAWN_SUB,MODICO_SUB,DATstr)
% convert to pm and copy to MODICO_SUB
cd(RAWN_SUB);

list_dyn_re = spm_select('FPList',RAWN_SUB,['^' DATstr '_dyn_r_4D.nii$']);
list_dyn_im = spm_select('FPList',RAWN_SUB,['^' DATstr '_dyn_i_4D.nii$']);

V_re_tmp = spm_vol(list_dyn_re);
V_im_tmp = spm_vol(list_dyn_im);

DATA_re = spm_read_vols(V_re_tmp);
DATA_im = spm_read_vols(V_im_tmp);
DATA_ma = abs(DATA_re + 1i*DATA_im);
DATA_ph = angle(DATA_re + 1i*DATA_im)/pi*4096;
clear DATA_re DATA_im

for k = 1:size(DATA_ph,4)
    V_ma_tmp = V_re_tmp;
    V_ma = V_ma_tmp(1);
    V_ma.fname = [DATstr '_dyn_ma' sprintf('%0*d',4,k) '.nii'];
    spm_write_vol(V_ma,DATA_ma(:,:,:,k));
    
    V_ph_tmp = V_im_tmp;
    V_ph = V_ph_tmp(1);
    V_ph.fname = [DATstr '_dyn_ph' sprintf('%0*d',4,k) '.nii'];
    spm_write_vol(V_ph,DATA_ph(:,:,:,k));
end

%% Merge corrected Ma + Ph niftis...;
merge_maph(RAWN_SUB,DATstr);
cd(RAWN_SUB);

tmpA = dir('*.gz');
if ~isempty(tmpA)
    tmpdat = gunzip('*.gz');
    disp(tmpdat);
    if ~isempty(tmpdat)
        for k = 1:length(tmpdat)
            delete([tmpdat{k} '.gz']);
        end
    end
end

if strcmp(DATstr,'rRL') || strcmp(DATstr,'urRL') || strcmp(DATstr,'uRL')
    delete([DATstr '_dyn_ma*.nii']);
    delete([DATstr '_dyn_ph*.nii']);
end

movefile(fullfile(RAWN_SUB,[DATstr '_dyn_m_4D.nii']),MODICO_SUB);
movefile(fullfile(RAWN_SUB,[DATstr '_dyn_p_4D.nii']),MODICO_SUB);

end

% 
% function convert_pm2ri(RAWN_SUB,DATstr,changenii_first_header)
% % erzeugt aktuell nur RL_dyn_r_4D.nii und RL_dyn_i_4D.nii
% % geht von 4D Dateien aus, verwendet 3D-ma/pha für Header
% % portabler wenn File für Header übergeben wird
% 
% % create list of magnitude and phase images
% list_dyn_ma = spm_select('FPList',RAWN_SUB,['^' DATstr '_dyn_m_4D.nii$']);
% list_dyn_ph = spm_select('FPList',RAWN_SUB,['^' DATstr '_dyn_p_4D.nii$']);
% 
% % load header informatin
% VOL_ma = spm_vol(list_dyn_ma);
% VOL_ph = spm_vol(list_dyn_ph);
% 
% % load data
% disp(size(VOL_ma));
% disp(size(VOL_ph));
% DATA_ma = spm_read_vols(VOL_ma);
% DATA_ph = spm_read_vols(VOL_ph);
% 
% % header files 3D-DATA => had problems with 4D-headers...
% if strcmp(changenii_first_header,'yes')
%     VOLTMP_ph = spm_vol(fullfile(RAWN_SUB,'RL_dico_ma.nii'));
% else
%     VOLTMP_ph = spm_vol(fullfile(RAWN_SUB,'tmpfirstRL_dyn_ma.nii'));
% end
% 
% for krep = 1:size(DATA_ma,4)
%     
%     V_ph = VOLTMP_ph;
%     
%     Y_ma = DATA_ma(:,:,:,krep);
%     Y_ph = DATA_ph(:,:,:,krep);
%     
%     Y_complex = Y_ma .* exp(1i.*Y_ph*2*pi/(4096*2));
%     
%     V_re = V_ph;
%     Y_re = real(Y_complex);
%     
%     V_im = V_ph;
%     Y_im = imag(Y_complex);
%     
%     outname_dyn_re = fullfile(RAWN_SUB,[DATstr '_dyn_re' sprintf('%0*d',4,krep) '.nii']);
%     V_re.fname = outname_dyn_re; % allow max 9999 images
%     V_re.dt = [4 0];
%     spm_write_vol(V_re,Y_re);   % use Ph header (-4096..+4096)
%     
%     outname_dyn_im = fullfile(RAWN_SUB,[DATstr '_dyn_im' sprintf('%0*d',4,krep) '.nii']);
%     V_im.fname = outname_dyn_im;
%     V_im.dt = [4 0];
%     spm_write_vol(V_im,Y_im);   % use Ph header (-4096..+4096)
%     
% end
% 
% cd(RAWN_SUB); % how to solve that problem more elegant
% 
% tmpA = dir('*.gz');
% if ~isempty(tmpA)
%     tmpdat = gunzip('*.gz');
%     if ~isempty(tmpdat)
%         for k = 1:length(tmpdat)
%             delete([tmpdat{k} '.gz']);
%         end
%     end
% end
% 
% merge_reim(RAWN_SUB,DATstr);
% 
% tmpA = dir('*.gz');
% if ~isempty(tmpA)
%     tmpdat = gunzip('*.gz');
%     if ~isempty(tmpdat)
%         for k = 1:length(tmpdat)
%             delete([tmpdat{k} '.gz']);
%         end
%     end
% end
% 
% 
% 
% % copyfile(fullfile(RAWN_SUB,[DATstr '_dyn_m_4D.nii']),MODICO_SUB);
% % copyfile(fullfile(RAWN_SUB,[DATstr '_dyn_p_4D.nii']),MODICO_SUB);
% 
% end
