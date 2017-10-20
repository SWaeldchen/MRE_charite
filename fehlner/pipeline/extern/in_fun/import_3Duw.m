function import_3Duw(name,importpath,savepath,ser,sl,Ntimes,save_name)
%
% import_3Duw('MMRE_braintumors_yg_2012_11_15','z:\datenoutput_2012\','D:\MRI_data\brain\3D\MMRE_tumors\',4,15,8,'50Hz');
% manual selection of 'BW2D_roi.mat'
%


Ncomp=3;

%%%%%%%

%savepath='D:\mri_data\liver\TIPPS\';
%importpath='z:\datenoutput_2012\';


pathname=[savepath name];
disp(pathname)
cd(pathname)

f=fopen('import.log','w');
fprintf(f,'%s\n',datestr(now));
fprintf(f,'%s\n',[importpath name]);
fprintf(f,'%s\n','*****SS*****');
fclose(f);

cd([importpath name])
w=dicomport(ser,1);
si=size(w);
a=list([num2str(ser) '_1_*']);
inf=dicominfo(a);
dxdy=inf.PixelSpacing;
dz=inf.SliceThickness;
cd(pathname)
save 'dxdy' dxdy
save 'dz' dz


%        rows  columns slices time comp freqs
W_wrap  =zeros([si(1) si(2)   sl     Ntimes    Ncomp ]);
M       =zeros([si(1) si(2)   sl     Ntimes    Ncomp ]);
%%%%%%



for kc=1:Ncomp
    
    
    f=fopen('import.log','a');
    fprintf(f,'component: %s\n',num2str(kc));
    fclose(f);
    im=0;
    
for ts=1:Ntimes
        disp('ts')
        f=fopen('import.log','a');
        fprintf(f,'time step: %s\n',num2str(ts));
        fclose(f);
        
for ks=1:sl

im=im+1;

%%%%parameter%%%%
cd([importpath name])
a=list([num2str(ser) '_' num2str(im) '_*']);
para=getMREInfo(a(1,:));


m=dicomport(ser-1,im);
M(:,:,ks,ts,kc)=m;
w=dicomport(ser,im);
w=w/max(w(:))*2*pi;
W_wrap(:,:,ks,ts,kc)=w;
cd(pathname)

end

f=fopen('import.log','a');
fprintf(f,'%s\n',[num2str(ser) ' ' num2str(im) ' ' num2str(para.MEGFrequency_Hz) ' ' num2str(para.vibrationFrequency_Hz)]);
fclose(f);

end
end


M=mean(mean(mean(M,6),5),4);
save(['M_' save_name],'M')
save(['W_wrap_' save_name],'W_wrap')
save(['para_' save_name],'para')

%%%%%%%%%%%%%%2D ROI selection%%%%%%%%%%%%%%%%%%%%%%

if exist('BW2D_roi.mat','file')
   
load('BW2D_roi.mat')    

else
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
            W(:,:,ks,kt,kc)=unwrapfmd(W_wrap(:,:,ks,kt,kc),BW); 
        end; 
    end; 
end


save(['W_' save_name],'W')

Wf=fft(W,[],4)/Ntimes;

r1=reshape(real(Wf(:,:,:,2,1)),size(W,1),size(W,2)*size(W,3));
i1=reshape(imag(Wf(:,:,:,2,1)),size(W,1),size(W,2)*size(W,3));
r2=reshape(real(Wf(:,:,:,2,2)),size(W,1),size(W,2)*size(W,3));
i2=reshape(imag(Wf(:,:,:,2,2)),size(W,1),size(W,2)*size(W,3));
r3=reshape(real(Wf(:,:,:,2,3)),size(W,1),size(W,2)*size(W,3));
i3=reshape(imag(Wf(:,:,:,2,3)),size(W,1),size(W,2)*size(W,3));

plot2dwaves(cat(1,r1,i1,r2,i2,r3,i3),'cccccccc');
set(gcf,'units','normalized','position',[0 0 1 1])
print(gcf,'-djpeg',save_name)
close gcf








