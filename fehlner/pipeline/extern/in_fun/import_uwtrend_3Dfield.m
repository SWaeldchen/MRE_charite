function import_uwtrend_3Dfield(import_dir,save_dir,SER,sl,Ntimes,Ncomp,BW)
%
% import_uwtrend_3Dfield(import_dir,save_dir,SER,sl,Ntimes,Ncomp,BW)
% import_uwtrend_3Dfield('z:\datenoutput\paper_medium_020911','D:\mri_data\phantom\paper_medium_020911',[16  20  22  24  26  28  30  32]+1,30,8,3,BW);


%%%%%%%

cd(save_dir)

f=fopen('import.log','w');
fprintf(f,'%s\n',datestr(now));
fprintf(f,'%s\n',import_dir);
fprintf(f,'%s\n','*****SS*****');
fclose(f);

cd(import_dir)
w=dicomport(SER(1),1);
si=size(w);
a=list([num2str(SER(1)) '_1_*']);
inf=dicominfo(a);
dxdy=inf.PixelSpacing;
dz=inf.SliceThickness;
cd(save_dir)
save 'dxdy' dxdy
save 'dz' dz


%        rows  columns slices time comp freqs
W_wrap  =zeros([si(1) si(2)   sl     Ntimes    Ncomp  size(SER,1)]);
M       =zeros([si(1) si(2)   sl     Ntimes    Ncomp  size(SER,1)]);
%%%%%%


for kser=1:length(SER)
    
    ser=SER(kser);
    disp(ser)
    im=0;

for kc=1:Ncomp
    
    
    f=fopen('import.log','a');
    fprintf(f,'component: %s\n',num2str(kc));
    fclose(f);
    
    
for ts=1:Ntimes
        disp('ts')
        f=fopen('import.log','a');
        fprintf(f,'time step: %s\n',num2str(ts));
        fclose(f);

if ~exist('BW','var') % damit nicht immer die magnitudenbilder eingelesen werden
for ks=1:sl

im=im+1;

%%%%parameter%%%%
cd(import_dir)
a=list([num2str(ser) '_' num2str(im) '_*']);
para=getMREInfo(a(1,:));


m=dicomport(ser-1,im);
M(:,:,ks,ts,kc)=m;
w=dicomport(ser,im);
w=w/max(w(:))*2*pi;
W_wrap(:,:,ks,ts,kc)=w;
cd(save_dir)

end

else

    for ks=1:sl
    
    im=im+1;

%%%%parameter%%%%
cd(import_dir)
a=list([num2str(ser) '_' num2str(im) '_*']);
para=getMREInfo(a(1,:));


w=dicomport(ser,im);
w=w/max(w(:))*2*pi;
W_wrap(:,:,ks,ts,kc)=w;
cd(save_dir)

    end
end % damit nicht immer die magnitudenbilder eingelesen werden

f=fopen('import.log','a');
fprintf(f,'%s\n',[num2str(ser) ' ' num2str(im) ' ' num2str(para.MEGFrequency_Hz) ' ' num2str(para.vibrationFrequency_Hz)]);
fclose(f);

end
end


save(['W_wrap_'  num2str(SER(kser))],'W_wrap')


%%%%%%%%%%%%%%2D ROI selection%%%%%%%%%%%%%%%%%%%%%%

if ~exist('BW','var')
    
M=mean(mean(mean(M,6),5),4);
save('M','M')

figure('name','select ROI')
imagesc(mean(M,3))
colormap gray
axis image

BW=roipoly;

save('BW2D_roi.mat','BW')
end


%%%%%%%%%%%%%%%%%%%uw trend%%%%%%%%%%%%%%%%%%%%%%%%%

W=W_wrap*0;

for ks=1:size(W_wrap,3) 
    for kt=1:size(W_wrap,4) 
        for kc=1:size(W_wrap,5) 
            W(:,:,ks,kt,kc)=unwrapfmd_trend(W_wrap(:,:,ks,kt,kc),BW); 
        end; 
    end; 
end

W(:,:,:,:,1) = uw_trend(W(:,:,:,:,1),BW);
W(:,:,:,:,2) = uw_trend(W(:,:,:,:,2),BW);
W(:,:,:,:,3) = uw_trend(W(:,:,:,:,3),BW);

save(['W_' num2str(SER(kser))],'W')

Wf=fft(W,[],4)/Ntimes;

r1=reshape(real(Wf(:,:,:,2,1)),size(W,1),size(W,2)*size(W,3));
i1=reshape(imag(Wf(:,:,:,2,1)),size(W,1),size(W,2)*size(W,3));
r2=reshape(real(Wf(:,:,:,2,2)),size(W,1),size(W,2)*size(W,3));
i2=reshape(imag(Wf(:,:,:,2,2)),size(W,1),size(W,2)*size(W,3));
r3=reshape(real(Wf(:,:,:,2,3)),size(W,1),size(W,2)*size(W,3));
i3=reshape(imag(Wf(:,:,:,2,3)),size(W,1),size(W,2)*size(W,3));

plot2dwaves(cat(1,r1,i1,r2,i2,r3,i3),'cccc');
set(gcf,'units','normalized','position',[0 0 1 1])
print(gcf,'-djpeg',['ser_' num2str(SER(kser))])
close gcf

end % SER

 







