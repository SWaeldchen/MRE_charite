classdef class_modicoismrm
    methods (Static)
        
        function mpragedata_import(PROJ_DIR,Asubject,subjectlist)
            disp('importing mprage data...');
            
            for ksub = subjectlist
                disp(['Subnum: ' int2str(ksub)]);
                
                DATA_SUB = fullfile(PROJ_DIR,Asubject(ksub).name);
                ANA_SUB = fullfile(DATA_SUB,'ANA');
                SCAN_SUB = fullfile(DATA_SUB,'SCAN');
                
                if ~strcmp(Asubject(ksub).name,'MREPERF-FD_20150513-133126');
                    
                    if ~exist(fullfile(ANA_SUB,'MPRAGE.nii'),'file');
                        ap_spm_import_mprage(SCAN_SUB,ANA_SUB,Asubject(ksub));
                    else
                        disp('...mprage.nii existed already.');
                    end
                end
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function mredata_import(PROJ_DIR,Asubject,subjectlist,modicomod)
            disp('importing MRE data...');
            % modicomod, distortion correction y/n
            
            for ksub = subjectlist
                disp(['Subnum: ' int2str(ksub) ' ' Asubject(ksub).name]);
                
                DATA_SUB = fullfile(PROJ_DIR,Asubject(ksub).name);
                SCAN_SUB = fullfile(DATA_SUB,'SCAN');
                NII_SUB = fullfile(DATA_SUB,'NII');
                RAWN_SUB = fullfile(DATA_SUB,'RAWN');
                mkdir(RAWN_SUB);
                mkdir(NII_SUB);
                
                if ~exist(fullfile(NII_SUB,'tmpfirstRL_dyn_ma.nii'),'file') % ???
                    modico_import(Asubject(ksub),modicomod,SCAN_SUB,NII_SUB);
                else
                    disp('...4D MRE data existed already.')
                end
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function mredata_calc(PROJ_DIR,Asubject,subjectlist,modicomod)
            disp('calc MRE data...');
            % modicomod, distortion correction y/n
            
            parfor ksub = subjectlist
                disp(['Subnum: ' int2str(ksub) ' ' Asubject(ksub).name]);
                
                SUB_NAME = Asubject(ksub).name;
                
                DATA_SUB = fullfile(PROJ_DIR,SUB_NAME);
                RAWN_SUB = fullfile(DATA_SUB,'RAWN');
                MODICO_SUB = fullfile(DATA_SUB,'MODICO');
                mkdir(RAWN_SUB);
                mkdir(MODICO_SUB);
                cd(DATA_SUB);
                
                if ~exist(fullfile(RAWN_SUB,'uRLLR.nii'),'file')
                    !cp NII/* RAWN/
                    modico_calc(PROJ_DIR,RAWN_SUB,MODICO_SUB,modicomod,SUB_NAME,'research');
                else
                    disp('...4D MRE data existed already.')
                end
                cd(RAWN_SUB);
                system('fsl5.0-applytopup --imain=RL_dico_ma --inindex=1 --datain=topup_param.txt --topup=my_topup_results --method=jac --interp=spline --out=uRL_dico_ma');
                !gunzip -f *gz
                
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function mredata_copyRAWN2ANA(PROJ_DIR,Asubject,subjectlist)
            disp('mdev MRE data...');
            
            parfor ksub = subjectlist
                disp(['Subnum: ' int2str(ksub) ' ' Asubject(ksub).name]);
                
                DATA_SUB = fullfile(PROJ_DIR,Asubject(ksub).name);
                RAWN_SUB = fullfile(DATA_SUB,'RAWN');
                ANA_SUB = fullfile(DATA_SUB,'ANA');
                mkdir(RAWN_SUB);
                mkdir(ANA_SUB);                
                                
                cd(DATA_SUB);
                !cp RAWN/my_field.nii ANA/
                !cp RAWN/dmy_field.nii ANA/
                !cp RAWN/RL_dico_ma.nii ANA/MAGf_orig.nii
                !cp RAWN/RL_dico_ma.nii ANA/
                !cp RAWN/uRL_dico_ma.nii ANA/MAGf_dico.nii
                
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function mredata_mdev(PROJ_DIR,Asubject,subjectlist,freqs,pixel_spacing)
            disp('mdev MRE data...');
            
            parfor ksub = subjectlist
                disp(['Subnum: ' int2str(ksub) ' ' Asubject(ksub).name]);
                
                DATA_SUB = fullfile(PROJ_DIR,Asubject(ksub).name);
                RAWN_SUB = fullfile(DATA_SUB,'RAWN');
                ANA_SUB = fullfile(DATA_SUB,'ANA');
                MODICO_SUB = fullfile(DATA_SUB,'MODICO');
                mkdir(RAWN_SUB);
                mkdir(ANA_SUB);
                mkdir(MODICO_SUB);
                
                cd(DATA_SUB);
                !cp RAWN/my_field.nii ANA/
                !cp RAWN/dmy_field.nii ANA/
                !cp RAWN/RL_dico_ma.nii ANA/MAGf_orig.nii
                !cp RAWN/RL_dico_ma.nii ANA/
                !cp RAWN/uRL_dico_ma.nii ANA/MAGf_dico.nii
                %system(fullfile(RAWN_SUB,'my_field.nii'),fullfile(ANA_SUB,'my_field.nii'));
                
                if ~exist(fullfile(ANA_SUB,'MAGm_orig.nii'),'file');
                    dataset = 'RL';
                    modico_mdev(MODICO_SUB,ANA_SUB,freqs,pixel_spacing,dataset);
                end
                if ~exist(fullfile(ANA_SUB,'MAGm_moco.nii'),'file');
                    dataset = 'rRL';
                    modico_mdev(MODICO_SUB,ANA_SUB,freqs,pixel_spacing,dataset);
                end
                if ~exist(fullfile(ANA_SUB,'MAGm_modico.nii'),'file');
                    dataset = 'urRL';
                    modico_mdev(MODICO_SUB,ANA_SUB,freqs,pixel_spacing,dataset);
                end
                if ~exist(fullfile(ANA_SUB,'MAGm_dico.nii'),'file');
                    dataset = 'uRL';
                    modico_mdev(MODICO_SUB,ANA_SUB,freqs,pixel_spacing,dataset);
                end
                
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function sub_segment_ana2mni(PROJ_DIR,Asubject,subjectlist)
            disp('segment_ana2mni');
            
            TPMdir = fullfile(spm('Dir'),'tpm');
            parfor ksub = subjectlist
                disp(['Subnum: ' int2str(ksub) ' ' Asubject(ksub).name]);
                DATA_SUB = fullfile(PROJ_DIR,Asubject(ksub).name);
                ANA_SUB = fullfile(DATA_SUB,'ANA');
                mkdir(ANA_SUB);
                cd(ANA_SUB);
                if exist(fullfile(ANA_SUB,'MPRAGE.nii'),'file')
                    tic
                    segment_ana2mni(ANA_SUB,TPMdir);  % segment untouched high-res mprage
                    t = toc
                    disp(t);
                end
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %         function normwrite_mprage2mni(PROJ_DIR,Asubject,subjectlist)
        %
        %             for ksub = subjectlist
        %                 disp(['Subnum: ' int2str(ksub) ' ' Asubject(ksub).name]);
        %                 DATA_SUB = fullfile(PROJ_DIR,Asubject(ksub).name);
        %                 ANA_SUB = fullfile(DATA_SUB,'ANA');
        %                 mkdir(ANA_SUB);
        %                 cd(ANA_SUB);
        %                 if exist(fullfile(ANA_SUB,'c1MPRAGE_mprage_mni.nii'),'file')
        %                     tic
        %                     af_normwrite_mprage2mni(ANA_SUB);
        %                     t = toc
        %                     disp(t);
        %                 end
        %             end
        %         end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function sub_segment_epi2ana(PROJ_DIR,Asubject,subjectlist)
            disp('segment_epi2ana');
            
            parfor ksub = subjectlist
                disp(['Subnum: ' int2str(ksub) ' ' Asubject(ksub).name]);
                DATA_SUB = fullfile(PROJ_DIR,Asubject(ksub).name);
                ANA_SUB = fullfile(DATA_SUB,'ANA');
                cd(DATA_SUB);
                mkdir(ANA_SUB);
                
                !cp RAWN/my_field.nii ANA/
                !cp RAWN/dmy_field.nii ANA/
                
                if ~exist('EPI_c1_orig.nii','file')
                    segment_epi2ana(ANA_SUB,'MAGf_orig');
                end
                
                if ~exist('EPI_c1_dico.nii','file')
                    segment_epi2ana(ANA_SUB,'MAGf_dico');
                end
                
                af_interpolwrapfield(ANA_SUB,'MAGf_orig'); % erzeugt wx,wy,wz-nifti-Dateien
                af_interpolwrapfield(ANA_SUB,'MAGf_dico'); % erzeugt wx,wy,wz-nifti-Dateien
            end
            
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function sub_norm_epi2mni(PROJ_DIR,Asubject,subjectlist,voxsize)
            disp('norm_epi2mni');
            
            TPMdir = fullfile(spm('Dir'),'tpm');
            parfor ksub = subjectlist
                disp(['Subnum: ' int2str(ksub) ' ' Asubject(ksub).name]);
                DATA_SUB = fullfile(PROJ_DIR,Asubject(ksub).name);
                ANA_SUB = fullfile(DATA_SUB,'ANA');
                cd(ANA_SUB);
                
                norm_epiorig2mni(ANA_SUB,TPMdir,voxsize);
                norm_epidico2mni(ANA_SUB,TPMdir,voxsize);
                
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function sub_deform_ana2epi(PROJ_DIR,Asubject,subjectlist)
            disp('deform_ana2epii');
            
            parfor ksub = subjectlist
                disp(['Subnum: ' int2str(ksub) ' ' Asubject(ksub).name]);
                DATA_SUB = fullfile(PROJ_DIR,Asubject(ksub).name);
                ANA_SUB = fullfile(DATA_SUB,'ANA');
                cd(ANA_SUB);
                
                deform_ana2epi(ANA_SUB,'MAGf_dico');
                deform_ana2epi(ANA_SUB,'MAGf_orig');
                
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function sub_deform_ana2mni(PROJ_DIR,Asubject,subjectlist)
            disp('deform_ana2mni');
            
            parfor ksub = subjectlist
                disp(['Subnum: ' int2str(ksub) ' ' Asubject(ksub).name]);
                DATA_SUB = fullfile(PROJ_DIR,Asubject(ksub).name);
                ANA_SUB = fullfile(DATA_SUB,'ANA');
                cd(ANA_SUB);
                deform_ana2mni(ANA_SUB);
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function sub_create_dmyfield(PROJ_DIR,Asubject,subjectlist)
            disp('sub_create_dmyfield');
            
            for ksub = subjectlist
                disp(['Subnum: ' int2str(ksub) ' ' Asubject(ksub).name]);
                DATA_SUB = fullfile(PROJ_DIR,Asubject(ksub).name);
                RAWN_SUB = fullfile(DATA_SUB,'RAWN');
                cd(RAWN_SUB);
                
                disp('Header myfield...');
                head_distmy = spm_vol('RL_dico_ma.nii');
                head_distmy.fname = 'myfield.nii';
                DATA = spm_read_vols(spm_vol('my_field.nii'));
                spm_write_vol(head_distmy,DATA);
                !cp myfield.nii ../ANA/
                
                disp('Distort myfield...');
                !cp my_topup_results_fieldcoef.nii my_topup_results_fieldcoef_tmp.nii
                head_distmy = spm_vol('my_topup_results_fieldcoef.nii');
                head_distmy.fname = 'my_topup_results_fieldcoef_inverted.nii';
                DATA = -spm_read_vols(spm_vol('my_topup_results_fieldcoef.nii'));
                spm_write_vol(head_distmy,DATA);
                pause(1)
                system('fsl5.0-applytopup --imain=myfield --inindex=1 --datain=topup_param.txt --topup=my_topup_results --method=jac --interp=spline --out=dmy_field');
                !gunzip -f *.gz
                
                disp('Header myfield...');
                head_distmy = spm_vol('RL_dico_ma.nii');
                head_distmy.fname = 'dmyfield.nii';
                DATA = spm_read_vols(spm_vol('dmy_field.nii'));
                spm_write_vol(head_distmy,DATA);
                !gunzip -f *.gz
                
                !cp dmyfield.nii ../ANA/
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
end

