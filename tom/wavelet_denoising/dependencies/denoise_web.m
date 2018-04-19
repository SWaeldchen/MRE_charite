
function [ data ] = denoise_web( dataPath,measIndex )
    javaaddpath('/home/mre/snr_jar/jvcl-0.1.jar');
    javaaddpath('/home/mre/snr_jar/phaseTools-0.0.1-SNAPSHOT.jar');
    javaaddpath('/home/mre/snr_jar/Magnitude-0.1.jar');

    niftiInputFile=fullfile(dataPath,['data' num2str(measIndex) '.nii']);
    matlabInputFile=fullfile(dataPath,['data' num2str(measIndex) '.mat']);
    cubeInfoFile=fullfile(dataPath,['cubeInformation' num2str(measIndex) '.m'] );
    niftiResultFile=fullfile(dataPath,['denoised' num2str(measIndex)]);
    matResultFile=fullfile(dataPath,['denoised' num2str(measIndex) '.mat']);
    dicomResultFile=fullfile(dataPath,['dicom/denoised' num2str(measIndex)]);
    
    parametersFileName=fullfile(dataPath,'denoiseparameters.m');
    
    measIndex = str2num(measIndex);

    if ~exist(niftiInputFile,'file') && ~exist(matlabInputFile,'file')
        error('Input file not found!');
    end

    if ~exist(cubeInfoFile,'file')
        error('Cube info file not found!');
    end

    if ~exist(parametersFileName,'file')
        error('Parameters file not found!');
    end
    
    cI=readParameterStruct(cubeInfoFile);
    cubeInfo=cI.cubeInfo;
    
    p=readParameterStruct(parametersFileName);
    p=p.prefs;
    
    if exist(niftiInputFile,'file')
       data=load_untouch_nii_eb(niftiInputFile);
    else
       a=load(matlabInputFile);
       if isfield(a,'mreCubes') && isfield(a.mreCubes,'cube')
           data = a.mreCubes.cube;
       elseif isfield(a,'mreCubes') && isfield(a.mreCubes,'mag') && isfield(a.mreCubes,'phase')
           data.mag = a.mreCubes.mag;
           data.phase = a.mreCubes.phase;
       else
           names = fieldnames(a);
           data = a.(names{1});   
       end
    end
    
%     mag = abs(data);
%     magImg = mean(mean(mean(abs(data(:,:,:,2,1,1)),4),5),6);
    
    magImg = mean(mean(mean(data.mag(:,:,:,2,1,1),4),5),6);
    
    mask = ones(size(magImg));
    mask(magImg <= p.anat_mask_thresh_low) = 0;
    mask(magImg >= p.anat_mask_thresh_high) = 0;
    
    size(mask)
    
    nii = make_nii(mask,cubeInfo.voxelSize_m*1000);
    save_nii(nii,[niftiResultFile '.mask.nii']);
    
    phase_ft = fft(double(data.phase), [],  4);
    ft = squeeze(phase_ft(:,:,:,p.fft_bin,:,:));
    
    size(ft)
    
    nii = make_nii([real(ft(:,:,:,:,1,1));imag(ft(:,:,:,:,1,1))],cubeInfo.voxelSize_m*1000);
%     nii.img = [real(ft(:,:,:,:,1,1)); imag(ft(:,:,:,:,1,1))];
    save_nii(nii,[niftiResultFile '.noise.nii']);
    
    if strcmpi(p.denoise_strategy, 'z-xy') == 1
        for d=1:size(ft,4)
            for f=1:size(ft,5)
                ft(:,:,:,d,f) = dtdenoise_z_mad_u(ft(:,:,:,d,f), p.denoise_settings.z_thresh, p.denoise_settings.z_level, 1);
                ft(:,:,:,d,f) = dtdenoise_xy_pca_mad_u(ft(:,:,:,d,f), p.denoise_settings.xy_thresh, p.denoise_settings.xy_level, 1, mask);
                disp(['[' num2str((d-1)*size(ft,5)+f) '/' num2str(size(ft,5)*size(ft,4)) ']'])
            end
        end
    elseif strcmpi(p.denoise_strategy, '3d_soft_visu') == 1
        GAIN = 1/64;
        for d=1:size(ft,4)
            for f=1:size(ft,5)
                ft_den = dtdenoise_3d_undec(ft(:,:,:,d,f), p.denoise_settings.full3d_level, mask, GAIN);
                ft(:,:,:,d,f) = ft_den;
                disp(['[' num2str((d-1)*size(ft,5)+f) '/' num2str(size(ft,5)*size(ft,4)) ']'])
            end
        end
    elseif strcmpi(p.denoise_strategy, '3d_nng_visu') == 1
        for d=1:size(ft,4)
            for f=1:size(ft,5)
                ft(:,:,:,d,f) = dtdenoise_3d_nng(ft(:,:,:,d,f), p.denoise_settings.full3d_level, mask, p.denoise_settings.threshold_gain);
                disp(['[' num2str((d-1)*size(ft,5)+f) '/' num2str(size(ft,5)*size(ft,4)) ']'])
            end
        end
    elseif strcmpi(p.denoise_strategy, '3d_ogs') == 1
        for d=1:size(ft,4)
            for f=1:size(ft,5)
                ft(:,:,:,d,f) = dtdenoise_3d_ogs(ft(:,:,:,d,f), p.denoise_settings.full3d_level, mask);
                disp(['[' num2str((d-1)*size(ft,5)+f) '/' num2str(size(ft,5)*size(ft,4)) ']'])
            end
        end
    elseif strcmpi(p.denoise_strategy, '2d_soft_visu')
        for d=1:size(ft,4)
            for f=1:size(ft,5)
                ft(:,:,:,d,f) = dtdenoise_2d_undec(ft(:,:,:,d,f), p.denoise_settings.xy_level, mask);
                disp(['[' num2str((d-1)*size(ft,5)+f) '/' num2str(size(ft,5)*size(ft,4)) ']'])
            end
        end
        ft(isnan(ft)) = 0;      
    end
    
    data.phase = ft;
    data.mag = squeeze(data.mag(:,:,:,1,:,:));
    
    nii = make_nii(real(ft(:,:,:,:,1,1)),cubeInfo.voxelSize_m*1000);
    save_nii(nii,[niftiResultFile '.real.nii']);
    save_nii(nii,[niftiResultFile '.real.papaya.nii']);
    save_nii(nii,[niftiResultFile '.real.imageJ.nii']);
    
    nii = make_nii(imag(ft(:,:,:,:,1,1)),cubeInfo.voxelSize_m*1000);
    save_nii(nii,[niftiResultFile '.imag.nii']);
    save_nii(nii,[niftiResultFile '.real.papaya.nii']);
    save_nii(nii,[niftiResultFile '.real.imageJ.nii']);
    
    save(matResultFile,'data');
    
%     fid = fopen([dataPath 'firstFileNames.txt']);
%     if fid > -1
%             refDicomName = fgetl(fid);
%             fclose(fid);
%             makeDICOM(reshape(phase(:,:,:,:,1,1),size(phase,1),size(phase,2),size(phase,3)*size(phase,4)),dicomResultFile,refDicomName,'',1,'DENOISED',p.denoise_strategy);
%     end
    
end

