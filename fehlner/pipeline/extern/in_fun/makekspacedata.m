function [wk wc]=makekspacedata(ser_magn, ima_magn)
%
% [wk wc]=makekspacedata(ser_magn, ima_magn)
%


w=import_macro_dicom_3([ser_magn   ima_magn]);
p=import_macro_dicom_3([ser_magn+1 ima_magn]);
p=p/4094*2*pi;

warning off
Re=w./sqrt(tan(p).^2+1);
Im=w./sqrt(1./tan(p).^2+1);
warning on

wc=Re+i*Im;
wk=fftshift(ifft2(wc));