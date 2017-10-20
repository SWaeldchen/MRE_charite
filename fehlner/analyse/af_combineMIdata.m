function af_combineMIdata(PROJ_DIR,id,prestr)

PIC_DIR = fullfile(PROJ_DIR,'PICS');
if strcmp(id,'data3T');
    nslices = 79;
    nproband = 14;
end

if strcmp(id,'data7T');
    nslices = 156;
    nproband = 18;
end

for kslice = 1:nslices
    for subj = 1:nproband
        
        load(fullfile(PROJ_DIR,'MI_DIR',['N3DATA_first_' id '_sub' int2str(subj) '_' prestr '_kslice' int2str(kslice)]));
        
        MI_mpragevsMfo_all(kslice,subj) = MI_mpragevsMfo;
        MI_mpragevsMfc_all(kslice,subj) = MI_mpragevsMfc;
        
        MI_mpragevsMo12_all(kslice,subj) = MI_mpragevsMo12;
        MI_mpragevsMm12_all(kslice,subj) = MI_mpragevsMm12;
        MI_mpragevsMo14_all(kslice,subj) = MI_mpragevsMo14;
        MI_mpragevsMmd14_all(kslice,subj) = MI_mpragevsMmd14;
        MI_mpragevsMd34_all(kslice,subj) = MI_mpragevsMd34;
        MI_mpragevsMmd34_all(kslice,subj) = MI_mpragevsMmd34;
        
        MI_mpragevsAo12_all(kslice,subj) = MI_mpragevsAo12;
        MI_mpragevsAm12_all(kslice,subj) = MI_mpragevsAm12;
        MI_mpragevsAo14_all(kslice,subj) = MI_mpragevsAo14;
        MI_mpragevsAmd14_all(kslice,subj) = MI_mpragevsAmd14;
        MI_mpragevsAd34_all(kslice,subj) = MI_mpragevsAd34;
        MI_mpragevsAd34_all(kslice,subj) = MI_mpragevsAmd34;
        
    end
end

save(fullfile(PROJ_DIR,['MI_id' id '_prestr' prestr 'data.mat']),...
    'MI_mpragevsMfo_all','MI_mpragevsMfc_all',...
    'MI_mpragevsMo12_all','MI_mpragevsMm12_all','MI_mpragevsMo14_all','MI_mpragevsMmd14_all','MI_mpragevsMd34_all','MI_mpragevsMmd34_all')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for kslice = 1:nslices
    for subj = 1:14       
        load(fullfile(PROJ_DIR,'MI_DIR',['N3DATA_first_' id '_sub' int2str(subj) '_' prestr '_kslice' int2str(kslice)]));
        MI_mpragevsMfo_all(kslice,subj) = MI_mpragevsMfo;
        MI_mpragevsMfc_all(kslice,subj) = MI_mpragevsMfc;
    end
end

save(fullfile(PROJ_DIR,['MIfirst_id' id '_prestr' prestr 'data.mat']),...
    'MI_mpragevsMfo_all','MI_mpragevsMfc_all');

%%%%%%%%%%%%%%%%%%%%%%%%%% field %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for kslice = 1:31
    for subj = 1:14       
        load(fullfile(PROJ_DIR,'MI_DIR',['BO_N3DATA_' id '_sub' int2str(subj) '_' prestr '_k' int2str(kslice)]));
        B0mpragemni_orig_all(kslice,subj) = B0mpragemni_orig;
        B0mpragemni_dico_all(kslice,subj) = B0mpragemni_dico;        
    end
end
save(fullfile(PROJ_DIR,['MIB0_id' id '_prestr' prestr 'data.mat']),'B0mpragemni_orig_all','B0mpragemni_dico_all')

end