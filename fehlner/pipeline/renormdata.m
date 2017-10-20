function renormdata(RAWN_SUB,Asubject)

cd(RAWN_SUB);
Nd=8;
TMang = load('rp_RL_dyn_ma0001.txt'); % 72x6

HEAD_IMAG = spm_vol('rRL_dyn_i_4D.nii');
HEAD_REAL = spm_vol('rRL_dyn_r_4D.nii');

IMAG=spm_read_vols(HEAD_IMAG);
REAL=spm_read_vols(HEAD_REAL);

sign4=1;
sign5=-1;
sign6=1;

signx=1;
signy=2;
signz=3;

for kdat = 1:length(Asubject.dynfreqs) % freqs
    kval = (24*kdat-23):(24*kdat);
    %disp(kval);

TMP_TMang=TMang(kval,:);


Ntdyn=3*Nd;
RBT(3,3,Nd,3)=0;
q4(Nd,3)=0;
q5(Nd,3)=0;
q6(Nd,3)=0;

for dim=1:3
    for n=1:Nd
        q4(n,dim)=sign4*TMP_TMang(3*Ntdyn+n+(dim-1)*Nd);
        q5(n,dim)=sign5*TMP_TMang(4*Ntdyn+n+(dim-1)*Nd); % rotation angle is negative in theNd
        q6(n,dim)=sign6*TMang(5*Ntdyn+n+(dim-1)*Nd);
    end
end



TMP_IMAG = IMAG(:,:,:,kval);
TMP_REAL = REAL(:,:,:,kval);

PhDfR = zeros([size(TMP_REAL,1),size(TMP_REAL,2),size(TMP_REAL,3),8,3]);

for kmod = 1:2
    
    if kmod == 1
        PhSN = reshape(TMP_IMAG,[size(TMP_IMAG,1) size(TMP_IMAG,2) size(TMP_IMAG,3) 8 3]);
    end
    if kmod == 2
        PhSN = reshape(TMP_REAL,[size(TMP_IMAG,1) size(TMP_IMAG,2) size(TMP_IMAG,3) 8 3]);        
    end


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
    data_x1=signx*PhSN(:,:,:,n,1);
    data_y1=signy*PhSN(:,:,:,n,2);
    data_z1=-signz*PhSN(:,:,:,n,3);
    
    data_xy = Ainv*[data_x1(:)';
        data_y1(:)';
        data_z1(:)'];
    
    PhDfR(:,:,:,n,1) = reshape(data_xy(1,:), size(data_x1));
    PhDfR(:,:,:,n,2) = reshape(data_xy(2,:), size(data_y1));
    
    data_x2=-signx*PhSN(:,:,:,n,1);
    data_y2=-signy*PhSN(:,:,:,n,2);
    data_z2=signz*PhSN(:,:,:,n,3);
    
    data_z = Ainv*[data_x2(:)';
        data_y2(:)';
        data_z2(:)'];
    PhDfR(:,:,:,n,3) = reshape(data_z(3,:), size(data_z2));
end

    if kmod == 1
       DATA_IMG(:,:,:,:,:,kdat)=PhDfR;
    end
    if kmod == 2
       DATA_REAL(:,:,:,:,:,kdat)=PhDfR;
    end


end
end
save(fullfile(RAWN_SUB,'rrRL_dyn_i_4D.mat'),'DATA_IMG');
save(fullfile(RAWN_SUB,'rrRL_dyn_r_4D.mat'),'DATA_REAL');

%RAWN_SUB,['^' DATstr '_dyn_r_4D.nii$']);

V_im=spm_vol('MA_first.nii');
V_re=spm_vol('MA_first.nii');

Y_im = reshape(DATA_IMG,[size(DATA_REAL,1),size(DATA_REAL,2),size(DATA_REAL,3),size(DATA_REAL,4)*size(DATA_REAL,5)*size(DATA_REAL,6)]);
Y_re = reshape(DATA_REAL,[size(DATA_REAL,1),size(DATA_REAL,2),size(DATA_REAL,3),size(DATA_REAL,4)*size(DATA_REAL,5)*size(DATA_REAL,6)]);

for krep = 1:size(Y_im,4)    
    disp(krep);
    %DATA_ma = abs(Y_re(:,:,:,krep) + 1i*Y_im(:,:,:,krep));
    %DATA_ph = angle(Y_re(:,:,:,krep) + 1i*Y_im(:,:,:,krep))/pi*4096; 

    DATA_im = Y_im(:,:,:,krep);
    DATA_re = Y_re(:,:,:,krep);
    
    V_im.fname = fullfile(RAWN_SUB,['rrRL_dyn_im' sprintf('%0*d',4,krep) '.nii']);
    V_im.dt = [4 0];
    spm_write_vol(V_im,DATA_im);   % use Ph header (-4096..+4096)
        
    V_re.fname = fullfile(RAWN_SUB,['rrRL_dyn_re' sprintf('%0*d',4,krep) '.nii']);
    V_re.dt = [4 0];
    spm_write_vol(V_re,DATA_re);   % use Ph header (-4096..+4096)
    
end

merge_reim(RAWN_SUB,'rrRL');

end