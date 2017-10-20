classdef class_analysemodico
    methods (Static)        
        
        function plotoverview_MNI(PROJ_DIR,Asubject) %,subjectlist)
            disp('plotoverview MNI...');
            
            PIC_DIR = fullfile(PROJ_DIR,'PICS');
            
            TMP_DATA = spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{1}{1},'ANA','MNI_MAGf_orig.nii')));
            
            for kslice = 30:5:size(TMP_DATA,3)
                X = CheckData(PROJ_DIR,Asubject,kslice,'MNI_MPRAGE','MNI_ANA_c2',...
                    'MNI_MAGf_orig','MNI_MAGf_dico','MNI_MAGm_orig','MNI_MAGm_moco','MNI_MAGm_dico','MNI_MAGm_modico',...
                    'MNI_ABSG_modico','MNI_PHI_modico','MNI_myfield',...
                    'MNI_wx_Twarp_orig_epi2ana','MNI_wy_Twarp_orig_epi2ana','MNI_wz_Twarp_orig_epi2ana',...
                    'MNI_wx_Twarp_dico_epi2ana');
                figure; 
                imagesc(cat(1,X(:,:,1),X(:,:,2),X(:,:,3),X(:,:,4),X(:,:,5),X(:,:,6),X(:,:,7),...
                    X(:,:,8),X(:,:,9),X(:,:,10),X(:,:,11),X(:,:,12),X(:,:,13),X(:,:,14)),[-1 1]);
                axis image, colormap(gray), axis off
                saveas(gcf,fullfile(PIC_DIR,['picoverview_MNI_' int2str(kslice) '.png']));
                saveas(gcf,fullfile(PIC_DIR,['picoverview_MNI_' int2str(kslice) '.fig']));
                close
            end
        end
        
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function plotoverview_EPI(PROJ_DIR,Asubject) %,subjectlist)
            disp('plotoverview EPI...');
            
            PIC_DIR = fullfile(PROJ_DIR,'PICS');
            
            TMP_DATA = spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{1}{1},'ANA','EPI_MAGf_orig.nii')));
            
            for kslice = 2:5:size(TMP_DATA,3)
                X = CheckData(PROJ_DIR,Asubject,kslice,...
                    'EPI_segana_orig_MPRAGE',...
                    'EPI_c2_segana_orig_MPRAGE',...
                    'EPI_MAGf_orig','EPI_MAGf_dico',...
                    'EPI_MAGm_orig','EPI_MAGm_moco','EPI_MAGm_dico','EPI_MAGm_modico',...
                    'EPI_ABSG_modico','EPI_PHI_orig','EPI_myfield',...
                    'wx_Twarp_orig_epi2ana','wy_Twarp_orig_epi2ana','wz_Twarp_orig_epi2ana',...
                    'wx_Twarp_dico_epi2ana');
                figure; 
                if size(X,3) == 14
                imagesc(cat(1,X(:,:,1),X(:,:,2),X(:,:,3),X(:,:,4),X(:,:,5),X(:,:,6),X(:,:,7),...
                    X(:,:,8),X(:,:,9),X(:,:,10),X(:,:,11),X(:,:,12),X(:,:,13),X(:,:,14)),[-1 1]);
                end
                if size(X,3) == 6
                imagesc(cat(1,X(:,:,1),X(:,:,2),X(:,:,3),X(:,:,4),X(:,:,5),X(:,:,6)),[-1 1]);
                end
                axis image, colormap(gray), axis off
                saveas(gcf,fullfile(PIC_DIR,['picoverview_EPI_' int2str(kslice) '.png']));
                saveas(gcf,fullfile(PIC_DIR,['picoverview_EPI_' int2str(kslice) '.fig']));
                close
            end            
        end
            
            
            
%             for ksub = subjectlist
%                 disp(['Subnum: ' int2str(ksub)]);
%                 
%                 DATA_SUB = fullfile(PROJ_DIR,Asubject(ksub).name);
%                 RAWN_SUB = fullfile(DATA_SUB,'RAWN');
%                 
%                 cd(SCRIPT_DIR);
%                 disp(SCRIPT_DIR);
%                 copyfile('topup_param.txt',fullfile(RAWN_SUB,'topup_param.txt'));
%                 
%             end
%        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
end

