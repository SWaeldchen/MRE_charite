function af_calccorr_parOverlap2(PROJ_DIR,Asubject)

mkdir(fullfile(PROJ_DIR,'MI_DIR'));
% space = 'EPI';
% normtxtstr = 'epi2ana';

space = 'MNI';
normtxtstr = 'epi2mni';

for subj =  1:length(Asubject) %:numel(Asubject)
    
    cd(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA'));
    system('fsl5.0-fslsplit wTPM.nii TPM');    
    system('gunzip -f *.gz');
    
    B0 = spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA','wmyfield.nii')));
    
    MASK_1 = ones(size(B0)); %(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA','wMAGm_orig_mask.nii'))));
    MASK_2 = ones(size(B0)); %(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA','wMAGm_moco_mask.nii'))));
    MASK_3 = ones(size(B0)); %(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA','wMAGm_dico_mask.nii'))));
    MASK_4 = ones(size(B0)); %(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA','wMAGm_modico_mask.nii'))));
    
    MASK_orig = ones(size(B0)); %MASK_1;
    MASK_dico = ones(size(B0)); %MASK_3;
    
    SEG_1(:,:,:,1) = (spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[space '_c1_' normtxtstr '_1.nii']))));
    SEG_1(:,:,:,2) = (spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[space '_c2_' normtxtstr '_1.nii']))));
    SEG_1(:,:,:,3) = (spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[space '_c3_' normtxtstr '_1.nii']))));
    SEG_1(:,:,:,4) = (spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[space '_c4_' normtxtstr '_1.nii']))));
    
    SEG_2(:,:,:,1) = (spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[space '_c1_' normtxtstr '_2.nii']))));
    SEG_2(:,:,:,2) = (spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[space '_c2_' normtxtstr '_2.nii']))));
    SEG_2(:,:,:,3) = (spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[space '_c3_' normtxtstr '_2.nii']))));
    SEG_2(:,:,:,4) = (spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[space '_c4_' normtxtstr '_2.nii']))));
    
    SEG_3(:,:,:,1) = (spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[space '_c1_' normtxtstr '_3.nii']))));
    SEG_3(:,:,:,2) = (spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[space '_c2_' normtxtstr '_3.nii']))));
    SEG_3(:,:,:,3) = (spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[space '_c3_' normtxtstr '_3.nii']))));
    SEG_3(:,:,:,4) = (spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[space '_c4_' normtxtstr '_3.nii']))));
    
    SEG_4(:,:,:,1) = (spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[space '_c1_' normtxtstr '_4.nii']))));
    SEG_4(:,:,:,2) = (spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[space '_c2_' normtxtstr '_4.nii']))));
    SEG_4(:,:,:,3) = (spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[space '_c3_' normtxtstr '_4.nii']))));
    SEG_4(:,:,:,4) = (spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[space '_c4_' normtxtstr '_4.nii']))));
    
    SEG_orig(:,:,:,1) = (spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[space '_c1_' normtxtstr '_orig.nii']))));
    SEG_orig(:,:,:,2) = (spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[space '_c2_' normtxtstr '_orig.nii']))));
    SEG_orig(:,:,:,3) = (spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[space '_c3_' normtxtstr '_orig.nii']))));
    SEG_orig(:,:,:,4) = (spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[space '_c4_' normtxtstr '_orig.nii']))));
    
    SEG_dico(:,:,:,1) = (spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[space '_c1_' normtxtstr '_dico.nii']))));
    SEG_dico(:,:,:,2) = (spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[space '_c2_' normtxtstr '_dico.nii']))));
    SEG_dico(:,:,:,3) = (spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[space '_c3_' normtxtstr '_dico.nii']))));
    SEG_dico(:,:,:,4) = (spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[space '_c4_' normtxtstr '_dico.nii']))));
    
    wABSG(:,:,:,1) = (spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA','wABSG_orig.nii'))));
    wABSG(:,:,:,2) = (spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA','wABSG_moco.nii'))));
    wABSG(:,:,:,3) = (spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA','wABSG_dico.nii'))));
    wABSG(:,:,:,4) = (spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA','wABSG_modico.nii'))));
    
    wABSG_nc(:,:,:,1) = (spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA','wABSG_orig_nc.nii'))));
    wABSG_nc(:,:,:,2) = (spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA','wABSG_moco_nc.nii'))));
    wABSG_nc(:,:,:,3) = (spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA','wABSG_dico_nc.nii'))));
    wABSG_nc(:,:,:,4) = (spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA','wABSG_modico_nc.nii'))));
    
    MNI_TPM(:,:,:,1) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA','TPM0000.nii')));
    MNI_TPM(:,:,:,2) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA','TPM0001.nii')));
    MNI_TPM(:,:,:,3) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA','TPM0002.nii')));
    MNI_TPM(:,:,:,4) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA','TPM0003.nii')));
    MNI_TPM(:,:,:,5) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA','TPM0004.nii')));
    MNI_TPM(:,:,:,6) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA','TPM0005.nii')));

ithres = 0;
for kthres = 0.7:0.05:0.9
ithres = ithres+1;
for kmask = 1:3
for kslice=1:79
      RES_1_TPM(kslice,kmask,subj,ithres) = corr2(SEG_1(:,:,kslice,kmask).*MASK_1(:,:,kslice)>kthres,MNI_TPM(:,:,kslice,kmask).*MASK_1(:,:,kslice)>kthres);
      RES_2_TPM(kslice,kmask,subj,ithres) = corr2(SEG_2(:,:,kslice,kmask).*MASK_2(:,:,kslice)>kthres,MNI_TPM(:,:,kslice,kmask).*MASK_2(:,:,kslice)>kthres);
      RES_3_TPM(kslice,kmask,subj,ithres) = corr2(SEG_3(:,:,kslice,kmask).*MASK_3(:,:,kslice)>kthres,MNI_TPM(:,:,kslice,kmask).*MASK_3(:,:,kslice)>kthres);
      RES_4_TPM(kslice,kmask,subj,ithres) = corr2(SEG_4(:,:,kslice,kmask).*MASK_4(:,:,kslice)>kthres,MNI_TPM(:,:,kslice,kmask).*MASK_4(:,:,kslice)>kthres);
      RES_orig_TPM(kslice,kmask,subj,ithres) = corr2(SEG_orig(:,:,kslice,kmask).*MASK_orig(:,:,kslice)>kthres,MNI_TPM(:,:,kslice,kmask).*MASK_orig(:,:,kslice)>kthres);
      RES_dico_TPM(kslice,kmask,subj,ithres) = corr2(SEG_dico(:,:,kslice,kmask).*MASK_dico(:,:,kslice)>kthres,MNI_TPM(:,:,kslice,kmask).*MASK_dico(:,:,kslice)>kthres);
end
end
end

for kmask = 1:3
    for kmod = 1:4
        for kslice=1:79
            RES_wABSG_nc(kslice,kmask,subj,kmod) = corr2(wABSG_nc(:,:,kslice,kmod),MNI_TPM(:,:,kslice,kmask));
            RES_wABSG(kslice,kmask,subj,kmod) = corr2(wABSG(:,:,kslice,kmod),MNI_TPM(:,:,kslice,kmask));
        end
    end
end

for kmask = 1:3
dB = 10; % frequency step [Hz]
for k = 1:31
    B = 10*(k-16); % -150 .. +150 Hz
    
     TMP_ROI = ((B-dB/2 < B0) & (B+dB/2> B0)); 
     
     MASK_SEG1 = SEG_1(:,:,:,1)+SEG_1(:,:,:,2)+SEG_1(:,:,:,3) > 0.9;
     MASK_SEG2 = SEG_2(:,:,:,1)+SEG_2(:,:,:,2)+SEG_2(:,:,:,3) > 0.9;
     MASK_SEG3 = SEG_3(:,:,:,1)+SEG_3(:,:,:,2)+SEG_3(:,:,:,3) > 0.9;
     MASK_SEG4 = SEG_4(:,:,:,1)+SEG_4(:,:,:,2)+SEG_4(:,:,:,3) > 0.9;
     MASK_SEGorig = SEG_orig(:,:,:,1)+SEG_orig(:,:,:,2)+SEG_orig(:,:,:,3) > 0.9;
     MASK_SEGdico = SEG_dico(:,:,:,1)+SEG_dico(:,:,:,2)+SEG_dico(:,:,:,3) > 0.9;
     
     TMP_SEG1 = SEG_1(:,:,:,kmask) .* TMP_ROI .* MASK_1 .* MASK_SEG1;
     TMP_SEG2 = SEG_2(:,:,:,kmask) .* TMP_ROI .* MASK_2 .* MASK_SEG2;
     TMP_SEG3 = SEG_3(:,:,:,kmask) .* TMP_ROI .* MASK_3 .* MASK_SEG3;
     TMP_SEG4 = SEG_4(:,:,:,kmask) .* TMP_ROI .* MASK_4 .* MASK_SEG4;
     TMP_SEGorig = SEG_orig(:,:,:,kmask) .* TMP_ROI .* MASK_orig .* MASK_SEGorig;
     TMP_SEGdico = SEG_dico(:,:,:,kmask) .* TMP_ROI .* MASK_dico .* MASK_SEGdico;
   
     TMP_ABSG_nc1 = wABSG_nc(:,:,:,1) .* TMP_ROI .* MASK_SEG1;
     TMP_ABSG_nc2 = wABSG_nc(:,:,:,2) .* TMP_ROI .* MASK_SEG2;
     TMP_ABSG_nc3 = wABSG_nc(:,:,:,3) .* TMP_ROI .* MASK_SEG3;
     TMP_ABSG_nc4 = wABSG_nc(:,:,:,4) .* TMP_ROI .* MASK_SEG4;     
     TMP_ABSG1 = wABSG(:,:,:,1) .* TMP_ROI .* MASK_SEG1;
     TMP_ABSG2 = wABSG(:,:,:,2) .* TMP_ROI .* MASK_SEG2;
     TMP_ABSG3 = wABSG(:,:,:,3) .* TMP_ROI .* MASK_SEG3;
     TMP_ABSG4 = wABSG(:,:,:,4) .* TMP_ROI .* MASK_SEG4;   
     
     TMP_TPM = MNI_TPM(:,:,:,kmask) .* TMP_ROI;
     
     TMP_TPM1 = TMP_TPM .* MASK_SEG1;
     TMP_TPM2 = TMP_TPM .* MASK_SEG2;
     TMP_TPM3 = TMP_TPM .* MASK_SEG3;
     TMP_TPM4 = TMP_TPM .* MASK_SEG4;
     TMP_TPMorig = TMP_TPM .* MASK_SEGorig;
     TMP_TPMdico = TMP_TPM .* MASK_SEGdico;
     
     BSEG1(k,kmask,subj) = corr2(TMP_SEG1(:),TMP_TPM1(:));
     BSEG2(k,kmask,subj) = corr2(TMP_SEG2(:),TMP_TPM2(:));
     BSEG3(k,kmask,subj) = corr2(TMP_SEG3(:),TMP_TPM3(:));
     BSEG4(k,kmask,subj) = corr2(TMP_SEG4(:),TMP_TPM4(:));
     BSEGorig(k,kmask,subj) = corr2(TMP_SEGorig(:),TMP_TPMorig(:));
     BSEGdico(k,kmask,subj) = corr2(TMP_SEGdico(:),TMP_TPMdico(:));     
    
     BA1(k,kmask,subj) = corr2(TMP_ABSG1(:),TMP_TPM1(:));
     BA2(k,kmask,subj) = corr2(TMP_ABSG2(:),TMP_TPM2(:));
     BA3(k,kmask,subj) = corr2(TMP_ABSG3(:),TMP_TPM3(:));
     BA4(k,kmask,subj) = corr2(TMP_ABSG4(:),TMP_TPM4(:));     
     BAnc1(k,kmask,subj) = corr2(TMP_ABSG_nc1(:),TMP_TPM1(:));
     BAnc2(k,kmask,subj) = corr2(TMP_ABSG_nc2(:),TMP_TPM2(:));
     BAnc3(k,kmask,subj) = corr2(TMP_ABSG_nc3(:),TMP_TPM3(:));
     BAnc4(k,kmask,subj) = corr2(TMP_ABSG_nc4(:),TMP_TPM4(:));

     
end
end

disp('----------------------------------------');
disp('Overlap statistik');
segthres = 0.5;
mnithres = 0.5;

for kmask = 1:3
    
    for kslice=1:79
        ASEG_1(:,:,kslice) = 2*double(SEG_1(:,:,kslice,kmask)>segthres);
        ASEG_2(:,:,kslice) = 2*double(SEG_2(:,:,kslice,kmask)>segthres);
        ASEG_3(:,:,kslice) = 2*double(SEG_3(:,:,kslice,kmask)>segthres);
        ASEG_4(:,:,kslice) = 2*double(SEG_4(:,:,kslice,kmask)>segthres);
        ASEG_orig(:,:,kslice) = 2*double(SEG_orig(:,:,kslice,kmask)>segthres);
        ASEG_dico(:,:,kslice) = 2*double(SEG_dico(:,:,kslice,kmask)>segthres);
        B1(:,:,kslice) = MNI_TPM(:,:,kslice,kmask)>mnithres;
    end
    
    AB(:,:,:,1) = double(ASEG_1) + double(B1);
    AB(:,:,:,2) = double(ASEG_2) + double(B1);
    AB(:,:,:,3) = double(ASEG_3) + double(B1);
    AB(:,:,:,4) = double(ASEG_4) + double(B1);
    AB(:,:,:,5) = double(ASEG_orig) + double(B1);
    AB(:,:,:,6) = double(ASEG_dico) + double(B1);
    
    for kmod = 1:6
    for kslice = 1:79
        
        kTMPslice = AB(:,:,kslice,kmod);
        nonzerovoxel(kslice,kmask,subj,kmod) = sum(sum(kTMPslice~=0));        
        Nonlyseg(kslice,kmask,subj,kmod) = sum(sum(kTMPslice==1)) / nonzerovoxel(kslice,kmask,subj);
        Nonlytpm(kslice,kmask,subj,kmod) = sum(sum(kTMPslice==2)) / nonzerovoxel(kslice,kmask,subj);
        overlap(kslice,kmask,subj,kmod)  = sum(sum(kTMPslice==3)) / nonzerovoxel(kslice,kmask,subj);        
    end
    end
end

%     
%     for kslice=1:79
%     if strcmp(id,'data3T')
%         threshold = 200;
%     end
%     
%     if strcmp(id,'data7T')
%         threshold = 100;
%     end
%     
%     MAGf1 = createmaskgetCC(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA'),[prestr 'MAGf_orig.nii'],threshold);
%     MAGf2 = createmaskgetCC(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA'),[prestr 'MAGf_dico.nii'],threshold);
%     
%     BWMAGf = MAGf1.*MAGf2;
%     disp('sizeMAGf');
%     disp(size(BWMAGf));
%     
%     BW1 = createmaskgetCC(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA'),[prestr 'MAGm_orig.nii'],threshold);

%     BW2 = createmaskgetCC(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA'),[prestr 'MAGm_moco.nii'],threshold);
%     BW3 = createmaskgetCC(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA'),[prestr 'MAGm_dico.nii'],threshold);
%     BW4 = createmaskgetCC(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA'),[prestr 'MAGm_modico.nii'],threshold);
%     
%     MAGBW12 = BW1.*BW2;    
%     MAGBW14 = BW1.*BW4;
%     MAGBW34 = BW3.*BW4;

end

save(fullfile(PROJ_DIR,'Group_Corr2.mat'),'RES_1_TPM','RES_2_TPM','RES_3_TPM','RES_4_TPM','RES_orig_TPM','RES_dico_TPM',...
    'BSEG1','BSEG2','BSEG3','BSEG4','BSEGorig','BSEGdico',...
    'nonzerovoxel','Nonlyseg','Nonlytpm','overlap',...
    'RES_wABSG_nc','RES_wABSG',...
    'BA1','BA2','BA3','BA4',...
    'BAnc1','BAnc2','BAnc3','BAnc4');

end


function BW = createmaskgetCC(DATA_DIR,filename1,threshold)
        A = spm_read_vols(spm_vol(fullfile(DATA_DIR,filename1))) > threshold;
        A_tmp = zeros(size(A));
        BW = zeros(size(A));
        for kslice = 1:size(A,3)
            %disp(kslice);
            if sum(sum((A(:,:,kslice)))) == 0
                A_tmp(:,:,kslice) = 0;
            else
                A_tmp(:,:,kslice) = getLargestCc(A(:,:,kslice),4,1);
            end
            BW(:,:,kslice) = imfill(A_tmp(:,:,kslice),'holes');
        end
end