function import_wrap_3Dfield(import_dir,save_dir,SER,sl,Ntimes,Ncomp,Nfreq)
%
% import_wrap_3Dfield(import_dir,save_dir,SER,sl,Ntimes,Ncomp,Nfreq)
% saves W_wrap: W_wrap(:,:,ks,ts,kc,kf) and M (averaged over time steps, components and frequencies)
% i.s. 18.2.2013
%%%%%%%

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


%        rows  columns slices time comp freqs ser
W_wrap  =zeros([si(1) si(2)   sl     Ntimes    Ncomp  Nfreq size(SER,1)]);
M=W_wrap;
%%%%%%

for kser=1:length(SER)
    
    ser=SER(kser);
    im=0;
    cd(import_dir)
    h = waitbar(0,['import serie ' num2str(ser)]);

    
for kf=1:Nfreq  
    
    f=fopen('import.log','a');
    fprintf(f,'frequency: %s\n',num2str(kf));
    fclose(f);
    
for kc=1:Ncomp
    
    
    f=fopen('import.log','a');
    fprintf(f,'component: %s\n',num2str(kc));
    fclose(f);
    
    
for ts=1:Ntimes
        fprintf('ts ')
        f=fopen('import.log','a');
        fprintf(f,'time step: %s\n',num2str(ts));
        fclose(f);


    for ks=1:sl
    
    im=im+1;

    w=dicomport(ser,im);
    W_wrap(:,:,ks,ts,kc,kf)=w;

    
    w=dicomport(ser-1,im);
    M(:,:,ks,ts,kc,kf)=w;
    
    waitbar(im/(Nfreq*Ncomp*Ntimes*sl),h);
    end


f=fopen('import.log','a');
fprintf(f,'%s\n',[num2str(ser) ' ' num2str(im)]);

fclose(f);

end %time
end %comp
end %freq

W_wrap=W_wrap/max(W_wrap(:))*2*pi;
cd(save_dir) 
save(['W_wrap_'  num2str(SER(kser))],'W_wrap')
M=mean(mean(mean(M,6),5),4);
save(['M_'  num2str(SER(kser))],'M')
delete(h)


end % SER

 







