function import_complex_field(import_dir,save_dir,SER,sl,Ntimes,Ncomp)
%
% import_complex_field(import_dir,save_dir,SER,sl,Ntimes,Ncomp)
% import_complex_field('z:\datenoutput\Hasenbein_Jens_Parkinson_110517','D:\MRI_data\brain\3d\parkinson\Hasenbein_Jens_Parkinson_110517',15,30,4,3);
%
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
W  =zeros([si(1) si(2)   sl     Ntimes    Ncomp]);
M  =zeros([si(1) si(2)   sl     Ntimes    Ncomp]);
C  =zeros([si(1) si(2)   sl     Ntimes    Ncomp]);
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


    for ks=1:sl
    
    im=im+1;

    %%%%parameter%%%%
    cd(import_dir)
    a=list([num2str(ser) '_' num2str(im) '_*']);
    para=getMREInfo(a(1,:));

    w=dicomport(ser-1,im);
    M(:,:,ks,ts,kc)=w;
    
    w=dicomport(ser,im);
    w=w/max(w(:))*2*pi;
    W(:,:,ks,ts,kc)=w;
    cd(save_dir)

    end


f=fopen('import.log','a');
fprintf(f,'%s\n',[num2str(ser) ' ' num2str(im) ' ' num2str(para.MEGFrequency_Hz) ' ' num2str(para.vibrationFrequency_Hz)]);
fclose(f);

end
end

C=M.*exp(i*W);
save(['C_'  num2str(SER(kser))],'C')



end % SER

 







