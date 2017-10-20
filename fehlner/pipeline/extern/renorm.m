clear all
% (PhuMRE => 5D

addpath ~/af_domhome/Motion_correction_MRE_to_share/Functions/

cd('/media/afdata/project_modico/MREPERF-AR_20150706-095001/RAWN/');

Nd=8;

TMang = load('rp_RL_dyn_ma0001.txt'); % 72x6

TMang=TMang(1:24,:);
%TMang=TMang(2:end,:);


Ntdyn=3*Nd;
RBT(3,3,Nd,3)=0;
q4(Nd,3)=0;
q5(Nd,3)=0;
q6(Nd,3)=0;

for dim=1:3
    for n=1:Nd
        q4(n,dim)=TMang(3*Ntdyn+n+(dim-1)*Nd);
        q5(n,dim)=-TMang(4*Ntdyn+n+(dim-1)*Nd); % rotation angle is negative in theNd
        disp(5*Ntdyn+n+(dim-1)*Nd);
        q6(n,dim)=TMang(5*Ntdyn+n+(dim-1)*Nd);
    end
end

addpath /opt/MATLAB/R2015b/toolbox/spm12/

cd('/media/afdata/project_modico/MREPERF-AR_20150706-095001/RAWN');
IMAG=spm_read_vols(spm_vol('rRL_dyn_i_4D.nii'));
REAL=spm_read_vols(spm_vol('rRL_dyn_r_4D.nii'));

TMP_IMAG=IMAG(:,:,:,1:24);
TMP_REAL=REAL(:,:,:,1:24);

PhSN = reshape(TMP_IMAG,[size(TMP_IMAG,1) size(TMP_IMAG,2) size(TMP_IMAG,3) 8 3]);

PhDfR=zeros([size(PhSN,1),size(PhSN,2),size(PhSN,3),8,3]);

% => size=[Nx,Ny,Nz,Nd,3] - 5D

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
