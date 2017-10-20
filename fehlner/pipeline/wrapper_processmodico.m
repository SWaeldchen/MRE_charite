function wrapper_processmodico(PROJ_DIR,Asubject,subjectlist,freqs,pixel_spacing,modicomod,voxelsize)


%class_modicoismrm.mredata_plotpic(PROJ_DIR,Asubject,subjectlist); % CHECK VALIDITY OF MNI SPACE

%class_processmodico.moveima2SCAN_SUB(PROJ_DIR,Asubject,subjectlist); % MOVES DICOMS FOR BACKUP

% class_processmodico.mredata_renormcalc(PROJ_DIR,Asubject,subjectlist,modicomod); 
% 
 class_processmodico.mredata_import(PROJ_DIR,Asubject,subjectlist,modicomod); % MAKES 4D NIFTI

% class_processmodico.mredata_ri2pm_origmoco(PROJ_DIR,Asubject,subjectlist); % COMBINES REAL AND IMAGINARY
% if modicomod > 0
% class_processmodico.mredata_ri2pm_dicomodico(PROJ_DIR,Asubject,subjectlist); % COMBINES REAL AND IMAGINARY FOR MO AND DICO
% end

class_processmodico.mredata_mdev(PROJ_DIR,Asubject,subjectlist,freqs,pixel_spacing,modicomod);



end
