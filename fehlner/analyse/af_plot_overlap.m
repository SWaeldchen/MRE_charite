function af_plot_overlap(PROJ_DIR,id,prestr)

if ~exist('PROJ_DIR','var')
    id = 'data3T';
    prestr = 'w';
    PROJ_DIR = '/store01_analysis/stefanh/MRDATA/MODICOISMRM/3T/';
end

if ~exist('PROJ_DIR','var')
    id = 'data3T';
    %     prestr = 'w';
    %     PROJ_DIR = '/store01_analysis/stefanh/MRDATA/MODICOISMRM/7T/';
end

PIC_DIR = fullfile(PROJ_DIR,'PICS');
%if strcmp(id,'data3T');
nslices = 79;
nproband = 14;
xlimits = [20 70];
%end

% if strcmp(id,'data7T');
%     nslices = 156;
%     nproband = 18;
%     xlimits = [100 150];
% end


%load(fullfile(PROJ_DIR,['MI_id' id '_prestr' prestr 'data.mat']));

load(fullfile(PROJ_DIR,'Group_Corr2.mat'));

%[ht_all2,pt_all2] = ttest(MI_mpragevsMfo_all',MI_mpragevsMfc_all');

for ithres = 1 %:3 %size(RES_1_TPM,4)
    for kcase = 1 %:15 %1:4
        disp([ithres kcase]);
        %if kcase == 1, DATA1 = MI_mpragevsMo12_all; DATA1str = 'mpragevsMo12'; DATA2 = MI_mpragevsMm12_all; DATA2str = 'mpragevsMm12'; end
        %if kcase == 2, DATA1 = MI_mpragevsMo14_all; DATA1str = 'mpragevsMo14'; DATA2 = MI_mpragevsMmd14_all; DATA2str = 'mpragevsMmd14'; end
        %if kcase == 3, DATA1 = MI_mpragevsMd34_all; DATA1str = 'mpragevsMd34'; DATA2 = MI_mpragevsMmd34_all; DATA2str = 'mpragevsMmd34'; end
        %if kcase == 4, DATA1 = MI_mpragevsMfo_all;  DATA1str = 'mpragevsMfo'; DATA2 = MI_mpragevsMfc_all; DATA2str = 'mpragevsMfc'; end
        %if kcase == 16, DATA1 = MI_mpragevsMd34_all; DATA1str = 'mpragevsMd34'; DATA2 = MI_mpragevsMmd_all; DATA2str = 'mpragevsMmd'; end
        
        if kcase == 1, DATA1 = squeeze(RES_1_TPM(:,1,:,ithres));  DATA1str = 'MAGm-orig-tissue1'; DATA2 = squeeze(RES_2_TPM(:,1,:,ithres)); DATA2str = 'MAGm-moco-tissue1'; end
        if kcase == 2, DATA1 = squeeze(RES_1_TPM(:,1,:,ithres));  DATA1str = 'MAGm-orig-tissue1'; DATA2 = squeeze(RES_3_TPM(:,1,:,ithres)); DATA2str = 'MAGm-dico-tissue1'; end
        if kcase == 3, DATA1 = squeeze(RES_1_TPM(:,1,:,ithres));  DATA1str = 'MAGm-orig-tissue1'; DATA2 = squeeze(RES_4_TPM(:,1,:,ithres)); DATA2str = 'MAGm-modico-tissue1'; end
        if kcase == 4, DATA1 = squeeze(RES_1_TPM(:,1,:,ithres));  DATA1str = 'MAGm-orig-tissue1'; DATA2 = squeeze(RES_4_TPM(:,1,:,ithres)); DATA2str = 'MAGm-modico-tissue1'; end
        if kcase == 5, DATA1 = squeeze(RES_orig_TPM(:,1,:,ithres));  DATA1str = 'MAGf-orig-tissue1'; DATA2 = squeeze(RES_dico_TPM(:,1,:,ithres)); DATA2str = 'MAGf-dico-tissue1'; end
        
        if kcase == 6, DATA1 = squeeze(RES_1_TPM(:,2,:,ithres));  DATA1str = 'MAGm-orig-tissue2'; DATA2 = squeeze(RES_2_TPM(:,2,:,ithres)); DATA2str = 'MAGm-moco-tissue2'; end
        if kcase == 7, DATA1 = squeeze(RES_1_TPM(:,2,:,ithres));  DATA1str = 'MAGm-orig-tissue2'; DATA2 = squeeze(RES_3_TPM(:,2,:,ithres)); DATA2str = 'MAGm-dico-tissue2'; end
        if kcase == 8, DATA1 = squeeze(RES_1_TPM(:,2,:,ithres));  DATA1str = 'MAGm-orig-tissue2'; DATA2 = squeeze(RES_4_TPM(:,2,:,ithres)); DATA2str = 'MAGm-modico-tissue2'; end
        if kcase == 9, DATA1 = squeeze(RES_1_TPM(:,2,:,ithres));  DATA1str = 'MAGm-orig-tissue2'; DATA2 = squeeze(RES_4_TPM(:,2,:,ithres)); DATA2str = 'MAGm-modico-tissue2'; end
        if kcase == 10, DATA1 = squeeze(RES_orig_TPM(:,2,:,ithres));  DATA1str = 'MAGf-orig-tissue2'; DATA2 = squeeze(RES_dico_TPM(:,2,:,ithres)); DATA2str = 'MAGf-dico-tissue2'; end
        
        if kcase == 11, DATA1 = squeeze(RES_1_TPM(:,3,:,ithres));  DATA1str = 'MAGm-orig-tissue3'; DATA2 = squeeze(RES_2_TPM(:,3,:,ithres)); DATA2str = 'MAGm-moco-tissue3'; end
        if kcase == 12, DATA1 = squeeze(RES_1_TPM(:,3,:,ithres));  DATA1str = 'MAGm-orig-tissue3'; DATA2 = squeeze(RES_3_TPM(:,3,:,ithres)); DATA2str = 'MAGm-dico-tissue3'; end
        if kcase == 13, DATA1 = squeeze(RES_1_TPM(:,3,:,ithres));  DATA1str = 'MAGm-orig-tissue3'; DATA2 = squeeze(RES_4_TPM(:,3,:,ithres)); DATA2str = 'MAGm-modico-tissue3'; end
        if kcase == 14, DATA1 = squeeze(RES_1_TPM(:,3,:,ithres));  DATA1str = 'MAGm-orig-tissue3'; DATA2 = squeeze(RES_4_TPM(:,3,:,ithres)); DATA2str = 'MAGm-modico-tissue3'; end
        if kcase == 15, DATA1 = squeeze(RES_orig_TPM(:,3,:,ithres));  DATA1str = 'MAGf-orig-tissue3'; DATA2 = squeeze(RES_dico_TPM(:,3,:,ithres)); DATA2str = 'MAGf-dico-tissue3'; end
        
                
        
        mDATA1 = DATA1;
        mDATA2 = DATA2;
        
        mDATA1(isnan(mDATA1)) = 0;
        mDATA2(isnan(mDATA2)) = 0;
        
        disp('data1');
        disp(size(mDATA1));
        disp('data2');
        disp(size(mDATA2));
        
        for kslice = 1:size(DATA1,1)
            [p_signrank(kslice),h_signrank(kslice)] = signrank(squeeze(mDATA1(kslice,:)),squeeze(mDATA2(kslice,:)));
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        figure
        hold on,
        mseb([],mean(DATA1,2)',std(DATA1,[],2)',[],1);
        % hold on, plot(DATA1,'b.')
        lineProps.col={'r'}; mseb([],mean(DATA2,2)',std(DATA2,[],2)',lineProps,1);
        % hold on, plot(DATA2,'r.')
        plot(mean(DATA2,2) - mean(DATA1,2),'g');
        hline2(0.05);
        plot(p_signrank,'k-.');
        hold on
        plot(h_signrank/2,'c-.');
        hold on
        ylim([-0.1 1]);
        xlim(xlimits);
        
        xlabel([ 'Correlation: p signrank' id ' ' prestr '_' int2str(ithres)]);
        set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
        legend(DATA1str,DATA2str);
        
         save(fullfile(PIC_DIR,['final_slice_Correlationvswmeanmprage_' id '_' prestr '_' DATA1str '_' DATA2str '.mat']),'DATA1','DATA2','DATA3','h_signrank','p_signrank');
        saveas(gcf,fullfile(PIC_DIR,['final_slice_Correlationvswmeanmprage_' id '_' prestr '_' DATA1str '_' DATA2str '_threshold' int2str(ithres) '.png']));
        saveas(gcf,fullfile(PIC_DIR,['final_slice_Correlationvswmeanmprage_' id '_' prestr '_' DATA1str '_' DATA2str '_threshold' int2str(ithres) '.fig']));
        close
    end
end


    for kcase = [1 10 15] %[5 10]
      
        xlimits = [0 40];
          
        if kcase == 1, DATA1 = squeeze(BSEG1(:,1,:));  DATA1str = 'BSEG1-t1'; DATA2 = squeeze(BSEG2(:,1,:)); DATA2str = 'BSEG2-t1'; end
        if kcase == 2, DATA1 = squeeze(BSEG1(:,1,:));  DATA1str = 'BSEG1-t1'; DATA2 = squeeze(BSEG3(:,1,:)); DATA2str = 'BSEG3-t1'; end
        if kcase == 3, DATA1 = squeeze(BSEG1(:,1,:));  DATA1str = 'BSEG1-t1'; DATA2 = squeeze(BSEG4(:,1,:)); DATA2str = 'BSEG4-t1'; end
        if kcase == 4, DATA1 = squeeze(BSEG3(:,1,:));  DATA1str = 'BSEG3-t1'; DATA2 = squeeze(BSEG4(:,1,:)); DATA2str = 'BSEG4-t1'; end
        if kcase == 5, DATA1 = squeeze(BSEGorig(:,1,:));  DATA1str = 'BSEGorig-t1'; DATA2 = squeeze(BSEGdico(:,1,:)); DATA2str = 'BSEGdico-t1'; end
        
        if kcase == 6, DATA1 = squeeze(BSEG1(:,2,:));  DATA1str = 'BSEG1-t2'; DATA2 = squeeze(BSEG2(:,2,:)); DATA2str = 'BSEG2-t2'; end
        if kcase == 7, DATA1 = squeeze(BSEG1(:,2,:));  DATA1str = 'BSEG1-t2'; DATA2 = squeeze(BSEG3(:,2,:)); DATA2str = 'BSEG3-t2'; end
        if kcase == 8, DATA1 = squeeze(BSEG1(:,2,:));  DATA1str = 'BSEG1-t2'; DATA2 = squeeze(BSEG4(:,2,:)); DATA2str = 'BSEG4-t2'; end
        if kcase == 9, DATA1 = squeeze(BSEG3(:,2,:));  DATA1str = 'BSEG3-t2'; DATA2 = squeeze(BSEG4(:,2,:)); DATA2str = 'BSEG4-t2'; end
        if kcase == 10, DATA1 = squeeze(BSEGorig(:,2,:));  DATA1str = 'BSEGorig-t2'; DATA2 = squeeze(BSEGdico(:,2,:)); DATA2str = 'BSEGdico-t2'; end           
        
%         if kcase == 11, DATA1 = squeeze(BAnc1(:,1,:));  DATA1str = 'BAnc1-t1'; DATA2 = squeeze(BAnc2(:,1,:)); DATA2str = 'BAnc2-t1'; end
%         if kcase == 12, DATA1 = squeeze(BAnc1(:,1,:));  DATA1str = 'BAnc1-t1'; DATA2 = squeeze(BAnc3(:,1,:)); DATA2str = 'BAnc3-t1'; end
%         if kcase == 13, DATA1 = squeeze(BAnc1(:,1,:));  DATA1str = 'BAnc1-t1'; DATA2 = squeeze(BAnc4(:,1,:)); DATA2str = 'BAnc4-t1'; end
%         if kcase == 14, DATA1 = squeeze(BAnc3(:,1,:));  DATA1str = 'BAnc3-t1'; DATA2 = squeeze(BAnc4(:,1,:)); DATA2str = 'BAnc4-t1'; end
%         if kcase == 15, DATA1 = squeeze(BAnc1(:,2,:));  DATA1str = 'BAnc1-t2'; DATA2 = squeeze(BAnc2(:,2,:)); DATA2str = 'BAnc2-t2'; end
%         if kcase == 16, DATA1 = squeeze(BAnc1(:,2,:));  DATA1str = 'BAnc1-t2'; DATA2 = squeeze(BAnc3(:,2,:)); DATA2str = 'BAnc3-t2'; end
%         if kcase == 17, DATA1 = squeeze(BAnc1(:,2,:));  DATA1str = 'BAnc1-t2'; DATA2 = squeeze(BAnc4(:,2,:)); DATA2str = 'BAnc4-t2'; end
%         if kcase == 18, DATA1 = squeeze(BAnc3(:,2,:));  DATA1str = 'BAnc3-t2'; DATA2 = squeeze(BAnc4(:,2,:)); DATA2str = 'BAnc4-t2'; end        
%         if kcase == 19, DATA1 = squeeze(BA1(:,1,:));  DATA1str = 'BA1-t1'; DATA2 = squeeze(BA2(:,1,:)); DATA2str = 'BA2-t1'; end
%         if kcase == 20, DATA1 = squeeze(BA1(:,1,:));  DATA1str = 'BA1-t1'; DATA2 = squeeze(BA3(:,1,:)); DATA2str = 'BA3-t1'; end
%         if kcase == 21, DATA1 = squeeze(BA1(:,1,:));  DATA1str = 'BA1-t1'; DATA2 = squeeze(BA4(:,1,:)); DATA2str = 'BA4-t1'; end
%         if kcase == 22, DATA1 = squeeze(BA3(:,1,:));  DATA1str = 'BA3-t1'; DATA2 = squeeze(BA4(:,1,:)); DATA2str = 'BA4-t1'; end
%         if kcase == 23, DATA1 = squeeze(BA1(:,2,:));  DATA1str = 'BA1-t2'; DATA2 = squeeze(BA2(:,2,:)); DATA2str = 'BA2-t2'; end
%         if kcase == 24, DATA1 = squeeze(BA1(:,2,:));  DATA1str = 'BA1-t2'; DATA2 = squeeze(BA3(:,2,:)); DATA2str = 'BA3-t2'; end
%         if kcase == 25, DATA1 = squeeze(BA1(:,2,:));  DATA1str = 'BA1-t2'; DATA2 = squeeze(BA4(:,2,:)); DATA2str = 'BA4-t2'; end
%         if kcase == 26, DATA1 = squeeze(BA3(:,2,:));  DATA1str = 'BA3-t2'; DATA2 = squeeze(BA4(:,2,:)); DATA2str = 'BA4-t2'; end
                        
        
        if kcase == 11, DATA1 = squeeze(BSEG1(:,3,:));  DATA1str = 'BSEG1-t3'; DATA2 = squeeze(BSEG2(:,3,:)); DATA2str = 'BSEG2-t3'; end
        if kcase == 12, DATA1 = squeeze(BSEG1(:,3,:));  DATA1str = 'BSEG1-t3'; DATA2 = squeeze(BSEG3(:,3,:)); DATA2str = 'BSEG3-t3'; end
        if kcase == 13, DATA1 = squeeze(BSEG1(:,3,:));  DATA1str = 'BSEG1-t3'; DATA2 = squeeze(BSEG4(:,3,:)); DATA2str = 'BSEG4-t3'; end
        if kcase == 14, DATA1 = squeeze(BSEG3(:,3,:));  DATA1str = 'BSEG3-t3'; DATA2 = squeeze(BSEG4(:,3,:)); DATA2str = 'BSEG4-t3'; end
        if kcase == 15, DATA1 = squeeze(BSEGorig(:,3,:));  DATA1str = 'BSEGorig-t3'; DATA2 = squeeze(BSEGdico(:,3,:)); DATA2str = 'BSEGdico-t3'; end           
       
        mDATA1 = DATA1;
        mDATA2 = DATA2;
        
        mDATA1(isnan(mDATA1)) = 0;
        mDATA2(isnan(mDATA2)) = 0;
        
        disp('data1');
        disp(size(mDATA1));
        disp('data2');
        disp(size(mDATA2));
        
        for kslice = 1:size(DATA1,1)
            [p_signrank(kslice),h_signrank(kslice)] = signrank(squeeze(mDATA1(kslice,:)),squeeze(mDATA2(kslice,:)));
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        figure
        hold on,
        mseb([],mean(DATA1,2)',std(DATA1,[],2)',[],1);
        % hold on, plot(DATA1,'b.')
        lineProps.col={'r'}; mseb([],mean(DATA2,2)',std(DATA2,[],2)',lineProps,1);
        % hold on, plot(DATA2,'r.')
        DATA3 = DATA2 - DATA1;
        lineProps.col={'g'}; mseb([],mean(DATA3,2)',std(DATA3,[],2)',lineProps,1);
        hline2(0.05);
        %plot(p_signrank,'k-.');
        %hold on
        plot(h_signrank/2,'c-.');
        hold on
        ylim([-0.1 1]);
        xlim(xlimits);
        
        xlabel([ 'Fieldcorr: p signrank' id ' ' prestr]);
        set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
        legend(DATA1str,DATA2str);
        
        save(fullfile(PIC_DIR,['final_B0Mask_Correlationvswmeanmprage_' id '_' prestr '_' DATA1str '_' DATA2str '.mat']),'DATA1','DATA2','DATA3','h_signrank','p_signrank');
        saveas(gcf,fullfile(PIC_DIR,['final_B0Mask_Correlationvswmeanmprage_' id '_' prestr '_' DATA1str '_' DATA2str '.png']));
        saveas(gcf,fullfile(PIC_DIR,['final_B0Mask_Correlationvswmeanmprage_' id '_' prestr '_' DATA1str '_' DATA2str '.fig']));
        close
    end

%!montage MASK_Overlapp_data3T_w_MAGm-orig-t1Nonlyseg_MAGm-moco-t1Nonlyseg.png MASK_Overlapp_data3T_w_MAGm-orig-t2Nonlyseg_MAGm-moco-t2Nonlyseg.png 
%MASK_Overlapp_data3T_w_MAGm-orig-t3Nonlyseg_MAGm-moco-t3Nonlyseg.png -tile 2x2 -geometry +0+0 comb__onlyseg_MAGm-orig-moco.png    
    
end
