classdef class_modico
    methods (Static)
        
        %         function afsh_norm_estwrite_mre(PROJ_DIR,Asubject,subjectlist)
        %
        %             list_process = {'orig','modico'};
        %
        %
        %             TPMdir = fullfile(spm('Dir'),'tpm');
        %
        %             for ksub = subjectlist
        %                 disp(['Subnum: ' int2str(ksub)]);
        %
        %                 DATA_SUB = fullfile(PROJ_DIR,Asubject(ksub).name);
        %                 SEGNORM_SUB = fullfile(DATA_SUB,'SEGNORM');
        %             end
        %         end
        
        
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function norm_estwrite_mre(PROJ_DIR,Asubject,subjectlist)
            disp('afsh_norm_estwrite_mre...');
            
            %list_process = {'orig','moco','dico','modico','origfirst','dicofirst'}; % dyn Series
            
            for ksub = subjectlist
                disp('--------------------------------------------------');
                disp(['Subnum: ' int2str(ksub)]);
                
                DATA_SUB = fullfile(PROJ_DIR,Asubject(ksub).name);
                SEGNORM_SUB = fullfile(DATA_SUB,'SEGNORM');
                ANA_SUB = fullfile(DATA_SUB,'ANA');
                
                af_norm_write_mreall_iy(SEGNORM_SUB);
                
                %copyfile(fullfile(SEGNORM_SUB,'fieldMAGRL.nii'),fullfile(ANA_SUB,'MAGf_dico.nii'),'f');
%                 copyfile(fullfile(SEGNORM_SUB,'RLdicoma.nii'),fullfile(ANA_SUB,'MAGf_orig.nii'));
%                 copyfile(fullfile(SEGNORM_SUB,'uRLdicoma.nii'),fullfile(ANA_SUB,'MAGf_dico.nii'));
%                 
%                 %               copyfile(fullfile(SEGNORM_SUB,'y_RLdicoma2MNI_seg2TPM.nii'),fullfile(SEGNORM_SUB,'orig','y_warpEPIorg2MNI.nii'));
%                 %               copyfile(fullfile(SEGNORM_SUB,'y_RLdicoma2MNI_seg2TPM.nii'),fullfile(SEGNORM_SUB,'origfirst','y_warpEPIorg2MNI.nii'));
%                 %               copyfile(fullfile(SEGNORM_SUB,'y_RLdicoma2MNI_seg2TPM.nii'),fullfile(SEGNORM_SUB,'moco','y_warpEPIorg2MNI.nii'));
%                 %
%                 %               copyfile(fullfile(SEGNORM_SUB,'y_fieldMAGRL2MNI_seg2TPM.nii'),fullfile(SEGNORM_SUB,'dico','y_warpEPIcor2MNI.nii'));
%                 %               copyfile(fullfile(SEGNORM_SUB,'y_fieldMAGRL2MNI_seg2TPM.nii'),fullfile(SEGNORM_SUB,'modico','y_warpEPIcor2MNI.nii'));
%                 %               copyfile(fullfile(SEGNORM_SUB,'y_fieldMAGRL2MNI_seg2TPM.nii'),fullfile(SEGNORM_SUB,'dicofirst','y_warpEPIcor2MNI.nii'));
%                 %
%                 copyfile(fullfile(SEGNORM_SUB,'iy_RLdicoma_seg2MPRAGE.nii'),fullfile(ANA_SUB,'iy_orig_warpEPI2mprage.nii'));
%                 copyfile(fullfile(SEGNORM_SUB,'iy_uRLdicoma_seg2MPRAGE.nii'),fullfile(ANA_SUB,'iy_dico_warpEPI2mprage.nii'));
%                 copyfile(fullfile(SEGNORM_SUB,'iy_fieldMAGRL_seg2MPRAGE.nii'),fullfile(ANA_SUB,'iy_dico2_warpEPI2mprage.nii'));
%                 
%                 copyfile(fullfile(SEGNORM_SUB,'y_RLdicoma2MNI_seg2TPM.nii'),fullfile(ANA_SUB,'y_orig_warpEPI2MNI.nii'));
%                 copyfile(fullfile(SEGNORM_SUB,'y_uRLdicoma2MNI_seg2TPM.nii'),fullfile(ANA_SUB,'y_dico_warpEPI2MNI.nii'));
%                 copyfile(fullfile(SEGNORM_SUB,'y_fieldMAGRL2MNI_seg2TPM.nii'),fullfile(ANA_SUB,'y_dico2_warpEPI2MNI.nii'));
%                 %
%                 af_norm_estwrite_mreall_dico(ANA_SUB);
%                 af_norm_estwrite_mreall_orig(ANA_SUB);
                
                %copyfile(fullfile(SEGNORM_SUB,'iyu_fieldMAGRL_seg2MPRAGE.nii'),fullfile(SEGNORM_SUB,'dicofirst','my_field.nii'));
                
                
                %                 for kprocess = 1:length(list_process)
                %                     disp('---');
                %                     disp([int2str(ksub) '_' list_process{kprocess}]);
                %
                %                     SEGDIR = fullfile(SEGNORM_SUB,list_process{kprocess});
                %                     cd(SEGDIR);
                %
                %                     afsh_norm_estwrite_mre(SEGDIR);
                %                 end
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function plot_myfield_fieldMAGRL(PROJ_DIR,Asubject,subjectlist)
            disp('plot_myfield_fieldMAGRL...');
            
            PIC_DIR = fullfile(PROJ_DIR,'PICS');
            mkdir(PIC_DIR);
            for ksub = subjectlist
                disp(['Subnum: ' int2str(ksub)]);
                
                DATA_SUB = fullfile(PROJ_DIR,Asubject(ksub).name);
                SEGNORM_SUB = fullfile(DATA_SUB,'SEGNORM');
                
                RLdicoma = spm_read_vols(spm_vol(fullfile(SEGNORM_SUB,'RLdicoma.nii')));
                fieldMAG = spm_read_vols(spm_vol(fullfile(SEGNORM_SUB,'fieldMAGRL.nii')));
                
                plot2dwaves(RLdicoma);
                export_fig(fullfile(PIC_DIR,['RLdicoma_' int2str(ksub) '.png']));
                close
                plot2dwaves(fieldMAG);
                export_fig(fullfile(PIC_DIR,['fieldMAG_' int2str(ksub) '.png']));
                close
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function copyima2SCAN_SUB(PROJ_DIR,Asubject,subjectlist)
            disp('copyima2SCAN_SUB...');
            
            for ksub = subjectlist
                disp(['Subnum: ' int2str(ksub)]);
                
                DATA_SUB = fullfile(PROJ_DIR,Asubject(ksub).name);
                SCAN_SUB = fullfile(DATA_SUB,'SCAN');
                if ~exist(SCAN_SUB,'dir'), mkdir(SCAN_SUB), end
                
                if length(dir(SCAN_SUB)) < 3
                    disp('copy');
                    disp(Asubject(ksub).folderdate);
                    cd(fullfile('/media/andi/mnt_data2/',['datenoutput_' int2str(Asubject(ksub).folderdate)],Asubject(ksub).name));
                    [s,mess,messid] = copyfile('*.ima',SCAN_SUB);
                else
                    disp('already imported');
                    disp(Asubject(ksub).folderdate);
                end
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function mredata_import(PROJ_DIR,Asubject,subjectlist,modicomod)
            disp('importing MRE data...');
            
            for ksub = subjectlist
                disp(['Subnum: ' int2str(ksub) ' ' Asubject(ksub).name]);
                
                DATA_SUB = fullfile(PROJ_DIR,Asubject(ksub).name);
                RAWN_SUB = fullfile(DATA_SUB,'RAWN');
                SCAN_SUB = fullfile(DATA_SUB,'SCAN');
                mkdir(RAWN_SUB);
                mkdir(SCAN_SUB);
                
                if ~exist(fullfile(RAWN_SUB,'tmpfirstRL_dyn_ma.nii'),'file')
                    modico_import(Asubject(ksub),modicomod,SCAN_SUB,RAWN_SUB);
                else
                    disp('...4D MRE data existed already.')
                end
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function mredata_calc(PROJ_DIR,Asubject,subjectlist,modicomod)
            disp('calc MRE data...');
            
            for ksub = subjectlist
                disp(['Subnum: ' int2str(ksub) ' ' Asubject(ksub).name]);
                
                DATA_SUB = fullfile(PROJ_DIR,Asubject(ksub).name);
                RAWN_SUB = fullfile(DATA_SUB,'RAWN');
                MODICO_SUB = fullfile(DATA_SUB,'MODICO');
                mkdir(RAWN_SUB);
                mkdir(MODICO_SUB);
                
                SUB_NAME = Asubject(ksub).name;
                
                if ~exist(fullfile(RAWN_SUB,'uRLLR.nii'),'file')
                    modico_calc(RAWN_SUB,MODICO_SUB,modicomod,SUB_NAME,'research');
                else
                    disp('...4D MRE data existed already.')
                end
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function mredata_mdev(PROJ_DIR,Asubject,subjectlist,freqs,pixel_spacing)
            disp('mdev MRE data...');
            
            for ksub = subjectlist
                disp(['Subnum: ' int2str(ksub) ' ' Asubject(ksub).name]);
                
                DATA_SUB = fullfile(PROJ_DIR,Asubject(ksub).name);
                ANA_SUB = fullfile(DATA_SUB,'ANA');
                MODICO_SUB = fullfile(DATA_SUB,'MODICO');
                RAWN_SUB = fullfile(DATA_SUB,'RAWN');
                mkdir(ANA_SUB);
                mkdir(MODICO_SUB);
                mkdir(RAWN_SUB);
                copyfile(fullfile(RAWN_SUB,'my_field.nii'),fullfile(ANA_SUB,'my_field.nii'));
                
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
        
        function importmpragedata(PROJ_DIR,Asubject,subjectlist)
            disp('importing mprage data...');
            
            for ksub = subjectlist
                disp(['Subnum: ' int2str(ksub)]);
                
                DATA_SUB = fullfile(PROJ_DIR,Asubject(ksub).name);
                ANA_SUB = fullfile(DATA_SUB,'ANA');
                SCAN_SUB = fullfile(DATA_SUB,'SCAN');
                SEGNORM_SUB = fullfile(DATA_SUB,'SEGNORM');
                
                if ~strcmp(Asubject(ksub).name,'MREPERF-FD_20150513-133126');
                    
                    if ~exist(fullfile(SEGNORM_SUB,'MPRAGE.nii'),'file');
                        ap_spm_import_mprage(SCAN_SUB,ANA_SUB,SEGNORM_SUB,Asubject(ksub));
                    else
                        disp('...mprage.nii existed already.');
                    end
                end
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function motionana(PROJ_DIR,Asubject,subjectlist,modicomod)
            disp('motionana');
            
            for ksub = subjectlist
                disp(['Subnum: ' int2str(ksub)]);
                
                DATA_SUB = fullfile(PROJ_DIR,Asubject{ksub}{1});
                SCAN_SUB = fullfile(DATA_SUB,'SCAN');
                MOTIONANA_SUB = fullfile(DATA_SUB,'MOTIONANA');
                
                disp('importing MRE data for motion analysis...');
                if ~exist(fullfile(MOTIONANA_SUB,'tmpfirstRL_dyn_ma.nii'),'file')
                    ap_modico_import(Asubject{ksub,:},modicomod,SCAN_SUB,MOTIONANA_SUB);
                else
                    disp('...4D MRE data existed already.')
                end
                if ~exist(fullfile(MOTIONANA_SUB,'rRL_dyn_ma0001.nii'),'file')
                    do_spm_estwrite(MOTIONANA_SUB);
                end
                
                if (ksub~=12)
                    if ~exist(fullfile(MOTIONANA_SUB,'mw_anamot_results.txt'),'file')
                        cd(MOTIONANA_SUB);
                        !rm -rf mfp
                        [~,~,mfpfile] = mw_mfp(MOTIONANA_SUB,1,1,1,3,1,0,1,'PICS');
                        mw_anamot(mfpfile);
                    end
                end
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %             if ~exist(fullfile(PIC_DIR,['realignpara_' SUB_NAME '.png']),'file');
        %         af_plot_realignment(RAWN_SUB,PIC_DIR,SUB_NAME);
        %     end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function prepare_spm_segmentnorm_mprage2tpm(PROJ_DIR,Asubject,subjectlist)
            disp('prepare_segmentnorm_mprage');
            
            TPMdir = fullfile(spm('Dir'),'tpm');
            for ksub = subjectlist
                disp(['Subnum: ' int2str(ksub)]);
                DATA_SUB = fullfile(PROJ_DIR,Asubject(ksub).name);
                SEGNORM_SUB = fullfile(DATA_SUB,'SEGNORM');
                mkdir(SEGNORM_SUB);
                cd(SEGNORM_SUB);
                if exist(fullfile(SEGNORM_SUB,'MPRAGE.nii'),'file')
                    tic
                    af_spm_segment(SEGNORM_SUB,TPMdir,'MPRAGE');  % segment untouched high-res mprage
                    t=toc
                    disp(t);
                    %af_norm_estwrite_mprage(SEGNORM_SUB,TPMdir);  % normalise mprage and (manipulated) segments to TPM/Labels
                end
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function prepare_spm_segment_MRE2mprage(PROJ_DIR,Asubject,subjectlist)
            disp('prepare_spm_segment2mprage_MRE');
            
            for ksub = subjectlist %1:length(Asubject)
                disp(['Subnum: ' int2str(ksub)]);
                DATA_SUB = fullfile(PROJ_DIR,Asubject(ksub).name);
                SEGNORM_SUB = fullfile(DATA_SUB,'SEGNORM');
                cd(SEGNORM_SUB);
                
                if ~exist('c1uRLdicoma2MPRAGE_12345.nii','file')
                    af_spm_segment_own_12345(SEGNORM_SUB,'uRLdicoma');
                end
                
                if ~exist('c1RLdicoma2MPRAGE_12345.nii','file')
                    af_spm_segment_own_12345(SEGNORM_SUB,'RLdicoma')
                end
            end
            
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function prepare_data(PROJ_DIR,Asubject,subjectlist)
            
            for ksub = subjectlist
                disp(['Subnum: ' int2str(ksub)]);
                DATA_SUB = fullfile(PROJ_DIR,Asubject(ksub).name);
                SEGNORM_SUB = fullfile(DATA_SUB,'SEGNORM');
                RAWN_SUB = fullfile(DATA_SUB,'RAWN');
                mkdir(SEGNORM_SUB);
                
                cd(RAWN_SUB);
                if ~exist('uRL_dico_ma.nii','file')
                    [a,b]=system('fsl5.0-applytopup --imain=RL_dico_ma.nii --inindex=1 --datain=topup_param.txt --topup=my_topup_results --method=jac --interp=spline --out=uRL_dico_ma.nii');
                    !gunzip -f *.gz
                else
                    disp('uRL_dico_ma.nii already exists');
                end
                
                
                cd(SEGNORM_SUB);
                
%                copyfile(fullfile(RAWN_SUB,'my_field.nii'),SEGNORM_SUB);
                copyfile(fullfile(RAWN_SUB,'uRLLR.nii'),SEGNORM_SUB);
                copyfile(fullfile(RAWN_SUB,'RL_dico_ma.nii'),SEGNORM_SUB);
                copyfile(fullfile(RAWN_SUB,'uRL_dico_ma.nii'),SEGNORM_SUB);
                
                
                if ~exist('fieldMAGRL.nii','file')
                    !gunzip -f *.gz
                    !fsl5.0-fslsplit uRLLR.nii splituRLLR
                    !gunzip -f *.gz
                    !fsl5.0-fslmaths splituRLLR0000.nii.gz -add splituRLLR0001.nii combRLLR.nii.gz
                    !gunzip -f *.gz
                    TMPHEAD = spm_vol('my_field.nii');
                    NIIDAT = spm_read_vols(spm_vol('splituRLLR0000.nii'));
                    NIIDAT(:,:,end) = 0; % letzte Schichte im Dicom ist Falsch
                    TMPHEAD.fname = 'fieldMAGRL.nii';
                    spm_write_vol(TMPHEAD,NIIDAT);
                end
                
                if ~exist('RLdicoma.nii','file')
                    TMPHEAD = spm_vol('my_field.nii');
                    NIIDAT = spm_read_vols(spm_vol('RL_dico_ma.nii'));
                    TMPHEAD.fname = 'RLdicoma.nii';
                    spm_write_vol(TMPHEAD,NIIDAT);
                end
                
                if ~exist('uRLdicoma.nii','file')
                    TMPHEAD = spm_vol('uRL_dico_ma.nii');
                    NIIDAT = spm_read_vols(spm_vol('uRL_dico_ma.nii'));
                    TMPHEAD.fname = 'uRLdicoma.nii';
                    spm_write_vol(TMPHEAD,NIIDAT);
                end
                
                
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function prepare_spm_segmentnorm_MRE2MNI(PROJ_DIR,Asubject,subjectlist)
            
            TPMdir = fullfile(spm('Dir'),'tpm');
            for ksub = subjectlist
                disp(['Subnum: ' int2str(ksub)]);
                DATA_SUB = fullfile(PROJ_DIR,Asubject(ksub).name);
                SEGNORM_SUB = fullfile(DATA_SUB,'SEGNORM');
                                
                af_interpolwrapfield(SEGNORM_SUB,'RLdicoma'); % erzeugt wx,wy,wz-nifti-Dateien
                af_interpolwrapfield(SEGNORM_SUB,'uRLdicoma'); % erzeugt wx,wy,wz-nifti-Dateien
                                
                copyfile(fullfile(SEGNORM_SUB,'RLdicoma.nii'),fullfile(SEGNORM_SUB,'RLdicoma2MNI.nii'))
                copyfile(fullfile(SEGNORM_SUB,'uRLdicoma.nii'),fullfile(SEGNORM_SUB,'uRLdicoma2MNI.nii'))
                
                
                af_spm_segment(SEGNORM_SUB,TPMdir,'RLdicoma2MNI'); % erzeugt seg8
                af_interpolwrapfield(SEGNORM_SUB,'RLdicoma2MNI'); % erzeugt wx,wy,wz-nifti-Dateien
                
                af_spm_segment(SEGNORM_SUB,TPMdir,'uRLdicoma2MNI');
                af_interpolwrapfield(SEGNORM_SUB,'uRLdicoma2MNI');
                
            end
            
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function prepare_segmentnorm_MREMEAN(PROJ_DIR,Asubject)
            TPMdir = fullfile(spm('Dir'),'tpm');
            
            list_process = {'orig','moco','dico','modico'};
            
            for ksub = 1:length(Asubject)
                disp(['Subnum: ' int2str(ksub)]);
                DATA_SUB = fullfile(PROJ_DIR,Asubject(ksub).name);
                SEGNORM_SUB = fullfile(DATA_SUB,'SEGNORM');
                
                for kprocess = 1:length(list_process)
                    disp('---');
                    
                    SEGDIR = fullfile(SEGNORM_SUB,list_process{kprocess});
                    
                    magmre = 'MAG_MRE.nii';
                    af_spm_segment(SEGDIR,TPMdir,'MAG_MRE');
                    cd(SEGDIR);
                    af_interpolwrapfield(SEGDIR,'MAG_MRE');
                    af_norm_estwrite_mre(SEGDIR,TPMdir,magmre); % normalise MRE and mrenanmask to TPM/Labels
                    
                    magmre  = 'MAG_MRE_first.nii';
                    af_spm_segment(SEGDIR,TPMdir,'MAG_MRE_first');
                    cd(SEGDIR);
                    af_interpolwrapfield(SEGDIR,'MAG_MRE_first');
                    af_norm_estwrite_mre(SEGDIR,TPMdir,magmre); % normalise MRE and mrenanmask to TPM/Labels
                    
                end
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function combine_3D_PARA_segMRE(PROJ_DIR,Asubject,subjectlist)
            disp('combine_3D_PARA_segMRE');
            
            PIC_DIR = fullfile(PROJ_DIR,'PICS');
            
            for ksub = subjectlist
                disp(['Subnum: ' int2str(ksub)]);
                
                DATA_SUB = fullfile(PROJ_DIR,Asubject(ksub).name);
                
                SEGNORM_SUB = fullfile(DATA_SUB,'SEGNORM');
                
                comb3D_SEGMRE.mresegmask(:,:,:,ksub,1,1) = spm_read_vols(spm_vol(fullfile(SEGNORM_SUB,'c1RLdicoma12345.nii')));
                comb3D_SEGMRE.mresegmask(:,:,:,ksub,1,2) = spm_read_vols(spm_vol(fullfile(SEGNORM_SUB,'c2RLdicoma12345.nii')));
                comb3D_SEGMRE.mresegmask(:,:,:,ksub,1,3) = spm_read_vols(spm_vol(fullfile(SEGNORM_SUB,'c3RLdicoma12345.nii')));
                comb3D_SEGMRE.mresegmask(:,:,:,ksub,1,4) = spm_read_vols(spm_vol(fullfile(SEGNORM_SUB,'c4RLdicoma12345.nii')));
                comb3D_SEGMRE.mresegmask(:,:,:,ksub,1,5) = spm_read_vols(spm_vol(fullfile(SEGNORM_SUB,'c5RLdicoma12345.nii')));
                
                comb3D_SEGMRE.mresegmask(:,:,:,ksub,2,1) = spm_read_vols(spm_vol(fullfile(SEGNORM_SUB,'c1fieldMAGRL12345.nii')));
                comb3D_SEGMRE.mresegmask(:,:,:,ksub,2,2) = spm_read_vols(spm_vol(fullfile(SEGNORM_SUB,'c2fieldMAGRL12345.nii')));
                comb3D_SEGMRE.mresegmask(:,:,:,ksub,2,3) = spm_read_vols(spm_vol(fullfile(SEGNORM_SUB,'c3fieldMAGRL12345.nii')));
                comb3D_SEGMRE.mresegmask(:,:,:,ksub,2,4) = spm_read_vols(spm_vol(fullfile(SEGNORM_SUB,'c4fieldMAGRL12345.nii')));
                comb3D_SEGMRE.mresegmask(:,:,:,ksub,2,5) = spm_read_vols(spm_vol(fullfile(SEGNORM_SUB,'c5fieldMAGRL12345.nii')));
                
                sOut = size(spm_read_vols(spm_vol(fullfile(SEGNORM_SUB,'c5fieldMAGRL12345.nii'))));
                

                
                
                list_dataname = {'RLdicoma_seg8.mat','fieldMAGRL_seg8.mat'};
                
                cd(SEGNORM_SUB);
                for kdataname = 1:length(list_dataname)
                    disp('---');
                    
                    load(list_dataname{kdataname});
                    warp_dr_x = Twarp(:,:,:,1);
                    warp_dr_y = Twarp(:,:,:,2);
                    warp_dr_z = Twarp(:,:,:,3);
                    
                    xIn = linspace(0,1,size(warp_dr_x,1));
                    yIn = linspace(0,1,size(warp_dr_y,2));
                    zIn = linspace(0,1,size(warp_dr_z,3));
                    
                    xOut = linspace(0,1,sOut(1));
                    yOut = linspace(0,1,sOut(2));
                    zOut = linspace(0,1,sOut(3));
                    
                    gi = griddedInterpolant;
                    gi.GridVectors = {xIn yIn zIn};
                    gi.Method = 'spline';
                    
                    gi.Values = warp_dr_x;
                    warp_dr_x_ip = gi({xOut yOut zOut});
                    gi.Values = warp_dr_y;
                    warp_dr_y_ip = gi({xOut yOut zOut});
                    gi.Values = warp_dr_z;
                    warp_dr_z_ip = gi({xOut yOut zOut});
                    
                    comb3D_SEGMRE.Twarp2mprage_x(:,:,:,ksub,kdataname) = warp_dr_x_ip;
                    comb3D_SEGMRE.Twarp2mprage_y(:,:,:,ksub,kdataname) = warp_dr_y_ip;
                    comb3D_SEGMRE.Twarp2mprage_z(:,:,:,ksub,kdataname) = warp_dr_z_ip;
                    
                    %                     plot2dwaves(comb3D_SEGMRE.Twarp2mprage_x(:,:,:,ksub,kdataname));
                    %                     export_fig(fullfile(PIC_DIR,['Twarp2mprage_x_' int2str(ksub) '_' int2str(kdataname)]));
                    %                     close
                    %                     plot2dwaves(comb3D_SEGMRE.Twarp2mprage_y(:,:,:,ksub,kdataname));
                    %                     export_fig(fullfile(PIC_DIR,['Twarp2mprage_y_' int2str(ksub) '_' int2str(kdataname)]));
                    %                     close
                    %                     plot2dwaves(comb3D_SEGMRE.Twarp2mprage_z(:,:,:,ksub,kdataname));
                    %                     export_fig(fullfile(PIC_DIR,['Twarp2mprage_z_' int2str(ksub) '_' int2str(kdataname)]));
                    %                     close
                end
            end
            
            save(fullfile(PROJ_DIR,'comb3D_SEGPARA_segMRE.mat'),'comb3D_SEGMRE','-v7.3');
        end
        
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function combine_3D_PARA(PROJ_DIR,Asubject,subjectlist)
            disp('combine_3D_PARA');
            
            for ksub = subjectlist
                disp(['Subnum: ' int2str(ksub)]);
                
                DATA_SUB = fullfile(PROJ_DIR,Asubject(ksub).name);
                RAWN_SUB = fullfile(DATA_SUB,'RAWN');
                ANA_SUB = fullfile(DATA_SUB,'ANA');
                SEGNORM_SUB = fullfile(DATA_SUB,'SEGNORM');
                
                comb3D_MREPARA.ABSG(:,:,:,ksub,1) = spm_read_vols(spm_vol(fullfile(ANA_SUB,'ABSG_orig.nii')));
                comb3D_MREPARA.ABSG(:,:,:,ksub,2) = spm_read_vols(spm_vol(fullfile(ANA_SUB,'ABSG_moco.nii')));
                comb3D_MREPARA.ABSG(:,:,:,ksub,3) = spm_read_vols(spm_vol(fullfile(ANA_SUB,'ABSG_dico.nii')));
                comb3D_MREPARA.ABSG(:,:,:,ksub,4) = spm_read_vols(spm_vol(fullfile(ANA_SUB,'ABSG_modico.nii')));
                comb3D_MREPARA.PHI(:,:,:,ksub,1) = spm_read_vols(spm_vol(fullfile(ANA_SUB,'PHI_orig.nii')));
                comb3D_MREPARA.PHI(:,:,:,ksub,2) = spm_read_vols(spm_vol(fullfile(ANA_SUB,'PHI_moco.nii')));
                comb3D_MREPARA.PHI(:,:,:,ksub,3) = spm_read_vols(spm_vol(fullfile(ANA_SUB,'PHI_dico.nii')));
                comb3D_MREPARA.PHI(:,:,:,ksub,4) = spm_read_vols(spm_vol(fullfile(ANA_SUB,'PHI_modico.nii')));
                comb3D_MREPARA.AMP(:,:,:,ksub,1) = spm_read_vols(spm_vol(fullfile(ANA_SUB,'AMP_orig.nii')));
                comb3D_MREPARA.AMP(:,:,:,ksub,2) = spm_read_vols(spm_vol(fullfile(ANA_SUB,'AMP_moco.nii')));
                comb3D_MREPARA.AMP(:,:,:,ksub,3) = spm_read_vols(spm_vol(fullfile(ANA_SUB,'AMP_dico.nii')));
                comb3D_MREPARA.AMP(:,:,:,ksub,4) = spm_read_vols(spm_vol(fullfile(ANA_SUB,'AMP_modico.nii')));
                comb3D_MREPARA.MAGMRE(:,:,:,ksub,1) = spm_read_vols(spm_vol(fullfile(ANA_SUB,'MAG_orig.nii')));
                comb3D_MREPARA.MAGMRE(:,:,:,ksub,2) = spm_read_vols(spm_vol(fullfile(ANA_SUB,'MAG_moco.nii')));
                comb3D_MREPARA.MAGMRE(:,:,:,ksub,3) = spm_read_vols(spm_vol(fullfile(ANA_SUB,'MAG_dico.nii')));
                comb3D_MREPARA.MAGMRE(:,:,:,ksub,4) = spm_read_vols(spm_vol(fullfile(ANA_SUB,'MAG_modico.nii')));
                
                comb3D_SEGPARA.myfield(:,:,:,ksub) = spm_read_vols(spm_vol(fullfile(RAWN_SUB,'my_field.nii')));
                %                 comb3D_SEGPARA.Twarp2MNI_x(:,:,:,ksub,1) = spm_read_vols(spm_vol(fullfile(SEGNORM_SUB,'wx_Twarp_RLdicoma.nii')));
                %                 comb3D_SEGPARA.Twarp2MNI_y(:,:,:,ksub,1) = spm_read_vols(spm_vol(fullfile(SEGNORM_SUB,'wy_Twarp_RLdicoma.nii')));
                %                 comb3D_SEGPARA.Twarp2MNI_z(:,:,:,ksub,1) = spm_read_vols(spm_vol(fullfile(SEGNORM_SUB,'wz_Twarp_RLdicoma.nii')));
                %                 comb3D_SEGPARA.Twarp2MNI_x(:,:,:,ksub,2) = spm_read_vols(spm_vol(fullfile(SEGNORM_SUB,'wx_Twarp_fieldMAGRL.nii')));
                %                 comb3D_SEGPARA.Twarp2MNI_y(:,:,:,ksub,2) = spm_read_vols(spm_vol(fullfile(SEGNORM_SUB,'wy_Twarp_fieldMAGRL.nii')));
                %                 comb3D_SEGPARA.Twarp2MNI_z(:,:,:,ksub,2) = spm_read_vols(spm_vol(fullfile(SEGNORM_SUB,'wz_Twarp_fieldMAGRL.nii')));
                comb3D_SEGPARA.MAG(:,:,:,ksub,1) = spm_read_vols(spm_vol(fullfile(SEGNORM_SUB,'RLdicoma.nii')));
                comb3D_SEGPARA.MAG(:,:,:,ksub,2) = spm_read_vols(spm_vol(fullfile(SEGNORM_SUB,'fieldMAGRL.nii')));
                
                MAG = squeeze(comb3D_SEGPARA.MAG(:,:,:,ksub,2));
                BW = MAG > 100;
                BW_all = getLargestCc(logical(BW),4,40);
                for kslice = 1:size(BW,3)
                    BW2(:,:,kslice) = imfill(BW_all(:,:,kslice),'holes');
                end
                comb3D_SEGPARA.BW(:,:,:,ksub) = BW2;
                
            end
            
            save(fullfile(PROJ_DIR,'comb3D_SEGPARA.mat'),'comb3D_SEGPARA','-v7.3');
            save(fullfile(PROJ_DIR,'comb3D_MREPARA.mat'),'comb3D_MREPARA','-v7.3');
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function combine_3Dnorm_MREPARA(PROJ_DIR,Asubject,subjectlist,prestr)
            disp('combine_3Dnorm_MREPARA');
            
            TPMdir = fullfile(spm('Dir'),'tpm');
            list_process = {'orig','moco','dico','modico'};
            
            for ksub = subjectlist
                disp(['Subnum: ' int2str(ksub)]);
                
                DATA_SUB = fullfile(PROJ_DIR,Asubject(ksub).name);
                SEGNORM_SUB = fullfile(DATA_SUB,'SEGNORM');
                
                for kprocess = 1:length(list_process)
                    disp(list_process{kprocess});
                    SEGDIR = fullfile(SEGNORM_SUB,list_process{kprocess});
                    comb3D_MREPARA.ABSG(:,:,:,ksub,kprocess) = spm_read_vols(spm_vol(fullfile(SEGDIR,[prestr 'ABSG_MRE.nii'])));
                    comb3D_MREPARA.PHI(:,:,:,ksub,kprocess) = spm_read_vols(spm_vol(fullfile(SEGDIR,[prestr 'PHI_MRE.nii'])));
                    comb3D_MREPARA.AMP(:,:,:,ksub,kprocess) = spm_read_vols(spm_vol(fullfile(SEGDIR,[prestr 'AMP_MRE.nii'])));
                    comb3D_MREPARA.MAG(:,:,:,ksub,kprocess) = spm_read_vols(spm_vol(fullfile(SEGDIR,[prestr 'MAG_MRE.nii'])));
                    
                    %                     comb3D_swe0white(:,:,:,ksub,kprocess) = spm_read_vols(spm_vol(fullfile(SEGDIR,[prestr 'e0white_seg.nii'])));
                    %                     comb3D_swe0grey(:,:,:,ksub,kprocess) = spm_read_vols(spm_vol(fullfile(SEGDIR,[prestr 'e0grey_seg.nii'])));
                    clear tmpval
                end
                
                comb3D.mprage(:,:,:,ksub,1) = spm_read_vols(spm_vol(fullfile(SEGNORM_SUB,'wmprage.nii')));
                
                tmp_Nii = nifti(fullfile(TPMdir,'TPM.nii'));
                for k =1:6
                    comb3D.TPMall(:,:,:,k) = double(tmp_Nii.dat(:,:,:,k));
                end
                
                TPM1 = logical(comb3D.TPMall(:,:,:,1)>0.1);
                TPM2 = logical(comb3D.TPMall(:,:,:,2)>0.1);
                TPM3 = logical(comb3D.TPMall(:,:,:,3)>0.3);
                TPMcomb = (TPM1 + TPM2 + TPM3) > 0.1;
                comb3D_MREPARA.TPMmaskused = TPMcomb;
                hdrswbrainTPMmask = spm_vol(fullfile(PROJ_DIR,'swTemplate.nii'));
                hdrswbrainTPMmask.fname=fullfile(PROJ_DIR,'swbrainTPMmask.nii');
                spm_write_vol(hdrswbrainTPMmask,TPMcomb);
                
                save(fullfile(PROJ_DIR,['comb3D_MREPARA_' prestr '.mat']),'comb3D_MREPARA','comb3D','-v7.3');
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function combine_3Dnorm_SEGPARA(PROJ_DIR,Asubject,subjectlist,prestr)
            disp('combine_3Dnorm_SEGPARA');
            for ksub = subjectlist
                disp(['Subnum: ' int2str(ksub)]);
                DATA_SUB = fullfile(PROJ_DIR,Asubject(ksub).name);
                SEGNORM_SUB = fullfile(DATA_SUB,'SEGNORM');
                
                comb3D_SEGPARA.Twarp_x(:,:,:,ksub,1) = spm_read_vols(spm_vol(fullfile(SEGNORM_SUB,[prestr 'wx_Twarp_RLdicoma.nii'])));
                comb3D_SEGPARA.Twarp_y(:,:,:,ksub,1) = spm_read_vols(spm_vol(fullfile(SEGNORM_SUB,[prestr 'wy_Twarp_RLdicoma.nii'])));
                comb3D_SEGPARA.Twarp_z(:,:,:,ksub,1) = spm_read_vols(spm_vol(fullfile(SEGNORM_SUB,[prestr 'wz_Twarp_RLdicoma.nii'])));
                comb3D_SEGPARA.Twarp_x(:,:,:,ksub,2) = spm_read_vols(spm_vol(fullfile(SEGNORM_SUB,[prestr 'wx_Twarp_fieldMAGRL.nii'])));
                comb3D_SEGPARA.Twarp_y(:,:,:,ksub,2) = spm_read_vols(spm_vol(fullfile(SEGNORM_SUB,[prestr 'wy_Twarp_fieldMAGRL.nii'])));
                comb3D_SEGPARA.Twarp_z(:,:,:,ksub,2) = spm_read_vols(spm_vol(fullfile(SEGNORM_SUB,[prestr 'wz_Twarp_fieldMAGRL.nii'])));
                comb3D_SEGPARA.MAG(:,:,:,ksub,1) = spm_read_vols(spm_vol(fullfile(SEGNORM_SUB,[prestr 'RLdicoma.nii'])));
                comb3D_SEGPARA.MAG(:,:,:,ksub,2) = spm_read_vols(spm_vol(fullfile(SEGNORM_SUB,[prestr 'fieldMAGRL.nii'])));
                comb3D_SEGPARA.myfield(:,:,:,ksub) = spm_read_vols(spm_vol(fullfile(SEGNORM_SUB,[prestr 'my_field.nii'])));
                
                MAG = squeeze(comb3D_SEGPARA.MAG(:,:,:,ksub,2));
                BW = MAG > 100;
                BW_all = getLargestCc(logical(BW),4,40);
                for kslice = 1:size(BW,3)
                    BW2(:,:,kslice) = imfill(BW_all(:,:,kslice),'holes');
                end
                comb3D_SEGPARA.BW(:,:,:,ksub,1) = BW2;
            end
            
            save(fullfile(PROJ_DIR,['comb3Dnorm_SEGPARA_' prestr '.mat']),'comb3D_SEGPARA','-v7.3');
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function create_comb3Dnorm_slicenifti(PROJ_DIR)
            
            cd(PROJ_DIR);
            load('comb3Dnorm_MREPARA.mat');
            load('comb3Dnorm_SEGPARA.mat');
            load('comb3Dnorm_MAGMRE.mat');
            
            for kslice = 1:121
                ABSG = squeeze(comb3D_MREPARA.ABSG(:,:,kslice,:,:));
                PHI = squeeze(comb3D_MREPARA.PHI(:,:,kslice,:,:));
                AMP = squeeze(comb3D_MREPARA.AMP(:,:,kslice,:,:));
                MAG = squeeze(comb3D_MREPARA.MAGMRE(:,:,kslice,:,:));
                Twarp_x = squeeze(comb3D_SEGPARA.Twarp_x(:,:,kslice,:,:));
                Twarp_y = squeeze(comb3D_SEGPARA.Twarp_y(:,:,kslice,:,:));
                Twarp_z = squeeze(comb3D_SEGPARA.Twarp_z(:,:,kslice,:,:));
                
                Topupfield = comb3Dnorm.topupfield(:,:,kslice,:);
                
                save(fullfile(PROJ_DIR,'tmpslice',['modico_' int2str(kslice)]),'ABSG',...
                    'PHI','AMP','MAG','Twarp_x','Twarp_y','Twarp_z','Topupfield');
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function corrfieldvsdist_distpervox(PROJ_DIR,DATA3D_SEGNORMfilename,txtstr)
            disp('#### corrfieldvsdist_distpervox ####');
            load(fullfile(PROJ_DIR,DATA3D_SEGNORMfilename));
            tic
            
            for ksub = 1:size(comb3D_SEGPARA.MAG,4)
                for kprocess = 1:size(comb3D_SEGPARA.Twarp_x,5) % Dim 5 z.B. orig, dico or orig,moco,dico,modico
                    disp(['ksub' int2str(ksub) ' kprocess' int2str(kprocess)]);
                    for kslice = 1:size(comb3D_SEGPARA.Twarp_x,3)
                        
                        BW = comb3D_SEGPARA.BW(:,:,kslice,ksub);
                        tmpBW = sum(BW(:));
                        
                        % Vorzeichen Flippen
                        TMP3D.wx.curr = -comb3D_SEGPARA.Twarp_x(:,:,kslice,ksub,kprocess);
                        TMP3D.wy.curr = -comb3D_SEGPARA.Twarp_y(:,:,kslice,ksub,kprocess);
                        TMP3D.wz.curr = -comb3D_SEGPARA.Twarp_z(:,:,kslice,ksub,kprocess);
                        
                        TMP3D.myfield = comb3D_SEGPARA.myfield(:,:,kslice,ksub);
                        
                        dattmp.myfield = TMP3D.myfield(BW);
                        dattmp.wx = TMP3D.wx.curr(BW);
                        dattmp.wy = TMP3D.wy.curr(BW);
                        dattmp.wz = TMP3D.wz.curr(BW);
                        
                        res.wx.sumabspervox(ksub,kprocess,kslice) = sum(abs(dattmp.wx))./tmpBW;
                        res.wy.sumabspervox(ksub,kprocess,kslice) = sum(abs(dattmp.wy))./tmpBW;
                        res.wz.sumabspervox(ksub,kprocess,kslice) = sum(abs(dattmp.wz))./tmpBW;
                        
                        res.wx.stdabs(ksub,kprocess,kslice) = std(abs(dattmp.wx));
                        res.wy.stdabs(ksub,kprocess,kslice) = std(abs(dattmp.wy));
                        res.wz.stdabs(ksub,kprocess,kslice) = std(abs(dattmp.wz));
                        
                        res.numvox(ksub,kprocess,kslice) = sum(BW(:));
                        res.sumfield(ksub,kprocess,kslice) = sum(TMP3D.myfield(BW));
                        
                        % Correlation field vs disp
                        
                        [rx,px] = corrcoef(dattmp.wx,dattmp.myfield);
                        [ry,py] = corrcoef(dattmp.wy,dattmp.myfield);
                        [rz,pz] = corrcoef(dattmp.wz,dattmp.myfield);
                        
                        if size(rx) == 1
                            rx = [NaN NaN; NaN NaN];
                            ry = rx;
                            rz = rx;
                            px = rx;
                            py = rx;
                            pz = rx;
                        end
                        
                        res.corfield_r(ksub,kprocess,kslice,1:3) = [rx(2,1) ry(2,1) rz(2,1)];
                        res.corfield_p(ksub,kprocess,kslice,1:3) = [px(2,1) py(2,1) pz(2,1)];
                        
                    end
                end
            end
            
            res.sumabspervox(:,:,:,1) = res.wx.sumabspervox;
            res.sumabspervox(:,:,:,2) = res.wy.sumabspervox;
            res.sumabspervox(:,:,:,3) = res.wz.sumabspervox;
            
            save(fullfile(PROJ_DIR,['res_corrfieldvsdist_distpervox_' txtstr '.mat']),'res');
            
            t = toc;
            disp(['ex-time, corrfieldvsdist_distpervox: ' int2str(t)]);
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function plot_sumabspervox(PROJ_DIR,txtstr)
            
            load(fullfile(PROJ_DIR,['res_corrfieldvsdist_distpervox_' txtstr '.mat']));
            
            PIC_DIR = fullfile(PROJ_DIR,'PICS');
            
            for ksub = 1:size(res.sumabspervox,1)
                figure;
                hold on
                subplot(2,2,1)
                hold on
                plot(squeeze(res.sumabspervox(ksub,1,:,1)),'k'); %wx orig
                plot(squeeze(res.sumabspervox(ksub,2,:,1)),'r'); %wx dico
                plot(squeeze(res.sumabspervox(ksub,1,:,1)-res.sumabspervox(ksub,2,:,1)),'b'); %wx diff
                xlabel('x');
                ylim([0 1.5]);
                xlim([0 size(res.wx.sumabspervox,3)]);
                hold on
                subplot(2,2,2)
                hold on
                plot(squeeze(res.sumabspervox(ksub,1,:,2)),'k'); %wy orig
                plot(squeeze(res.sumabspervox(ksub,2,:,2)),'r'); %wy dico
                plot(squeeze(res.sumabspervox(ksub,1,:,2)-res.sumabspervox(ksub,2,:,2)),'b'); %wy diff
                xlabel('y');
                ylim([0 1.5]);
                hold on
                subplot(2,2,3)
                hold on
                plot(squeeze(res.sumabspervox(ksub,1,:,3)),'k'); %wz orig
                plot(squeeze(res.sumabspervox(ksub,2,:,3)),'r'); %wz dico
                plot(squeeze(res.sumabspervox(ksub,1,:,3)-res.sumabspervox(ksub,2,:,3)),'b'); %wx diff
                xlabel('z');
                ylim([0 1.5]);
                legend('orig','dico');
                
                set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
                [ax4,h3] = suplabel(['distpervox ' int2str(ksub)],'t');
                set(h3,'FontSize',20);
                set(h3,'Interpreter','none');
                export_fig(fullfile(PIC_DIR,['disppervox_' txtstr '_' int2str(ksub)]));
                close
            end
            
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function plot_corrfieldvsdist(PROJ_DIR,txtstr)
            
            load(fullfile(PROJ_DIR,['res_corrfieldvsdist_distpervox_' txtstr '.mat']));
            
            PIC_DIR = fullfile(PROJ_DIR,'PICS');
            
            for ksub = 1:size(res.corfield_r,1)
                figure;
                hold on
                subplot(2,2,1)
                hold on
                plot(squeeze(res.corfield_r(ksub,1,:,1)),'k'); %wx orig
                plot(squeeze(res.corfield_r(ksub,2,:,1)),'r'); %wx dico
                plot(squeeze(res.corfield_r(ksub,1,:,1)-res.corfield_r(ksub,2,:,1)),'b'); %wx diff
                xlabel('x');
                ylim([-1.5 1.5]);
                hold on
                subplot(2,2,2)
                hold on
                plot(squeeze(res.corfield_r(ksub,1,:,2)),'k'); %wy orig
                plot(squeeze(res.corfield_r(ksub,2,:,2)),'r'); %wy dico
                plot(squeeze(res.corfield_r(ksub,1,:,2)-res.corfield_r(ksub,2,:,2)),'b'); %wy diff
                xlabel('y');
                ylim([-1.5 1.5]);
                hold on
                subplot(2,2,3)
                hold on
                plot(squeeze(res.corfield_r(ksub,1,:,3)),'k'); %wz orig
                plot(squeeze(res.corfield_r(ksub,2,:,3)),'r'); %wz dico
                plot(squeeze(res.corfield_r(ksub,1,:,3)-res.corfield_r(ksub,2,:,3)),'b'); %wx diff
                xlabel('z');
                ylim([-1.5 1.5]);
                legend('orig','dico');
                
                set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
                [ax4,h3] = suplabel(['correlation ' int2str(ksub)],'t');
                set(h3,'FontSize',20);
                set(h3,'Interpreter','none');
                export_fig(fullfile(PIC_DIR,['correlation_' txtstr '_' int2str(ksub)]));
                close
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function plot_corrfieldvsdist_all(PROJ_DIR,txtstr)
            
            load(fullfile(PROJ_DIR,['res_corrfieldvsdist_distpervox_' txtstr '.mat']));
            
            PIC_DIR = fullfile(PROJ_DIR,'PICS');
            R_DATA = res.corfield_r;
            [h_all,p_all] = ttest(R_DATA(:,1,:,:),R_DATA(:,2,:,:));
            
            R_DATA(isnan(R_DATA)) = 0;
            
            for kslice = 1:size(R_DATA,3) % Slices
                for kmod = 1:3
                    [ps_all(kslice,kmod),hs_all(kslice,kmod)] = signrank(squeeze(R_DATA(:,1,kslice,kmod)),squeeze(R_DATA(:,2,kslice,kmod)));
                    %    disp([kslice kmod]);
                end
            end
            
            P_all = squeeze(p_all);
            PS_all = squeeze(ps_all);
            
            figure;
            hold on
            for kmod = 1:3
                
                subplot(2,2,kmod)
                hold on
                DATA_orig_r = squeeze(res.corfield_r(:,1,:,kmod)); % orig
                orig_mean_r = mean(DATA_orig_r,1);
                orig_std_r = std(DATA_orig_r,1);
                errorbar(orig_mean_r,orig_std_r,'k');
                DATA_dico_r = squeeze(res.corfield_r(:,2,:,kmod)); % dico
                dico_mean_r = mean(DATA_dico_r,1);
                dico_std_r = std(DATA_dico_r,1);
                errorbar(dico_mean_r,dico_std_r,'r');
                switch kmod
                    case 1
                        xlabel('x');
                        legend('orig','dico','p-ttest','p-signrank','Location','Best');
                    case 2
                        xlabel('y');
                    case 3
                        xlabel('z');
                end
                
                ylim([-0.5 1.2]);
                hline2(0.05,'k');
                hline2(0,'k');
                plot(P_all(:,kmod),'b');
                plot(PS_all(:,kmod),'b--');
                xlim([0 size(R_DATA,3)]);
            end
            
            set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
            [ax4,h3] = suplabel('CorrelationAll','t');
            set(h3,'FontSize',20);
            set(h3,'Interpreter','none');
            export_fig(fullfile(PIC_DIR,['CorrelationAll_' txtstr ]));
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function plot_distpervox_all(PROJ_DIR,txtstr)
            
            load(fullfile(PROJ_DIR,['res_corrfieldvsdist_distpervox_' txtstr '.mat']));
            
            PIC_DIR = fullfile(PROJ_DIR,'PICS');
            R_DATA = res.sumabspervox;
            [h_all,p_all] = ttest(R_DATA(:,1,:,:),R_DATA(:,2,:,:));
            
            R_DATA(isnan(R_DATA)) = 0;
            
            for kslice = 1:size(R_DATA,3) % Slices
                for kmod = 1:3
                    [ps_all(kslice,kmod),hs_all(kslice,kmod)] = signrank(squeeze(R_DATA(:,1,kslice,kmod)),squeeze(R_DATA(:,2,kslice,kmod)));
                    %    disp([kslice kmod]);
                end
            end
            
            P_all = squeeze(p_all);
            PS_all = squeeze(ps_all);
            
            figure;
            hold on
            for kmod = 1:3
                
                subplot(2,2,kmod)
                hold on
                DATA_orig_r = squeeze(R_DATA(:,1,:,kmod)); % orig
                orig_mean_r = mean(DATA_orig_r,1);
                orig_std_r = std(DATA_orig_r,1);
                errorbar(orig_mean_r,orig_std_r,'k');
                DATA_dico_r = squeeze(R_DATA(:,2,:,kmod)); % dico
                dico_mean_r = mean(DATA_dico_r,1);
                dico_std_r = std(DATA_dico_r,1);
                errorbar(dico_mean_r,dico_std_r,'r');
                switch kmod
                    case 1
                        xlabel('x');
                        legend('orig','dico','p-ttest','p-signrank','Location','Best');
                    case 2
                        xlabel('y');
                    case 3
                        xlabel('z');
                end
                
                ylim([-0.5 1.5]);
                hline2(0.05,'k');
                hline2(0,'k');
                plot(P_all(:,kmod),'b');
                plot(PS_all(:,kmod),'b--');
                xlim([0 size(R_DATA,3)]);
            end
            
            set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
            [ax4,h3] = suplabel('DisppervoxAll','t');
            set(h3,'FontSize',20);
            set(h3,'Interpreter','none');
            export_fig(fullfile(PIC_DIR,['DisppervoxAll_' txtstr ]));
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function combine_realign(PROJ_DIR,Asubject,subjectlist)
            
            for ksub = subjectlist
                disp(['Subnum: ' int2str(ksub)]);
                
                DATA_SUB = fullfile(PROJ_DIR,Asubject(ksub).name);
                RAWN_SUB = fullfile(DATA_SUB,'RAWN');
                
                tmp_RL = load(fullfile(RAWN_SUB,'rp_RL_dyn_ma0001.txt'));
                comball.rp(ksub,:,:)= tmp_RL;
            end
            
            save(fullfile(PROJ_DIR,'comball_rp.mat'),'comball');
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function inversion_tomography(PROJ_DIR,Asubject,subjectlist)
            disp('inversion MRE tomography data...');
            
            for kdatamod = {'','r','u','ur'}
                
                for ksub = subjectlist
                    disp(['Subnum: ' int2str(ksub)]);
                    
                    DATA_SUB = fullfile(PROJ_DIR,Asubject(ksub).name);
                    ANA_SUB = fullfile(DATA_SUB,'ANA');
                    MODICO_SUB = fullfile(DATA_SUB,'MODICO');
                    mkdir(MODICO_SUB);
                    
                    cd(MODICO_SUB);
                    PH = spm_read_vols(spm_vol([cell2str(kdatamod) 'RL_dyn_p_4D.nii']));
                    MA = spm_read_vols(spm_vol([cell2str(kdatamod) 'RL_dyn_m_4D.nii']));
                    
                    disp(size(PH))
                    
                    Phase = reshape(PH,[88 100 40 8 3 3]);
                    Magnitude = reshape(MA,[88 100 40 8 3 3]);
                    
                    Phase = Phase/4096*2*pi;
                    
                    MRsignal = Magnitude .* exp(1i*Phase);
                    
                    spatialResolution = [2.0 2.0]/1000;
                    frequency = [30 40 50]; %Frequenzen;
                    
                    for sigma = 2:0.25:3
                        for n = 8:4:24
                            if ~exist(fullfile(ANA_SUB,['kMDEV_' cell2str(kdatamod) '_' int2str(n) '_' int2str(sigma*1E2) '.mat']),'file')
                                disp([cell2str(kdatamod) '_' int2str(ksub) '_' int2str(sigma) '_' int2str(n)]);
                                %    n = 12;
                                %tic
                                [c, Lambda, amplitude] = kMDEV( MRsignal, spatialResolution, frequency,sigma*1E-3,n);
                                %t=toc;
                                %fprintf(t);
                                %plot2dwaves(c.standard);
                                %caxis([0 3]);
                                save(fullfile(ANA_SUB,['kMDEV_' cell2str(kdatamod) '_' int2str(n) '_' int2str(sigma*1E2) '.mat']),'c','Lambda');
                            end
                        end
                    end
                end
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function combine_tomography(PROJ_DIR,Asubject,subjectlist)
            disp('combine_tomography');
            
            ksig = 0;
            for sigma = 2:0.25:3
                ksig = ksig + 1;
                kn = 0;
                for n = 8:4:24
                    kn = kn+1;
                    kprocess = 0;
                    for kdatamod = {'','r'} %,'u','ur'}
                        kprocess = kprocess +1 ;
                        for ksub = subjectlist
                            disp(['Subnum: ' int2str(ksub)]);
                            DATA_SUB = fullfile(PROJ_DIR,Asubject(ksub).name);
                            ANA_SUB = fullfile(DATA_SUB,'ANA');
                            
                            load(fullfile(ANA_SUB,['kMDEV_' cell2str(kdatamod) '_' int2str(n) '_' int2str(sigma*1E2) '.mat']));
                            comb3D_MREPARA.vmap(:,:,:,ksub,kprocess,ksig,kn) = c.standard;
                        end
                    end
                    save(fullfile(PROJ_DIR,['comb3D_MREPARA_vmap_' int2str(sigma*1E2) '_' int2str(kn) '.mat']),'comb3D_MREPARA');
                end
                
            end
            
            
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function antsRegistration_mre2mprage(PROJ_DIR,Asubject,subjectlist)
            disp('inversion antsRegistration...');
            
            for ksub =  subjectlist
                disp(['Subnum: ' int2str(ksub)]);
                
                DATA_SUB = fullfile(PROJ_DIR,Asubject(ksub).name);
                SEGNORM_SUB = fullfile(DATA_SUB,'SEGNORM');
                
                cd(SEGNORM_SUB);
                if ~exist('MREdicoma2mprage_InverseWarped.nii','file')
                    system('antsRegistrationSyNQuick.sh -d 3 -f mprage_reorient2standard.nii -m RLdicoma.nii -o MREdicoma2mprage_');
                end
                
                if ~exist('mprage2MREdicoma_InverseWarped.nii','file')
                    system('antsRegistrationSyNQuick.sh -d 3 -m mprage_reorient2standard.nii -f RLdicoma.nii -o mprage2MREdicoma_');
                end
                
                if ~exist('fieldMAGRL2mprage_InverseWarped.nii','file')
                    system('antsRegistrationSyNQuick.sh -d 3 -f mprage_reorient2standard.nii -m fieldMAGRL.nii -o fieldMAGRL2mprage_');
                end
                
                if ~exist('mprage2fieldMAGRL_InverseWarped.nii','file')
                    system('antsRegistrationSyNQuick.sh -d 3 -m mprage_reorient2standard.nii -f fieldMAGRL.nii -o mprage2fieldMAGRL_');
                end
                
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function antsBrainExtract(PROJ_DIR,Asubject,subjectlist)
            disp('inversion antsRegistration...');
            
            for ksub = subjectlist %1:length(Asubject)
                disp(['Subnum: ' int2str(ksub)]);
                
                DATA_SUB = fullfile(PROJ_DIR,Asubject(ksub).name);
                SEGNORM_SUB = fullfile(DATA_SUB,'SEGNORM');
                
                cd(SEGNORM_SUB);
                tic
                if ~exist('ext_BrainExtractionBrain.nii','file')
                    system('antsBrainExtraction.sh -d 3 -a mprage_reorient2standard.nii -e /media/afdata/project_modico/NKI/T_template.nii.gz -m /media/afdata/project_modico/NKI/T_templateProbabilityMask.nii.gz -o ext2std_');
                end
                t=toc;
                disp('BrainExtraction');
                disp(t);
                %                 if ~exist('extr2std_BrainExtractionBrain.nii','file')
                %                     system('antsBrainExtraction.sh -d 3 -a mprage_reorient2standard.nii -e /media/afdata/project_modico/NKI/T_template.nii.gz -m /media/afdata/project_modico/NKI/T_templateProbabilityMask.nii.gz -o extr2std_');
                %                 end
                
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function reorient2standard(PROJ_DIR,Asubject,subjectlist)
            disp('reorient2standard...');
            for ksub = subjectlist
                disp(['Subnum: ' int2str(ksub)]);
                
                DATA_SUB = fullfile(PROJ_DIR,Asubject(ksub).name);
                SEGNORM_SUB = fullfile(DATA_SUB,'SEGNORM');
                
                cd(SEGNORM_SUB);
                if ~exist('mprage_reorient2standard.nii','file')
                    !fsl5.0-fslreorient2std mprage.nii mprage_reorient2standard.nii
                    !gunzip -f *.gz
                end
            end
            
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    end
end


