%% Correction of subject motion in MRE
% By Marion Tardieu

% Phase must have been unwrapped

% Data are acquired with Nd phase offsets and 3 encoding directions
% supposing X, Y and Z
% => size=[Nx,Ny,Nz,Nd,3] - 5D

% To avoid artifacts during spatial normalization, it's better to mask the
% unwrapped phase data

% !!! Be carreful to the sign of the motion encoding gradients during
% acquisition. => line 179

% Need to download Tools for NifTI and Analyse image:
% http://fr.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image
% in order to create .img/.hdr data (make_nii & save_nii)

% Need spm8 for the normalization (adding to path) (Realign_estimate_h & Coregister_h)


function [PhDfR,PhSN,MagSN]=Motion_MRE_data_correction(PhuMRE,MagMRE,MagRef)
%% Opening data

% PhuMRE: unwrapped phase MRE data to normalize - 5D
% MagMRE: magnitude MRE data to normalize - 5D
% MagRef: reference magnitude data in 3D (Nx,Ny,Nz)

Nd=size(PhuMRE,4);

mkdir('Processing');
ProcessingPath=pwd;
ProcessingPath=[ProcessingPath '\Processing\'];

CurrentName='Motion_correction';

%% Saving data in .hdr/.img for spm
% Amplitude data are saving twice: one for transformation matrix estimation
% (reslice) and one for the spatial normalization (coregister)
% use make_nii.m and save_nii.m from Tools for NifTI and Analyse image
for n=1:Nd
    niiX = make_nii(MagMRE(:,:,:,n,1));
    save_nii(niiX, [ProcessingPath CurrentName '_Mag_encX_dyn' num2str(n)]);
    save_nii(niiX, [ProcessingPath CurrentName '_Mag_encX2_dyn' num2str(n)]);
    niiY = make_nii(MagMRE(:,:,:,n,2));
    save_nii(niiY, [ProcessingPath CurrentName '_Mag_encY_dyn' num2str(n)]);
    save_nii(niiY, [ProcessingPath CurrentName '_Mag_encY2_dyn' num2str(n)]);
    niiZ = make_nii(MagMRE(:,:,:,n,3));
    save_nii(niiZ, [ProcessingPath CurrentName '_Mag_encZ_dyn' num2str(n)]);
    save_nii(niiZ, [ProcessingPath CurrentName '_Mag_encZ2_dyn' num2str(n)]);
    niiX = make_nii(PhuMRE(:,:,:,n,1));
    save_nii(niiX, [ProcessingPath CurrentName '_Ph_encX_dyn' num2str(n)]);
    niiY = make_nii(PhuMRE(:,:,:,n,2));
    save_nii(niiY, [ProcessingPath CurrentName '_Ph_encY_dyn' num2str(n)]);
    niiZ = make_nii(PhuMRE(:,:,:,n,3));
    save_nii(niiZ, [ProcessingPath CurrentName '_Ph_encZ_dyn' num2str(n)]);
end

niiR = make_nii(MagRef);
save_nii(niiR, [ProcessingPath CurrentName '_RefData'])

%% Spatial normalization: transformation matrix estimation via
% spm Realign: estimate
% use Realign_estimate_h.m

Sre{1}=[ProcessingPath CurrentName '_RefData.img,1'];
for n=2:Nd+1
    d=n-1;
    Sre{n} = [ProcessingPath CurrentName '_Mag_encX_dyn' num2str(d) '.img,1'];
    Sre{Nd+n} = [ProcessingPath CurrentName '_Mag_encY_dyn' num2str(d) '.img,1'];
    Sre{2*Nd+n} = [ProcessingPath CurrentName '_Mag_encZ_dyn' num2str(d) '.img,1'];
end

Realign_estimate_h({Sre'});

% Translations and rotations of the transformation matrix are saved in
% .txt file

%% Spatial normalization: amplitude and phase data via spm coregister
% Use Coregister_h.m

Ref={[ProcessingPath CurrentName '_RefData.img,1']};
for d=1:Nd
    SourceX={[ProcessingPath CurrentName '_Mag_encX2_dyn' num2str(d) '.img,1']};
    PhSX = {[ProcessingPath CurrentName '_Ph_encX_dyn' num2str(d) '.img,1']};
    Coregister_h(Ref, SourceX,PhSX);
    SourceY={[ProcessingPath CurrentName '_Mag_encY2_dyn' num2str(d) '.img,1']};
    PhSY = {[ProcessingPath CurrentName '_Ph_encY_dyn' num2str(d) '.img,1']};
    Coregister_h(Ref, SourceY,PhSY);
    SourceZ={[ProcessingPath CurrentName '_Mag_encZ2_dyn' num2str(d) '.img,1']};
    PhSZ = {[ProcessingPath CurrentName '_Ph_encZ_dyn' num2str(d) '.img,1']};
    Coregister_h(Ref, SourceZ,PhSZ);
end

%% Spatial normalized data reading
% use Read_Analyze.m that uses

MagSN=zeros(size(permute(MagMRE,[2,1,3,4,5])));
PhSN=MagSN;

for n=1:Nd
    MagSN(:,:,:,n,1)=Read_Analyze(['r' CurrentName '_Mag_encX2_dyn' num2str(n)],ProcessingPath,1);
    MagSN(:,:,:,n,2)=Read_Analyze(['r' CurrentName '_Mag_encY2_dyn' num2str(n)],ProcessingPath,1);
    MagSN(:,:,:,n,3)=Read_Analyze(['r' CurrentName '_Mag_encZ2_dyn' num2str(n)],ProcessingPath,1);
    PhSN(:,:,:,n,1)=Read_Analyze(['r' CurrentName '_Ph_encX_dyn' num2str(n)],ProcessingPath,1);
    PhSN(:,:,:,n,2)=Read_Analyze(['r' CurrentName '_Ph_encY_dyn' num2str(n)],ProcessingPath,1);
    PhSN(:,:,:,n,3)=Read_Analyze(['r' CurrentName '_Ph_encZ_dyn' num2str(n)],ProcessingPath,1);
end

MagSN(isnan(MagSN))=0;
MagSN=permute(MagSN,[2 1 3 4 5]);
PhSN(isnan(PhSN))=0;
PhSN=permute(PhSN,[2 1 3 4 5]);

%% Displacement field renormalization: Transformation matrix

% Opening the .txt data contening rotation angles
txt=fopen([ProcessingPath 'rp_' CurrentName '_RefData.txt'],'r') ;
TMang=fscanf(txt,'%g %g',[6 inf]);
fclose(txt);

clear txt
TMang=TMang';
TMang=TMang(2:end,:);

Ntdyn=3*Nd;
RBT(3,3,Nd,3)=0;
q4(Nd,3)=0;
q5(Nd,3)=0;
q6(Nd,3)=0;

for dim=1:3
    for n=1:Nd
        q4(n,dim)=TMang(3*Ntdyn+n+(dim-1)*Nd);
        q5(n,dim)=-TMang(4*Ntdyn+n+(dim-1)*Nd); % rotation angle is negative in the
        q6(n,dim)=TMang(5*Ntdyn+n+(dim-1)*Nd);
    end
end

clear data

%% Displacement field renormalization: change of basis
% use:
%   - Rotation_Matrix_x for the rotation along the x axis
%   - Rotation_Matrix_y for the rotation along the y axis
%   - Rotation_Matrix_z for the rotation along the z axis

PhDfR=zeros(size(PhuMRE));
for n=1:Nd
    
    % Creation of the rigid body transformation matrix:
    % X encoding
    R1=Rotation_Matrix_x(q4(n,1));
    R2=Rotation_Matrix_y(q5(n,1));
    R3=Rotation_Matrix_z(q6(n,1));
    RBT(:,:,n,1)=(R1*R2*R3);
    
    % Y encoding
    R1=Rotation_Matrix_x(q4(n,2));
    R2=Rotation_Matrix_y(q5(n,2));
    R3=Rotation_Matrix_z(q6(n,2));
    RBT(:,:,n,2)=(R1*R2*R3);
    
    % Z encoding
    R1=Rotation_Matrix_x(q4(n,3));
    R2=Rotation_Matrix_y(q5(n,3));
    R3=Rotation_Matrix_z(q6(n,3));
    RBT(:,:,n,3)=(R1*R2*R3);
    
    rx1=RBT(:,:,n,1);
    ry2=RBT(:,:,n,2);
    rz3=RBT(:,:,n,3);
    
    A = [rx1(1,:);
        ry2(2,:);
        rz3(3,:)];
    Ainv = pinv(A);
    
    % !!!! Be carreful to the sign of PhSN which depends of the motion 
    % encoding gradients during acquisition
    data_x1=PhSN(:,:,:,n,1);
    data_y1=PhSN(:,:,:,n,2);
    data_z1=-PhSN(:,:,:,n,3);
    
    data_xy = Ainv*[data_x1(:)';
        data_y1(:)';
        data_z1(:)'];
    
    PhDfR(:,:,:,n,1) = reshape(data_xy(1,:), size(data_x1));
    PhDfR(:,:,:,n,2) = reshape(data_xy(2,:), size(data_y1));
    
    data_x2=-PhSN(:,:,:,n,1);
    data_y2=-PhSN(:,:,:,n,2);
    data_z2=PhSN(:,:,:,n,3);
    
    data_z = Ainv*[data_x2(:)';
        data_y2(:)';
        data_z2(:)'];
    PhDfR(:,:,:,n,3) = reshape(data_z(3,:), size(data_z2));
end

end
