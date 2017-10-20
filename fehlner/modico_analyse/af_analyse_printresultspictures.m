%addpath(genpath('H:\project_modico\analyse_new'));
%load('H:\Asubject_list.mat');

load('/home/realtime/Asubject_list.mat');
addpath(genpath('/home/realtime/project_modico/pipeline/'));

%setenv('LD_LIBRARY_PATH',MatlabPath);

t_id{1} = '3T'; % PERF
t_id{2} = '15T';
t_id{3} = '30T';
t_id{4} = '7T';


PIC_DIR = '/home/realtime/modico_PICS/'; %PIC_DIR

for prestr = {'MNI','EPI'} %,'EPI'} 
    
    prestr = cell2str(prestr);
    
    for kid = [1 2 3 4] %1 2 3 4] %:4 %30,3 %1:length(t_id)
        id = t_id{kid};
        disp([prestr '_' id]);
        
        if strcmp(prestr,'EPI')
            kmod = 1;
        else
            kmod = 2;
        end
        

        load(fullfile('/store01_analysis/realtime/',['resdata7_' id '_' prestr '.mat']));        
        
%         C = res1.rer_MAG1;
%         res_rer_MAG1 = plot_improve_corrmotion(C,mFD,id,'rer-MAG1',prestr);
%         set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
%         saveas(gcf,fullfile(PIC_DIR,['pic_rer_MAG1__' id '_' prestr '.png']));
%         close        
%         
%         C = res1.rer_ABSG1;
%         res_rer_ABSG1 = plot_improve_corrmotion(C,mFD,id,'rer-ABSG1',prestr);
%         set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
%         saveas(gcf,fullfile(PIC_DIR,['pic_rer_ABSG1__' id '_' prestr  '.png']));
%         close        
        
        C = res1.rer_MAG2;
        res_rer_MAG2 = plot_improve_corrmotion(C,mFD,id,'rer-MAG2',prestr);
        set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
        saveas(gcf,fullfile(PIC_DIR,['pic_rer_MAG2__' id '_' prestr '.png']));
        close        
        
        C = res1.rer_ABSG2;
        res_rer_ABSG2 = plot_improve_corrmotion(C,mFD,id,'rer-ABSG2',prestr);
        set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
        saveas(gcf,fullfile(PIC_DIR,['pic_rer_ABSG2__' id '_' prestr  '.png']));
        close
        
        C = res2.psf_MAG;
        res_psf_MAG = plot_improve_corrmotion(C,mFD,id,'psf-MAG',prestr);
        set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
        saveas(gcf,fullfile(PIC_DIR,['pic_psf_MAG__' id '_' prestr '.png']));
        close
        
        C = res2.psf_ABSG;
        res_psf_ABSG = plot_improve_corrmotion(C,mFD,id,'psf-ABSG',prestr);
        set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
        saveas(gcf,fullfile(PIC_DIR,['pic_psf_ABSG__' id '_' prestr '.png']));
        close
        
        C = res3.entropy_MAG;
        res_entropy_MAG = plot_improve_corrmotion(C,mFD,id,'entropy-MAG',prestr);
        set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
        saveas(gcf,fullfile(PIC_DIR,['pic_entropy_MAG__' id '_' prestr '.png']));
        close
        
        C = res3.entropy_ABSG;        
        res_entropy_ABSG = plot_improve_corrmotion(C,mFD,id,'entropy-MAG',prestr);
        set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
        saveas(gcf,fullfile(PIC_DIR,['pic_entropy_ABSG__' id '_' prestr '.png']));
        close
        
        
        % kid, kmod = EPI/MNI, MAG/ABSG, PSF/RER
        comb_res{kid,kmod,1,1} = res_psf_MAG;
        comb_res{kid,kmod,2,1} = res_psf_ABSG;
        comb_res{kid,kmod,1,2} = res_rer_MAG2;
        comb_res{kid,kmod,2,2} = res_rer_ABSG2;
        %comb_res{kid,kmod,1,3} = res_rer_MAG1;
        %comb_res{kid,kmod,2,3} = res_rer_ABSG1;
        
        
%         disp(prestr);
%         disp('rer vs psf, ABSG: orig vs moco');
%         disp([res_rer_ABSG2.p_om_corrposv res_psf_ABSG.p_om_corrposv]);
%         disp(abs([res_rer_ABSG2.r_om_corrposv res_psf_ABSG.r_om_corrposv]));
%         
%         disp('ABSG: dico vs modico');
%         disp([res_rer_ABSG2.p_dmd_corrposv res_psf_ABSG.p_dmd_corrposv]);
%         disp(abs([res_rer_ABSG2.r_dmd_corrposv res_psf_ABSG.r_dmd_corrposv]));
%         
%         disp('MAG: orig vs moco');
%         disp([res_rer_MAG2.p_om_corrposv res_psf_MAG.p_om_corrposv]);
%         disp(abs([res_rer_MAG2.r_om_corrposv res_psf_MAG.r_om_corrposv]));
%         
%         disp('MAG: dico vs modico');
%         disp([res_rer_MAG2.p_dmd_corrposv res_psf_MAG.p_dmd_corrposv]);
%         disp(abs([res_rer_MAG2.r_dmd_corrposv res_psf_MAG.r_dmd_corrposv]));
                       
%        system(['convert pic_rer_ABSG2__' id '_' prestr '.png pic_psf_ABSG__' id '_' prestr '.png -append picall_ABSG_' id '_' prestr '.png']);
%        system(['convert pic_rer_MAG2__' id '_' prestr '.png pic_psf_MAG__' id '_' prestr '.png -append picall_MAG_' id '_' prestr '.png']);
        
    end
    
    save(fullfile(PIC_DIR,'comb_data_all.mat'),'comb_res');
    
end

% kid, kmod=EPI/MNI, MAG/ABSG, PSF/RER
%    comb_res{kid,kmod,1,1} = res_psf_MAG;
%    comb_res{kid,kmod,2,1} = res_psf_ABSG;
%    comb_res{kid,kmod,1,2} = res_rer_MAG2;
%    comb_res{kid,kmod,2,2} = res_rer_ABSG2;


load(fullfile(PIC_DIR,'comb_data_all.mat'),'comb_res');

for kid = [1 4]

    if kid == 1        
        txtstr = '3T'; % PERF
    end
    if kid == 2
        txtstr = '15T';
    end
    if kid == 3
        txtstr = '30T';
    end
    if kid == 4
        txtstr = '7T';
    end    
    
DAT1 = {comb_res{kid,:,:,:}}';
DDD=cell2mat(DAT1);

disp(id);
E=struct2table(DDD);
%F=double(E);
%E2 = table(E,'RowNames',{'1','2','3','4','5','6'})

save(['/home/realtime/' txtstr '.mat'],'DDD','E','DAT1');
E.Properties.RowNames={'PSF_MAG_EPI','PSF_MAG_MNI','PSF_ABSG_EPI','PSF_ABSG_MNI','RER_MAG_EPI','RER_MAG_MNI','RER_ABSG_EPI','RER_ABSG_MNI'};
writetable(E,['/home/realtime/tab_' txtstr '.csv'],'WriteRowNames',true);


%dlmwrite(['/home/realtime/' txtstr '.txt'],F);

end