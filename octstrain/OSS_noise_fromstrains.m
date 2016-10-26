% Function to estimate to octahedral shear strain SNR using propagation of 
% errors through the octahedral shear strain equation, assuming a central 
% difference approximation of derivatives.
%
% Author: Matt McGarry 14 Sept 2011.
%         Thayer School of Engineering, Dartmouth College.
%
% The differentiations required were performed in maple. 
% C:\Documents and Settings\matthew_d_mcgarry\My Documents\Research\matts
% writing\octshear paper\Prop_of_errs_OSS_SNR\Dervatives_of_oss.mw
%
% Important:: This function assumes real valued U,V,W,Un,Vn,Wn. In MRE,
% we use complex amplitudes. The octahedral shear strain is a nonlinear
% function of these complex amplitudes, and cannot be represented by a
% similar complex amplitude. To get an idea of average octahedral shear
% strain, the variation of OSS over time needs to be averaged via
% integration. See McGarry et. al, An octahedral shear strain-based measure 
% of SNR for 3D MR elastography for details. 
% The easiest way to perform this averaging is using gaussian integration
% with 5 gauss points, over half a cycle (OSS is periodic at 2x the usual 
% harmonic frequency). So this function would need to be called 5 times with 
% U,V,W etc calcualted at the time points consistent with the 5 gauss 
% points, then the gaussian quadtraure estimate of int(0 to T/2)(oss(t))dt
% can be used to calculate the average oss using
% oss_avg = 2/T * int(0 to T/2)(oss(t))dt
% The same thing needs to be done with the noise.
%
% Output: ossnoise = 3d stack of octahedral shear strain. voxels within 1 
%                    pixel of the boundaries are currently excluded because 
%                    central differences dont work. 
%            ossCD = Octahedral shear strain calculated using central
%                    differences.
%        noisemask = mask stack indicating which voxels have noise values
%                    calcualted, voxels where central differences cannot be
%                    used do not have noise values estimated.
% Inputs: U,V,W    : Real valued displacement stacks, size (Nx,Ny,Nz)
%         Un,Vn,Wn : Real valued displacement noise stacks, size (Nx,Ny,Nz).
%                    These noise components should be the real-valued 
%                    standard deviation of the real-valued displacements. 
%         hx,hy,hz : Internodal spacing. This is an update incorporating
%                    anisotropic voxels. It makes things more complicated,
%                    but the cat data is highly anisotropic
%             mask : Mask stack, defining the edges of the data. No values
%                    are calculated requiring displacements from outside the 
%                    mask for the central difference derivatives. 
function ossnoise=OSS_noise_fromstrains(oss,S_xx,S_yy,S_zz,S_xy,S_xz,S_yz,nS_xx,nS_yy,nS_zz,nS_xy,nS_xz,nS_yz)

s=size(S_xx);
ossnoise=zeros(s);

% Strain_shear = 2/3 * [ (S_xx-S_yy)^2 + (S_yy-S_zz)^2 + (S_zz-S_xx)^2 + 3/2*(Sxy^2 + Syz^2 + S_zx^2) ]^(1/2)
% Chain rule : m=(S_xx-S_yy)^2 + (S_yy-S_zz)^2 + (S_zz-S_xx)^2 + 3/2*(Sxy^2 + Syz^2 + S_zx^2)
%              ds/dm = 2/3*1/2 [ (S_xx-S_yy)^2 + (S_yy-S_zz)^2 + (S_zz-S_xx)^2 + 3/2*(Sxy^2 + Syz^2 + S_zx^2) ]^-(1/2) 
%                    = 1/3*[ (S_xx-S_yy)^2 + (S_yy-S_zz)^2 + (S_zz-S_xx)^2 + 3/2*(Sxy^2 + Syz^2 + S_zx^2) ]^-(1/2)
%                    =2/9*1/so
% 1/so=3/2*a 
% X * 3/2*a = 1/3*a
% X = 2/9;
% 2/
% 
% Derivatives of OSS w.r.t. motion derivatives
dsd_sxx = (2*(S_xx-S_yy)-2*(S_xx-S_zz)) * 2/9*1./oss;
dsd_syy = (-2*(S_xx-S_yy)+2*(S_yy-S_zz)) * 2/9*1./oss;
dsd_szz = (-2*(S_yy-S_zz)-2*(S_zz-S_xx)) * 2/9*1./oss;
dsd_sxy =  3/2*S_xy * 2/9*1./oss;
dsd_sxz =  3/2*S_xz * 2/9*1./oss;
dsd_syz =  3/2*S_yz * 2/9*1./oss;


% Now, use the propogation of errors formula, together
% with the noise in each component, calculate the
% octahedral shear strain noise
ossnoise=nS_xx.^2.*dsd_sxx.^2 + nS_yy.^2.*dsd_syy.^2 + nS_zz.^2.*dsd_szz.^2 ...
                  +nS_xy.^2.*dsd_sxy.^2 + nS_xz.^2.*dsd_sxz.^2 + nS_yz.^2.*dsd_syz.^2;
ossnoise=sqrt(ossnoise);                 

end
            

