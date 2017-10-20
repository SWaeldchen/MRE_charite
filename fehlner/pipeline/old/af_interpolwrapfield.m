function af_interpolwrapfield(ANA_DIR,magfile)

cd(ANA_DIR);

headersOut = spm_vol([magfile '.nii']);
sOut = size(spm_read_vols(headersOut));

if (strcmp(magfile,'MAGf_orig'))
	txtstr = 'orig';
end

if (strcmp(magfile,'MAGf_dico'))
	txtstr ='dico';
end

if (strcmp(magfile,'MAGm_orig'))
	txtstr = '1';
end

if (strcmp(magfile,'MAGm_moco'))
	txtstr = '2';
end

if (strcmp(magfile,'MAGm_dico'))
	txtstr = '3';
end

if (strcmp(magfile,'MAGm_modico'))
	txtstr ='4';
end


load([magfile '_seg8.mat']);
warp_dr_x = Twarp(:,:,:,1);
warp_dr_y = Twarp(:,:,:,2);
warp_dr_z = Twarp(:,:,:,3);

% HDR
hdr_dr_x = headersOut;
hdr_dr_y = headersOut;
hdr_dr_z = headersOut;


hdr_dr_x.fname = ['wx_Twarp_' txtstr '.nii'];
hdr_dr_x.private.dat.fname = hdr_dr_x.fname;

hdr_dr_y.fname = ['wy_Twarp_' txtstr '.nii'];
hdr_dr_y.private.dat.fname = hdr_dr_y.fname;

hdr_dr_z.fname = ['wz_Twarp_' txtstr '.nii'];
hdr_dr_z.private.dat.fname = hdr_dr_z.fname;

xIn = linspace(0,1,size(warp_dr_x,1));
yIn = linspace(0,1,size(warp_dr_y,2));
zIn = linspace(0,1,size(warp_dr_z,3));

xOut = linspace(0,1,sOut(1));
yOut = linspace(0,1,sOut(2));
zOut = linspace(0,1,sOut(3));

gi = griddedInterpolant;
gi.GridVectors = {xIn yIn zIn};
%gi.Values = warp_dr;
gi.Method = 'spline';

% regrid the data
%warp_dr_ip = gi({xOut yOut zOut});
gi.Values = warp_dr_x;
warp_dr_x_ip = gi({xOut yOut zOut});
gi.Values = warp_dr_y;
warp_dr_y_ip = gi({xOut yOut zOut});
gi.Values = warp_dr_z;
warp_dr_z_ip = gi({xOut yOut zOut});

hdr_dr_x.dt = [64 0];
hdr_dr_y.dt = [64 0];
hdr_dr_z.dt = [64 0];

spm_write_vol(hdr_dr_x,warp_dr_x_ip);
spm_write_vol(hdr_dr_y,warp_dr_y_ip);
spm_write_vol(hdr_dr_z,warp_dr_z_ip);

end
