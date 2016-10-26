function springpot_inversion_cis_comps_af(noplot)

if nargin < 1
    noplot=0;
end

Datenoutput_dir='/media/andi/mnt_data2/';
WDIR = '/media/afdata/project_CIS/';


dx=1.9/1000;
rho=1000;
eta=3.7; % nach NI

%%% selection of freqs

% freqs=[30 35 40 45 50];

freqs=30:5:60;
% freqs=[30 40 50 60];

% Reihenfolge der aufgenommenen Frequenzen: [60 30 50 40 45 35 55]

%freq_inc=[2 4 3 1];
%freq_inc=[2 6 4 3];
freq_inc=[2 6 4 5 3 7 1];
%freq_inc=[2 6 4 5 3];

% filter discrete (Hirn)
% f2=[0.02 0.015 0.011 0.01];
% f1=[0.18 0.12   0.1   0.1];

f2=[0.017875    0.015913    0.014066    0.012212       0.011    0.010418    0.010053];
f1=[0.15024  0.12752     0.11408     0.10416         0.1          0.1         0.1];

save_name_MS='MS_comps';
save_name_VOL='VOL_comps';

omega=freqs*2*pi;
freq_fit=linspace(0, 75, 100);

% Grenzwerte zur Mittelung
clim1=0.1;
clim2=200;
glim1=0.1;
glim2=200;

for WDH=2 % 1 == CIS, 2 == HC
    
    if WDH==1
        
        subj=str2mat(...
            [Datenoutput_dir 'datenoutput_2014\MMRE_CIS_0088B2_4_1'],...
            [Datenoutput_dir 'datenoutput_2013\MMRE_CIS_0089B3'],...
            [Datenoutput_dir 'datenoutput_2013\MMRE_CIS_0090'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE_CIS_0092B2_3_1'],...
            [Datenoutput_dir 'datenoutput_2013\MMRE_CIS_0093B3'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE_CIS_0094B3_4_1'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE_CIS_0100'],...
            [Datenoutput_dir 'datenoutput_2013\MMRE_MS_ak_2013_02_20'],...
            [Datenoutput_dir 'datenoutput_2012\MMRE_MS_hh_2012_12_18'],...
            [Datenoutput_dir 'datenoutput_2012\MMRE_uf_2012_10_31'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE-CIS105B4_20140602-092949'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE-CIS-0109B2_20140806-100645'],...
            [Datenoutput_dir 'datenoutput_2013\MMRE_CIS_0018B6_8'],...
            [Datenoutput_dir 'datenoutput_2013\MMRE_CIS0085'],...
            [Datenoutput_dir 'datenoutput_2012\MMRE_MS_ac_2012_12_17'],...
            [Datenoutput_dir 'datenoutput_2013\MMRE_MMRE_MS_dr_2013_07_25'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE-CIS-0111_20141031-095032']);
        
        GROUPNAME = 'CIS';
        
        
        for k=1:size(subj,1)
            
            
            name=deblank(subj(k,:));
            disp(name);
            
            n1=strrep(name,[Datenoutput_dir 'datenoutput_2013\'],'');
            n1=strrep(n1,[Datenoutput_dir 'datenoutput_2012\'],'');
            n1=strrep(n1,[Datenoutput_dir 'datenoutput_2014\'],'');
            %outname=[WDIR '/' n1];
            
            outname=[WDIR '/' GROUPNAME '/' n1 '/'];
            
            disp(outname);
            cd(outname);
            load(fullfile(outname,'fW.mat'));
            
            disp(size(fW));
            
            FW(:,:,:,:,:,k)=fW;
            load BW4sl
            BW_all(:,:,:,k)=BW4sl;
            
        end
        
    else
        
        subj=str2mat(...
            [Datenoutput_dir 'datenoutput_2013\MMRE_PB_cr_2013_02_07'],...
            [Datenoutput_dir 'datenoutput_2013\MMRE_HC_mk_2013_07_05'],...
            [Datenoutput_dir 'datenoutput_2013\MMRE_HC_reza_2013_07_03'],...
            [Datenoutput_dir 'datenoutput_2013\MMRE_HC_js_2013_07_17'],...
            [Datenoutput_dir 'datenoutput_2013\MMRE_HC_sf_2013_07_17'],...
            [Datenoutput_dir 'datenoutput_2013\MMRE_HC_eb_2013_11_14'],...
            [Datenoutput_dir 'datenoutput_2013\MMRE_HC_ht_2013_12_10'],...
            [Datenoutput_dir 'datenoutput_2013\MMRE_HC_fd_2013_12_11'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE_HC_jb_2014_01_06'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE_HC_sm_2014_01_07'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE_HC_yk_2014_01_07'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE_HC_sp_2014_01_08'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE_HC_ch_2014_01_08'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE_HC_si_2014_01_08'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE_HC_js_2014_01_08'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE_HC_cw_2014_01_08'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE_HC_jg_2014_01_08'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE_HC_af1_2014_01_08'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE_HC_kw_2014_01_10'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE_HC_ts_2014_01_10'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE_HC_sh_2014_01_10'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE_HC_es_2014_01_10'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE_HC_sh_2014_01_14'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE_HC_is_2014_01_14'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE_HC_dk_2014_01_14'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE_HC_ck_2014_01_15'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE_HC_sk_2014_01_15'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE_HC_rh_2014_01_15'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE_HC_nb_2014_01_22'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE_HC_la_2014_01_27'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE_HC_jz_2014_02_10'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE_HC_cl_2014_02_11'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE_HC_kk_2014_02_13'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE_HC_lo_2014_02_26'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE_HC_fp_2014_02_26'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE_HC_wz_2014_03_01'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE_HC_tk_2014_03_06'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE-HC-te-2014-03-18_20140318-184824'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE-HC-ms-2014-03-18_20140318-191117'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE-HC-cu-2014-03-18_20140318-193701'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE-HC-fd-2014-04-02_20140402-124052'],...
            [Datenoutput_dir 'datenoutput_2014\MMRE-HC-ht-2014-04-02_20140402-122156']);
        
        GROUPNAME = 'HC';
        
        selected_subj=[ 1     5     6     7     8     9    11    12    13    15    16    17  18    19    20    21    23    24    25    26    27    28    29    30   31    32    33    34    35    36    38    39    40];
        
        
        subj=subj(selected_subj,:);
        
        for k=1:size(subj,1)
            
            name=deblank(subj(k,:));
            disp(name)
            
            n1=strrep(name,[Datenoutput_dir 'datenoutput_2013\'],'');
            n1=strrep(n1,[Datenoutput_dir 'datenoutput_2012\'],'');
            n1=strrep(n1,[Datenoutput_dir 'datenoutput_2014\'],'');
            %outname=[WDIR '/' n1];
            
            outname=[WDIR '/' GROUPNAME '/' n1 '/'];
            
            
            %             if (k == size(subj,1))
            %                 BW4sl = logical(imerode(BW4sl,strel('disk',2)));
            %             end
            
            cd(outname);
            load fW
            FW(:,:,:,:,:,k)=fW;
            load BW4sl
            BW_all(:,:,:,k)=BW4sl;
            
        end
        
    end % WDH
    
    cd(WDIR);
    %cd('d:\mrI_data\brain\3D\cis\')
    
    inc2=0;
    
    for kv=1:size(FW,6)
        inc=0;
        for kc=1:3
            for ks=1:4
                incf=0;
                for kf=freq_inc
                    
                    incf=incf+1;
                    
                    %%ROI for filtering
                    BWfilt=imfill(BW_all(:,:,ks,kv),'holes');
                    BW_average=logical(BWfilt-imerode(BWfilt,strel('disk',16)));
                    BWfilt=imdilate(BWfilt,strel('disk',3));
                    
                    Wfilt = uh_filtspatio2d(mean(FW(:,:,ks,kc,kf,kv),3).*BWfilt,[dx; dx],1/f2(incf),5,1/f1(incf),5,'bwbwband', 0);
                    Bild(:,:,incf)=real(Wfilt);
                    
                    [wx, wy]   = gradient(Wfilt,dx,dx);
                    [wxx, wxy] = gradient(wx,dx,dx);
                    [wyx, wyy] = gradient(wy,dx,dx);
                    
                    DW = wxx + wyy;
                    
                    warning('off')
                    
                    G=-rho*omega(incf)^2*Wfilt./DW;
                    
                    RESULTS_Gr_filt(:,:,kv,ks,kc,kf) = wiener2(medfilt2(abs(real(G)),[5 5]),[5 5]).*BWfilt;
                    RESULTS_Gi_filt(:,:,kv,ks,kc,kf) = wiener2(medfilt2(abs(imag(G)),[5 5]),[5 5]).*BWfilt;
                    
                    G(find(real(G)<0))=NaN;
                    G(find(imag(G)<0))=conj(G(find(imag(G)<0)));
                    
                    Gr=real(G);
                    Gi=imag(G);
                    
                    Gr(isnan(Gr))=0;
                    Gi(isnan(Gi))=0;
                    
                    RESULTS_Gr(:,:,kv,ks,kc,kf) = Gr;
                    RESULTS_Gi(:,:,kv,ks,kc,kf) = Gi;
                    
                    RESULTS_Gr(:,:,kv,ks,kc,kf) = wiener2(medfilt2(abs(real(G)),[5 5]),[5 5]).*BWfilt;
                    
                    
                    
                    % Dieters Variante
                    
                    c_helm = sqrt(1/rho)*1./real(1./sqrt(G));
                    gam_helm = abs(omega(incf)*sqrt(rho)*imag(1./sqrt(G)));
                    
                    c_helm(isnan(c_helm))=0;
                    gam_helm(isnan(gam_helm))=0;                    
                    
                    cm=median(c_helm(BW_average & c_helm > clim1 & c_helm < clim2));
                    gm=median(gam_helm(BW_average & gam_helm > glim1 & gam_helm < glim2));
                    
                    G_median = rho*omega(incf)^2/((omega(incf)/cm - 1i * gm)^2);
                    gr(incf)=real(G_median);
                    gi(incf)=imag(G_median);
                    
                    
                end % kf
                
                
                %%% fit stuff
                
                [alph mu] = springpot_fit_complex_hirn(gr + 1i*gi,freqs,eta);
                g_fit = (mu)^(1-alph)*(freq_fit*2*pi*eta*1i).^alph;
                
                inc=inc+1;
                RESULTS(kv,ks,kc,:) = [alph mu];
                
                disp([kv ks kc mu]);
                noplot = 1;
                
                if ~noplot
                    %         % plot stuff
                    close
                    name_fig=[num2str(WDH) '_' num2str(ks) '_' num2str(kc) '_' num2str(kv)];
                    fig=figure('name',name_fig,'numbertitle','off');
                    ax1=subplot(2,1,1);
                    ax2=subplot(2,1,2);
                    set(gcf,'units','normalized','currentaxes',ax1)
                    imagesc(reshape(Bild,[size(Bild,1),size(Bild,2)*size(Bild,3)]));
                    axis equal
                    axis tight
                    axis off
                    ca=caxis;
                    caxis([-1 1]*min(abs(ca))/4);
                    set(ax1,'position',[0. 0.35 1 0.7]);
                    load cmp_uh
                    colormap(cmp_uh)
                    hold on
                    BW2=cat(2,BW_all(:,:,ks,kv),BW_all(:,:,ks,kv),BW_all(:,:,ks,kv),BW_all(:,:,ks,kv),BW_all(:,:,ks,kv),BW_all(:,:,ks,kv),BW_all(:,:,ks,kv));
                    [tmp h]=contour(BW2,[-100000 0.5]);set(h,'color',[1 1 0.9],'linewidth',1,'linestyle','-');
                    BW3=cat(2,BW_average,BW_average,BW_average,BW_average,BW_average,BW_average,BW_average);
                    [tmp h]=contour(BW3,[-100000 0.5]);set(h,'color','g','linewidth',1);
                    set(gcf,'currentaxes',ax2)
                    plot(freqs,gr,'o',freqs,gi,'s')
                    hold on
                    plot(freq_fit,real(g_fit),freq_fit,imag(g_fit))
                    axis tight
                    title(['mu: ' num2str(mu) ' alpha: ' num2str(alph)])
                    drawnow
                    print(gcf, '-djpeg', [name_fig '.jpg']);
                    %
                    %     %%%%%%%%
                end % noplot
                
            end % ks
            
        end % kc
        
    end % kv
    
    cd(WDIR);
    if WDH == 1
        MS=RESULTS;
        save(save_name_MS,'MS','RESULTS_Gr','RESULTS_Gi','RESULTS_Gr_filt','RESULTS_Gi_filt');
    else
        VOL=RESULTS;
        save(save_name_VOL,'VOL','RESULTS_Gr','RESULTS_Gi','RESULTS_Gr_filt','RESULTS_Gi_filt');
    end
    
    RESULTS=[];
    
end %WDH