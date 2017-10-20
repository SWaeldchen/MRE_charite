% corr2(TPM1,average(C1)) slice-wise and B0-wise
% 
addpath('/home/stefanh/spm12');
clear all

H = spm_vol('wmyfield_mean.nii');
B0 = spm_read_vols(H);

H = spm_vol('wTPM.nii,3');
TPM = spm_read_vols(H);

H = spm_vol('MNI_c3_epi2mni_2_mean.nii');
D1 = spm_read_vols(H);

H = spm_vol('MNI_c3_epi2mni_4_mean.nii');
D2 = spm_read_vols(H);


for s=1:79
R1(s) = corr2(TPM(:,:,s),D1(:,:,s));
R2(s) = corr2(TPM(:,:,s),D2(:,:,s));
% X1 = TPM(:,:,s) - D1(:,:,s);
% X2 = TPM(:,:,s) - D2(:,:,s);
% % X1 = ( (TPM(:,:,40)>0.5) + (D1(:,:,40)>0.5) ==2 ); %2=overlap, 1=mismatch
% % X2 = ( (TPM(:,:,40)>0.5) + (D2(:,:,40)>0.5) ==2 );
% sX1(s) = sum(X1(:));
% sX2(s) = sum(X2(:));
B(s) = mean2((squeeze( (B0(:,:,s).*(D1(:,:,s)>0.5)) )));
end
figure
subplot(311)
plot(R1), hold on, plot(R2,'r'), xlim([20 70]), title('corr, red=dico')
subplot(312)
plot(R2-R1), ylim([-0.01 0.07]), title('delta corr')
subplot(313)
plot(B), xlim([20 70]), ylim([-1 2]), title('B0')
% figure; plot(sX1), hold on, plot(sX2,'r')


s=36
figure;imagesc(cat(2,B0(:,:,s)/120+0.5,TPM(:,:,s),D1(:,:,s),D2(:,:,s)),[0 1]), axis image, axis off, colormap(gray)
% figure;imshowpair(TPM(:,:,s),D1(:,:,s))
