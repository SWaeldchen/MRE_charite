function Inversion_Heiko
addpath('D:\Heiko\in_fun\')

ind_Pfad=1;
%Leber von Jing------------------------------------------------------------
% Pfad(ind_Pfad).Name='\\datenwelle\datentausch\heiko\MRE\7_freq_liver\AF';ind_Pfad=ind_Pfad+1;
% Pfad(ind_Pfad).Name='\\datenwelle\datentausch\heiko\MRE\7_freq_liver\DK';ind_Pfad=ind_Pfad+1;
% Pfad(ind_Pfad).Name='\\datenwelle\datentausch\heiko\MRE\7_freq_liver\HT';ind_Pfad=ind_Pfad+1;
% Pfad(ind_Pfad).Name='\\datenwelle\datentausch\heiko\MRE\7_freq_liver\IS';ind_Pfad=ind_Pfad+1;
% Pfad(ind_Pfad).Name='\\datenwelle\datentausch\heiko\MRE\7_freq_liver\JB';ind_Pfad=ind_Pfad+1;
% Pfad(ind_Pfad).Name='\\datenwelle\datentausch\heiko\MRE\7_freq_liver\JG';ind_Pfad=ind_Pfad+1;
% Pfad(ind_Pfad).Name='\\datenwelle\datentausch\heiko\MRE\7_freq_liver\JS';ind_Pfad=ind_Pfad+1;
% Pfad(ind_Pfad).Name='\\datenwelle\datentausch\heiko\MRE\7_freq_liver\SH';ind_Pfad=ind_Pfad+1;
% Pfad(ind_Pfad).Name='\\datenwelle\datentausch\heiko\MRE\7_freq_liver\SI';ind_Pfad=ind_Pfad+1;
% Pfad(ind_Pfad).Name='\\datenwelle\datentausch\heiko\MRE\7_freq_liver\SP';ind_Pfad=ind_Pfad+1;

% Pfad(ind_Pfad).Name='\\datenwelle\datentausch\heiko\MRE\7_freq_liver\pat';ind_Pfad=ind_Pfad+1;%John

% Pfad(ind_Pfad).Name='\\datenwelle\datentausch\heiko\MRE\7_freq_liver\IS_new';ind_Pfad=ind_Pfad+1;
% Pfad(ind_Pfad).Name='\\datenwelle\datentausch\heiko\MRE\7_freq_liver\phantom';ind_Pfad=ind_Pfad+1;
Pfad(ind_Pfad).Name='\\datenwelle\datentausch\heiko\MRE\7_freq_liver\Uterus_data\NB';ind_Pfad=ind_Pfad+1;
% Pfad(ind_Pfad).Name='\\datenwelle\datentausch\heiko\MRE\7_freq_liver\kidney_data';ind_Pfad=ind_Pfad+1;
% Pfad(ind_Pfad).Name='\\datenwelle\datentausch\heiko\MRE\7_freq_liver\prostate';ind_Pfad=ind_Pfad+1;
% Pfad(ind_Pfad).Name='\\datenwelle\datentausch\heiko\MRE\7_freq_liver\brain_DTI9';ind_Pfad=ind_Pfad+1;
% Pfad(ind_Pfad).Name='\\datenwelle\datentausch\heiko\MRE\magdeburg\1_5T_SD';ind_Pfad=ind_Pfad+1;
% Pfad(ind_Pfad).Name='\\datenwelle\datentausch\heiko\MRE\magdeburg\3T_SD';ind_Pfad=ind_Pfad+1;
% Pfad(ind_Pfad).Name='\\datenwelle\datentausch\heiko\MRE\magdeburg\7T_SD';ind_Pfad=ind_Pfad+1;

%Phantom von Jing------------------------------------------------------------
% Pfad(ind_Pfad).Name='\\datenwelle\datentausch\heiko\phantom_data_from_Jing\PhantomAgar0p75';ind_Pfad=ind_Pfad+1;
% Pfad(ind_Pfad).Name='\\datenwelle\datentausch\heiko\phantom_data_from_Jing\PhantomAgar0p75Staerke1p5';ind_Pfad=ind_Pfad+1;
% Pfad(ind_Pfad).Name='\\datenwelle\datentausch\heiko\phantom_data_from_Jing\PhantomAgar0p75Talkum0p5';ind_Pfad=ind_Pfad+1;
% Pfad(ind_Pfad).Name='\\datenwelle\datentausch\heiko\phantom_data_from_Jing\PhantomAgar0p5Milch';ind_Pfad=ind_Pfad+1;
% Pfad(ind_Pfad).Name='\\datenwelle\datentausch\heiko\phantom_data_from_Jing\PhantomAgar0p5Papier';ind_Pfad=ind_Pfad+1;
% Pfad(ind_Pfad).Name='\\datenwelle\datentausch\heiko\phantom_data_from_Jing\PhantomSchmand';ind_Pfad=ind_Pfad+1;

% Pfad(ind_Pfad).Name='\\datenwelle\datentausch\heiko\phantom_data_20150423\PhantomAgar0p5';ind_Pfad=ind_Pfad+1;
% Pfad(ind_Pfad).Name='\\datenwelle\datentausch\heiko\phantom_data_20150423\PhantomAgar1p0';ind_Pfad=ind_Pfad+1;
% Pfad(ind_Pfad).Name='\\datenwelle\datentausch\heiko\phantom_data_20150423\PhantomAgar0p75MCC1p5';ind_Pfad=ind_Pfad+1;

% Pfad(ind_Pfad).Name='\\datenwelle\datentausch\heiko\phantom_20150430\phantom_1st';ind_Pfad=ind_Pfad+1;
% Pfad(ind_Pfad).Name='\\datenwelle\datentausch\heiko\phantom_20150430\phantom_2nd';ind_Pfad=ind_Pfad+1;

%Hirn von Andreas----------------------------------------------------------
% Pfad(ind_Pfad).Name='\\S-vfs-01\ag-mre$\backup\MMRE_ImportUnwrap\HC\MMRE_HC_is_2014_01_14';ind_Pfad=ind_Pfad+1;
% Pfad(ind_Pfad).Name='\\S-vfs-01\ag-mre$\backup\MMRE_ImportUnwrap\HC\MMRE_HC_dk_2014_01_14';ind_Pfad=ind_Pfad+1;
% Pfad(ind_Pfad).Name='\\S-vfs-01\ag-mre$\backup\MMRE_ImportUnwrap\HC\MMRE_HC_ck_2014_01_15';ind_Pfad=ind_Pfad+1;
% Pfad(ind_Pfad).Name='\\S-vfs-01\ag-mre$\backup\MMRE_ImportUnwrap\HC\MMRE_HC_sk_2014_01_15';ind_Pfad=ind_Pfad+1;
% Pfad(ind_Pfad).Name='\\S-vfs-01\ag-mre$\backup\MMRE_ImportUnwrap\HC\MMRE_HC_rh_2014_01_15';ind_Pfad=ind_Pfad+1;
% Pfad(ind_Pfad).Name='\\S-vfs-01\ag-mre$\backup\MMRE_ImportUnwrap\HC\MMRE_HC_ch_2014_01_15';ind_Pfad=ind_Pfad+1;
% Pfad(ind_Pfad).Name='\\S-vfs-01\ag-mre$\backup\MMRE_ImportUnwrap\HC\MMRE_HC_kv_2014_01_15';ind_Pfad=ind_Pfad+1;
% Pfad(ind_Pfad).Name='\\S-vfs-01\ag-mre$\backup\MMRE_ImportUnwrap\HC\MMRE_HC_nb_2014_01_22';ind_Pfad=ind_Pfad+1;
% Pfad(ind_Pfad).Name='\\S-vfs-01\ag-mre$\backup\MMRE_ImportUnwrap\HC\MMRE_HC_la_2014_01_27';ind_Pfad=ind_Pfad+1;
% Pfad(ind_Pfad).Name='\\S-vfs-01\ag-mre$\backup\MMRE_ImportUnwrap\HC\MMRE_HC_jz_2014_02_10';ind_Pfad=ind_Pfad+1;

%Hirn von Florian----------------------------------------------------------
% Pfad(ind_Pfad).Name='\\datenwelle\datentausch\heiko\MRE\Hirn_Florian';ind_Pfad=ind_Pfad+1;

%Phantom von Ingolf--------------------------------------------------------
% Pfad(ind_Pfad).Name='\\S-vfs-01\ag-mre$\backup\backup\ingolf\ingolf_full_13_6_2012\Forschung\referenz_phantom\phantom_wave_equation_inversion1_bearbeitet';ind_Pfad=ind_Pfad+1;
% Pfad(ind_Pfad).Name='D:\Heiko\kMDEV\Phantom';ind_Pfad=ind_Pfad+1;

%Hirn von Ingolf-----------------------------------------------------------
% Pfad(ind_Pfad).Name='\\datenwelle\datentausch\heiko\MRE\tumors_brain\MMRE_brain_tumor_gs_2013_04_17';ind_Pfad=ind_Pfad+1;
% Pfad(ind_Pfad).Name='\\datenwelle\datentausch\heiko\MRE\tumors_brain\MMRE_brain_tumor_pf_2013_04_17';ind_Pfad=ind_Pfad+1;

%Leber von Ingolf----------------------------------------------------------
% Pfad(ind_Pfad).Name='\\datenwelle\datentausch\heiko\MRE\mmre_leber_tumor_js_2013_01_31';ind_Pfad=ind_Pfad+1;

for ind_Pfad=1:size(Pfad,2)
    Pfad_akt=[Pfad(ind_Pfad).Name '\'];
    disp(Pfad_akt)
    
    %Laden und Umwandeln der Rohdaten--------------------------------------
    
%     Leber von Jing
%     load([Pfad_akt 'pWcC_liver']);%Daten
%     load([Pfad_akt '\mask_liver_3Droi.mat']);%BW
%     BW_Leber=logical(BW);
% %     load([Pfad_akt '\mask_spleen_3Droi.mat']);%BW
% %     BW_Milz=logical(BW);
%     Phase=Wall(:,:,:,:,:,1:end);%[?] (x,y,z,Zeit,Komponeneten,Frequenzen) komplexes Wellenfeld
%     Aufloesung=[con.dx con.dx con.dz];%[m] (x,y,z) Pixelaufloesung
%     Frequenzen=con.ser_frq(1:end);%[Hz] Frequenzen
%     load([Pfad_akt 'magnitude']);%Daten
%     Magnitude=mag_all(:,:,:,:,:,1:end);
% %     Magnitude=mag_allfreq;
% %     Magnitude=ones(size(Phase));

    %Phantom von Jing
% %     load([Pfad_akt '\MRE_sag']);%Daten
% %     load([Pfad_akt '\MRE_trans']);%Daten
%     load(Pfad_akt(1:end-1));%Daten
% %     Magnitude=mag_all;
%     Magnitude=repmat(mag_all,[1 1 1 1 1 2]);
%     Phase=W_all;
%     Aufloesung=[2 2 2]/10^3;%[m] (x,y,z) Pixelaufloesung
%     Frequenzen=[40 80];%[Hz] Frequenzen
    
    %Niere von Jing
%     load([Pfad_akt 'pWcC_kidney']);%Daten
%     load([Pfad_akt '\mask_kidney_3Droi.mat']);%BW
%     BW=logical(BW);
%     Phase=Wall;%[?] (x,y,z,Zeit,Komponeneten,Frequenzen) komplexes Wellenfeld
%     Aufloesung=[con.dx con.dx con.dz];%[m] (x,y,z) Pixelaufloesung
%     Frequenzen=con.ser_frq;%[Hz] Frequenzen
%     load([Pfad_akt 'magnitude']);%Daten
%     Magnitude=mag_all;

    %Prostata von Jing
%     load([Pfad_akt 'pWcC_prostate']);%Daten
%     load([Pfad_akt '\mask_prostate_3Droi.mat']);%BW
%     BW=logical(BW);
%     Phase=Wall;%[?] (x,y,z,Zeit,Komponeneten,Frequenzen) komplexes Wellenfeld
%     Aufloesung=[con.dx con.dx con.dz];%[m] (x,y,z) Pixelaufloesung
%     Frequenzen=con.ser_frq;%[Hz] Frequenzen
%     load([Pfad_akt 'magnitude']);%Daten
%     Magnitude=mag_all;

    %Hirn von Jing
%     load([Pfad_akt 'pWcC_brain']);%Daten
% %     load([Pfad_akt '\mask_brain_3Droi.mat']);%BW
% %     BW=logical(BW(:,:,1:3:end,:,:,:));
%     Phase=Wall(:,:,1:end,:,:,1:3);%[?] (x,y,z,Zeit,Komponeneten,Frequenzen) komplexes Wellenfeld
%     Aufloesung=[con.dx con.dx con.dz];%[m] (x,y,z) Pixelaufloesung
%     Frequenzen=con.ser_frq;%[Hz] Frequenzen
%     Frequenzen=Frequenzen(1:3);
%     load([Pfad_akt 'magnitude']);%Daten
%     Magnitude=mag_allfreq(:,:,1:end,:,:,1:3);
% %     Magnitude=mag_all(:,:,1:end,:,:,:);

%     Uterus von Jing
    load([Pfad_akt 'pWcC_uterus']);%Daten
    load([Pfad_akt '\mask_uterus_3Droi.mat']);%BW
    BW_Leber = logical(BW);
    Phase = Wall(:,:,:,:,:,1:end);%[?] (x,y,z,Zeit,Komponeneten,Frequenzen) komplexes Wellenfeld
    Aufloesung = [con.dx con.dx con.dz];%[m] (x,y,z) Pixelaufloesung
    Frequenzen = con.ser_frq(1:end);%[Hz] Frequenzen
    load([Pfad_akt 'magnitude']);%Daten
    Magnitude = mag_all(:,:,:,:,:,1:end);
%     Magnitude=mag_allfreq;
    
    %Phantom von Jing
%     load([Pfad_akt 'pWcC_phantom']);%Daten
%     Phase=Wall;%[?] (x,y,z,Zeit,Komponeneten,Frequenzen) komplexes Wellenfeld
%     Aufloesung=[con.dx con.dx con.dz];%[m] (x,y,z) Pixelaufloesung
%     Frequenzen=con.ser_frq;%[Hz] Frequenzen
%     load([Pfad_akt 'inclusion_5_3Droi.mat']);%BW
%     BW=logical(BW);
    
    %Hirn von Andreas
%     load([Pfad_akt 'W_wrap']);%Daten
%     Phase=W_wrap;%[?] (x,y,z,Zeit,Komponeneten,Frequenzen) komplexes Wellenfeld
%     Aufloesung=[1.9 1.9 1.9]/10^3;%[m] (x,y,z) Pixelaufloesung
%     Frequenzen=[60 30 50 40 45 35 55];%[Hz] Frequenzen
%     Magnitude;
    
    %Hirn von Florian
%     load([Pfad_akt 'dataForHeiko']);%Daten
%     Phase=heikoHead3T.cube;%[?] (x,y,z,Zeit,Komponeneten,Frequenzen) komplexes Wellenfeld
%     Aufloesung=heikoHead3T.pixelSize_m;%[m] (x,y,z) Pixelaufloesung
%     Frequenzen=heikoHead3T.freq_Hz;%[Hz] Frequenzen
    
    %Hirn von Ingolf
%     load([Pfad_akt 'W_wrap']);%Daten
%     Phase=W_wrap;%[?] (x,y,z,Zeit,Komponeneten,Frequenzen) komplexes Wellenfeld
%     Aufloesung=[2 2 2]/10^3;%[m] (x,y,z) Pixelaufloesung
%     Frequenzen=[60 30 50 40 45 35 55];%[Hz] Frequenzen

%     %Leber von Ingolf
%     load([Pfad_akt 'W_wrap']);%Daten
%     Phase=W_wrap;%[?] (x,y,z,Zeit,Komponeneten,Frequenzen) komplexes Wellenfeld
%     load([Pfad_akt 'M']);%Daten
%     Magnitude=M;
%     Aufloesung=[2.5 2.5 2.5]/10^3;%[m] (x,y,z) Pixelaufloesung
%     Frequenzen=[60 30 50 40 45 35 55];%[Hz] Frequenzen

    %Phantom von Ingolf
%     load([Pfad_akt 'Phantom']);%Daten
% %     Phase=Phase(:,:,1:1:end,:,:,[1:3,5]);%[?] (x,y,z,Zeit,Komponeneten,Frequenzen) komplexes Wellenfeld
% %     Magnitude=Magnitude(:,:,1:1:end,:,:,[1:3,5]);
% %     Frequenzen=Frequenzen([1:3,5]);
%     Phase=Phase(:,:,1:1:end,:,:,5:end);%[?] (x,y,z,Zeit,Komponeneten,Frequenzen) komplexes Wellenfeld
%     Magnitude=Magnitude(:,:,1:1:end,:,:,5:end);
%     Frequenzen=Frequenzen(5:end);
% %     Phase=Phase(:,:,1:1:end,:,:,:);%[?] (x,y,z,Zeit,Komponeneten,Frequenzen) komplexes Wellenfeld
% %     Magnitude=Magnitude(:,:,1:1:end,:,:,:);
% %     Frequenzen=Frequenzen(:);
% %     load([Pfad_akt 'Inclu1_3Droi.mat']);%BW
% %     BW_1=logical(BW);
% %     load([Pfad_akt 'Inclu2_3Droi.mat']);%BW
% %     BW_2=logical(BW);
% %     load([Pfad_akt 'Inclu3_3Droi.mat']);%BW
% %     BW_3=logical(BW);
% %     load([Pfad_akt 'Inclu4_3Droi.mat']);%BW
% %     BW_4=logical(BW);
% %     load([Pfad_akt 'Matrix_3Droi.mat']);%BW
% %     BW_Matrix=logical(BW);
% %     load([Pfad_akt 'Rand_3Droi.mat']);%BW
% %     BW_Rand=logical(BW);
    
    %Rohsignal-------------------------------------------------------------
    MR_Signal = Magnitude .* exp(1i*Phase);%komplexes Rohsignal
%     MR_Signal = MR_Signal(:,:,:,:,end-1,:);%nur dorsal-ventral Auslenkung (end)
%     close all
    
    MRsignal = MR_Signal;
    spatialResolution = Aufloesung;
    frequency = Frequenzen;
    [c, a, amplitude] = kMDEV( MRsignal, spatialResolution, frequency);
    
%     save('JG', 'c','Pfad_akt','-append');
    plot2dwaves(c.standard);%[m/s] Wellengeschwindigkeit
    caxis([0.5 4])
%     plot2dwaves(c.alternative);%[m/s] Wellengeschwindigkeit
    plot2dwaves(squeeze(c.frequencyResolved(:,:,10,:)));%[m/s] Wellengeschwindigkeit
    caxis([0.5 4])
%     plot2dwaves(c.standardStd);%[m/s] Wellengeschwindigkeit
%     plot2dwaves(a.standard);%[m/s] Wellengeschwindigke
%     plot2dwaves(a.alternative);%[m/s] Wellengeschwindigke
%     plot2dwaves(squeeze(mean(a.frequencyResolved,3)));%[m/s] Wellengeschwindigkeit
%     colormap jet
%     caxis([0 4])
    
%     plot2dwaves(squeeze(mean(c.frequencyResolved,3)));%[m/s] Wellengeschwindigkeit
%     colormap jet
%     caxis([0 4])
    

    
%     save([Pfad_akt 'Daten'],'c','a','amplitude')
%     save([Pfad_akt 'Daten'],'spatialResolution','frequency', '-append')
    
%     BW_Leber(c.standard<1.0)=false;
%     c_Leber=mean(c.standard(BW_Leber));%[m/s]
%     a_Leber=mean(a.standard(BW_Leber));%[m/s]
%     save([Pfad_akt 'Daten'],'c_Leber','a_Leber','-append')
%     c_Milz=mean(c.standard(BW_Milz));;%[m/s]
%     a_Milz=mean(a.standard(BW_Milz));%[m/s]
%     save([Pfad_akt 'Daten'],'c_Milz','a_Milz','-append')
end

%--------------------------------------------------------------------------
% plot2dwaves(animate(w3D2w2D(squeeze(u(:,:,5,:,9)))));

% iFrequency = 2; plot2dwaves(animate(w3D2w2D(squeeze(shearWaveField(:,:,5,:,iFrequency)))));
% iFrequency = 1; plot2dwaves(squeeze(Phase_Filter(:,:,Index_Mittelschicht,:,iFrequency)));

iFrequency = 3;
plot2dwaves(reshape(shearWaveField(:,:,3,:,:,iFrequency),[size(shearWaveField,1) size(shearWaveField,2) 12*3]))
caxis([-1 1])

w = ginput;

r = sqrt( (w(1:2:end,1)-w(2:2:end,1)).^2 + (w(1:2:end,2)-w(2:2:end,2)).^2  );
disp( [mean(r), std(r)] * 2 * inplaneResolution(1)*frequency(iFrequency) )

end