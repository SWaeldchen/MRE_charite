function af_plot_normoverlap(PROJ_DIR,id,prestr)

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

nslices = 79;
nproband = 14;
xlimits = [0 80];


load(fullfile(PROJ_DIR,'Group_Corr2.mat'));


    for kcase = 1:15
      
        xlimits = [20 70];
        
        %Nonlyseg(kslice,kmask,subj,kmod)
          
        if kcase == 1, DATA1 = squeeze(overlap(:,1,:,1));  DATA1str = 'MAGm-orig-t1'; DATA2 = squeeze(overlap(:,1,:,2)); DATA2str = 'MAGm-moco-t1'; end
        if kcase == 2, DATA1 = squeeze(overlap(:,1,:,1));  DATA1str = 'MAGm-orig-t1'; DATA2 = squeeze(overlap(:,1,:,3)); DATA2str = 'MAGm-dico-t1'; end
        if kcase == 3, DATA1 = squeeze(overlap(:,1,:,1));  DATA1str = 'MAGm-orig-t1'; DATA2 = squeeze(overlap(:,1,:,4)); DATA2str = 'MAGm-modico-t1'; end
        if kcase == 4, DATA1 = squeeze(overlap(:,1,:,3));  DATA1str = 'MAGm-dico-t1'; DATA2 = squeeze(overlap(:,1,:,4)); DATA2str = 'MAGm-modico-t1'; end
        if kcase == 5, DATA1 = squeeze(overlap(:,1,:,5));  DATA1str = 'MAGf-orig-t1'; DATA2 = squeeze(overlap(:,1,:,6)); DATA2str = 'MAGf-dico-t1'; end        
        if kcase == 6, DATA1 = squeeze(overlap(:,2,:,1));  DATA1str = 'MAGm-orig-t2'; DATA2 = squeeze(overlap(:,2,:,2)); DATA2str = 'MAGm-moco-t2'; end
        if kcase == 7, DATA1 = squeeze(overlap(:,2,:,1));  DATA1str = 'MAGm-orig-t2'; DATA2 = squeeze(overlap(:,2,:,3)); DATA2str = 'MAGm-dico-t2'; end
        if kcase == 8, DATA1 = squeeze(overlap(:,2,:,1));  DATA1str = 'MAGm-orig-t2'; DATA2 = squeeze(overlap(:,2,:,4)); DATA2str = 'MAGm-modico-t2'; end
        if kcase == 9, DATA1 = squeeze(overlap(:,2,:,3));  DATA1str = 'MAGm-dico-t2'; DATA2 = squeeze(overlap(:,2,:,4)); DATA2str = 'MAGm-modico-t2'; end
        if kcase == 10, DATA1 = squeeze(overlap(:,2,:,5));  DATA1str = 'MAGf-orig-t2'; DATA2 = squeeze(overlap(:,2,:,6)); DATA2str = 'MAGf-dico-t2'; end       
        if kcase == 11, DATA1 = squeeze(overlap(:,3,:,1));  DATA1str = 'MAGm-orig-t3'; DATA2 = squeeze(overlap(:,3,:,2)); DATA2str = 'MAGm-moco-t3'; end
        if kcase == 12, DATA1 = squeeze(overlap(:,3,:,1));  DATA1str = 'MAGm-orig-t3'; DATA2 = squeeze(overlap(:,3,:,3)); DATA2str = 'MAGm-dico-t3'; end
        if kcase == 13, DATA1 = squeeze(overlap(:,3,:,1));  DATA1str = 'MAGm-orig-t3'; DATA2 = squeeze(overlap(:,3,:,4)); DATA2str = 'MAGm-modico-t3'; end
        if kcase == 14, DATA1 = squeeze(overlap(:,3,:,3));  DATA1str = 'MAGm-dico-t3'; DATA2 = squeeze(overlap(:,3,:,4)); DATA2str = 'MAGm-modico-t3'; end
        if kcase == 15, DATA1 = squeeze(overlap(:,3,:,5));  DATA1str = 'MAGf-orig-t3'; DATA2 = squeeze(overlap(:,3,:,6)); DATA2str = 'MAGf-dico-t3'; end
       
%         if kcase == 16, DATA1 = squeeze(Nonlyseg(:,1,:,1));  DATA1str = 'MAGm-orig-t1Nonlyseg'; DATA2 = squeeze(Nonlyseg(:,1,:,2)); DATA2str = 'MAGm-moco-t1Nonlyseg'; end
%         if kcase == 17, DATA1 = squeeze(Nonlyseg(:,1,:,1));  DATA1str = 'MAGm-orig-t1Nonlyseg'; DATA2 = squeeze(Nonlyseg(:,1,:,3)); DATA2str = 'MAGm-dico-t1Nonlyseg'; end
%         if kcase == 18, DATA1 = squeeze(Nonlyseg(:,1,:,1));  DATA1str = 'MAGm-orig-t1Nonlyseg'; DATA2 = squeeze(Nonlyseg(:,1,:,4)); DATA2str = 'MAGm-modico-t1Nonlyseg'; end
%         if kcase == 19, DATA1 = squeeze(Nonlyseg(:,1,:,3));  DATA1str = 'MAGm-dico-t1Nonlyseg'; DATA2 = squeeze(Nonlyseg(:,1,:,4)); DATA2str = 'MAGm-modico-t1Nonlyseg'; end
%         if kcase == 20, DATA1 = squeeze(Nonlyseg(:,1,:,5));  DATA1str = 'MAGf-orig-t1Nonlyseg'; DATA2 = squeeze(Nonlyseg(:,1,:,6)); DATA2str = 'MAGf-dico-t1Nonlyseg'; end        
%         if kcase == 21, DATA1 = squeeze(Nonlyseg(:,2,:,1));  DATA1str = 'MAGm-orig-t2Nonlyseg'; DATA2 = squeeze(Nonlyseg(:,2,:,2)); DATA2str = 'MAGm-moco-t2Nonlyseg'; end
%         if kcase == 22, DATA1 = squeeze(Nonlyseg(:,2,:,1));  DATA1str = 'MAGm-orig-t2Nonlyseg'; DATA2 = squeeze(Nonlyseg(:,2,:,3)); DATA2str = 'MAGm-dico-t2Nonlyseg'; end
%         if kcase == 23, DATA1 = squeeze(Nonlyseg(:,2,:,1));  DATA1str = 'MAGm-orig-t2Nonlyseg'; DATA2 = squeeze(Nonlyseg(:,2,:,4)); DATA2str = 'MAGm-modico-t2Nonlyseg'; end
%         if kcase == 24, DATA1 = squeeze(Nonlyseg(:,2,:,3));  DATA1str = 'MAGm-dico-t2Nonlyseg'; DATA2 = squeeze(Nonlyseg(:,2,:,4)); DATA2str = 'MAGm-modico-t2Nonlyseg'; end
%         if kcase == 25, DATA1 = squeeze(Nonlyseg(:,2,:,5));  DATA1str = 'MAGf-orig-t2Nonlyseg'; DATA2 = squeeze(Nonlyseg(:,2,:,6)); DATA2str = 'MAGf-dico-t2Nonlyseg'; end       
%         if kcase == 26, DATA1 = squeeze(Nonlyseg(:,3,:,1));  DATA1str = 'MAGm-orig-t3Nonlyseg'; DATA2 = squeeze(Nonlyseg(:,3,:,2)); DATA2str = 'MAGm-moco-t3Nonlyseg'; end
%         if kcase == 27, DATA1 = squeeze(Nonlyseg(:,3,:,1));  DATA1str = 'MAGm-orig-t3Nonlyseg'; DATA2 = squeeze(Nonlyseg(:,3,:,3)); DATA2str = 'MAGm-dico-t3Nonlyseg'; end
%         if kcase == 28, DATA1 = squeeze(Nonlyseg(:,3,:,1));  DATA1str = 'MAGm-orig-t3Nonlyseg'; DATA2 = squeeze(Nonlyseg(:,3,:,4)); DATA2str = 'MAGm-modico-t3Nonlyseg'; end
%         if kcase == 28, DATA1 = squeeze(Nonlyseg(:,3,:,3));  DATA1str = 'MAGm-dico-t3Nonlyseg'; DATA2 = squeeze(Nonlyseg(:,3,:,4)); DATA2str = 'MAGm-modico-t3Nonlyseg'; end
%         if kcase == 29, DATA1 = squeeze(Nonlyseg(:,3,:,5));  DATA1str = 'MAGf-orig-t3Nonlyseg'; DATA2 = squeeze(Nonlyseg(:,3,:,6)); DATA2str = 'MAGf-dico-t3Nonlyseg'; end
%         
%         
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
        
        xlabel([ 'Overlapp: p signrank' id ' ' prestr]);
        set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
        legend(DATA1str,DATA2str);
        
        saveas(gcf,fullfile(PIC_DIR,['MASK_Overlapp_' id '_' prestr '_' DATA1str '_' DATA2str '.png']));
        saveas(gcf,fullfile(PIC_DIR,['MASK_Overlapp_' id '_' prestr '_' DATA1str '_' DATA2str '.fig']));
        close
    end

 cd('/store01_analysis/stefanh/MRDATA/MODICOISMRM/3T/PICS/');
!montage MASK_Overlapp_data3T_w_MAGm-orig-t1_MAGm-moco-t1.png MASK_Overlapp_data3T_w_MAGm-orig-t2_MAGm-moco-t2.png MASK_Overlapp_data3T_w_MAGm-orig-t3_MAGm-moco-t3.png -tile 2x2 -geometry +0+0 comb__MAGm-orig-moco.png
!montage MASK_Overlapp_data3T_w_MAGm-orig-t1_MAGm-dico-t1.png MASK_Overlapp_data3T_w_MAGm-orig-t2_MAGm-dico-t2.png MASK_Overlapp_data3T_w_MAGm-orig-t3_MAGm-dico-t3.png -tile 2x2 -geometry +0+0 comb__MAGm-orig-dico.png
!montage MASK_Overlapp_data3T_w_MAGm-orig-t1_MAGm-modico-t1.png MASK_Overlapp_data3T_w_MAGm-orig-t2_MAGm-modico-t2.png MASK_Overlapp_data3T_w_MAGm-orig-t3_MAGm-modico-t3.png -tile 2x2 -geometry +0+0 comb__MAGm-orig-modico.png
!montage MASK_Overlapp_data3T_w_MAGm-dico-t1_MAGm-modico-t1.png MASK_Overlapp_data3T_w_MAGm-dico-t2_MAGm-modico-t2.png MASK_Overlapp_data3T_w_MAGm-dico-t3_MAGm-modico-t3.png -tile 2x2 -geometry +0+0 comb__MAGm-dico-modico.png
!montage MASK_Overlapp_data3T_w_MAGf-orig-t1_MAGf-dico-t1.png MASK_Overlapp_data3T_w_MAGf-orig-t2_MAGf-dico-t2.png MASK_Overlapp_data3T_w_MAGf-orig-t3_MAGf-dico-t3.png -tile 2x2 -geometry +0+0 comb__MAGf-orig-dico.png
% 
% !montage MASK_Overlapp_data3T_w_MAGm-orig-t1Nonlyseg_MAGm-moco-t1Nonlyseg.png MASK_Overlapp_data3T_w_MAGm-orig-t2Nonlyseg_MAGm-moco-t2Nonlyseg.png MASK_Overlapp_data3T_w_MAGm-orig-t3Nonlyseg_MAGm-moco-t3Nonlyseg.png -tile 2x2 -geometry +0+0 comb__onlyseg_MAGm-orig-moco.png
% !montage MASK_Overlapp_data3T_w_MAGm-orig-t1Nonlyseg_MAGm-dico-t1Nonlyseg.png MASK_Overlapp_data3T_w_MAGm-orig-t2Nonlyseg_MAGm-dico-t2Nonlyseg.png MASK_Overlapp_data3T_w_MAGm-orig-t3Nonlyseg_MAGm-dico-t3Nonlyseg.png -tile 2x2 -geometry +0+0 comb__onlyseg_MAGm-orig-dico.png
% %!montage MASK_Overlapp_data3T_w_MAGm-orig-t1Nonlyseg_MAGm-modico-t1Nonlyseg.png MASK_Overlapp_data3T_w_MAGm-orig-t2Nonlyseg_MAGm-modico-t2Nonlyseg.png MASK_Overlapp_data3T_w_MAGm-orig-t3Nonlyseg_MAGm-modico-t3Nonlyseg.png -tile 2x2 -geometry +0+0 comb__onlyseg_MAGm-orig-modico.png
% !montage MASK_Overlapp_data3T_w_MAGm-dico-t1Nonlyseg_MAGm-modico-t1Nonlyseg.png MASK_Overlapp_data3T_w_MAGm-dico-t2Nonlyseg_MAGm-modico-t2Nonlyseg.png MASK_Overlapp_data3T_w_MAGm-dico-t3Nonlyseg_MAGm-modico-t3Nonlyseg.png -tile 2x2 -geometry +0+0 comb__onlyseg_MAGm-dico-modico.png
% !montage MASK_Overlapp_data3T_w_MAGf-orig-t1Nonlyseg_MAGf-dico-t1Nonlyseg.png MASK_Overlapp_data3T_w_MAGf-orig-t2Nonlyseg_MAGf-dico-t2Nonlyseg.png MASK_Overlapp_data3T_w_MAGf-orig-t3Nonlyseg_MAGf-dico-t3Nonlyseg.png -tile 2x2 -geometry +0+0 comb__onlyseg_MAGf-orig-dico.png


end