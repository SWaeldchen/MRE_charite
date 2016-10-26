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
function [ossnoise,ossCD,noisemask]=OSS_noise_anisovoxels(U,V,W,hx,hy,hz,Un,Vn,Wn,mask)

s=size(mask);
ossnoise=zeros(s);
noisemask=zeros(s);
ossCD=zeros(s);
% Values required for central difference in all directions
cdvals=zeros(3,3,3);
cdvals(2,2,:)=1;
cdvals(2,:,2)=1;
cdvals(:,2,2)=1;

for ii=2:s(1)-1
    for jj=2:s(2)-1
        for kk=2:s(3)-1
            mskrg=mask(ii-1:ii+1,jj-1:jj+1,kk-1:kk+1);
            cdcheck=mskrg.*cdvals;
            if(sum(cdcheck(:))==sum(cdvals(:))) % All values required for central diff are inside mask.
                noisemask(ii,jj,kk)=1; % record this voxel as having a noise value
                % Name all the required displacments.
                upx=U(ii+1,jj,kk);
                umx=U(ii-1,jj,kk);
                vpx=V(ii+1,jj,kk);
                vmx=V(ii-1,jj,kk);
                wpx=W(ii+1,jj,kk);
                wmx=W(ii-1,jj,kk);
                
                upy=U(ii,jj+1,kk);
                umy=U(ii,jj-1,kk);
                vpy=V(ii,jj+1,kk);
                vmy=V(ii,jj-1,kk);
                wpy=W(ii,jj+1,kk);
                wmy=W(ii,jj-1,kk);
                
                upz=U(ii,jj,kk+1);
                umz=U(ii,jj,kk-1);
                vpz=V(ii,jj,kk+1);
                vmz=V(ii,jj,kk-1);
                wpz=W(ii,jj,kk+1);
                wmz=W(ii,jj,kk-1);
                
                % Octahedral shear strain calc
                
                so = 2/3 * sqrt(((upx - umx) / hx / 2 - (vpy - vmy) / hy / 2) ^ 2 + ((upx - umx) / hx / 2 - (wpz - wmz) / hz / 2) ^ 2 + ((vpy - vmy) / hy / 2 - (wpz - wmz) / hz / 2) ^ 2 + 6 * ((upy - umy) / hy / 4 + (vpx - vmx) / hx / 4) ^ 2 + 6 * ((upz - umz) / hz / 4 + (wpx - wmx) / hx / 4) ^ 2 + 6 * ((vpz - vmz) / hz / 4 + (wpy - wmy) / hy / 4) ^ 2);

                
                ossCD(ii,jj,kk)=so;
                
                % Derivatives of OSS w.r.t. u,v,w etc
                
                %Normal Derivatives -> Denominatior = 9*hj*(hx*hy*hz)
                dsdupx = (2 * hz * hy * upx - 2 * hz * hy * umx - hz * hx * vpy + hz * hx * vmy - hy * hx * wpz + hy * hx * wmz)/(9*hx^2*hy*hz*so); 
                dsdumx = -dsdupx;
                dsdvpy = (-hz * hy * upx + hz * hy * umx + 2 * hz * hx * vpy - 2 * hz * hx * vmy - hy * hx * wpz + hy * hx * wmz)/(9*hx*hy^2*hz*so);
                dsdvmy = -dsdvpy;
                dsdwpz = (-hz * hy * upx + hz * hy * umx + 2 * hy * hx * wpz - 2 * hy * hx * wmz - hz * hx * vpy + hz * hx * vmy)/(9*hx*hy*hz^2*so);
                dsdwmz = -dsdwpz;
                
                %Shear Derivatives -> Denominatior = 6*h^2*so
                dsdupy = (hx * upy - hx * umy + hy * vpx - hy * vmx)/(6*hx*hy^2*so);
                dsdumy = -dsdupy;
                dsdupz = (hx * upz - hx * umz + hz * wpx - hz * wmx)/(6*hx*hz^2*so);
                dsdumz= -dsdupz;
                dsdvpx = (hx * upy - hx * umy + hy * vpx - hy * vmx)/(6*hy*hx^2*so);
                dsdvmx = -dsdvpx;
                dsdvpz = (hy * vpz - hy * vmz + hz * wpy - hz * wmy)/(6*hy*hz^2*so);
                dsdvmz = -dsdvpz;
                dsdwpx = (hx * upz - hx * umz + hz * wpx - hz * wmx)/(6*hz*hx^2*so);
                dsdwmx = -dsdwpx;
                dsdwpy = (hy * vpz - hy * vmz + hz * wpy - hz * wmy)/(6*hz*hy^2*so);
                dsdwmy = -dsdwpy;
                
                % Now, use the propogation of errors formula, together
                % with the noise in each component, calculate the
                % ocathedral shear strain noise
                ossnoise(ii,jj,kk)=Un(ii+1,jj,kk)^2*dsdupx^2 + Un(ii-1,jj,kk)^2*dsdumx^2 + Vn(ii+1,jj,kk)^2*dsdvpx^2 + Vn(ii-1,jj,kk)^2*dsdvmx^2 ...
                                 + Wn(ii+1,jj,kk)^2*dsdwpx^2 + Wn(ii-1,jj,kk)^2*dsdwmx^2 ...
                                 + Un(ii,jj+1,kk)^2*dsdupy^2 + Un(ii,jj-1,kk)^2*dsdumy^2 + Vn(ii,jj+1,kk)^2*dsdvpy^2 + Vn(ii,jj-1,kk)^2*dsdvmy^2 ...
                                 + Wn(ii,jj+1,kk)^2*dsdwpy^2 + Wn(ii,jj-1,kk)^2*dsdwmy^2 ...
                                 + Un(ii,jj,kk+1)^2*dsdupz^2 + Un(ii,jj,kk-1)^2*dsdumz^2 + Vn(ii,jj,kk+1)^2*dsdvpz^2 + Vn(ii,jj,kk-1)^2*dsdvmz^2 ...
                                 + Wn(ii,jj,kk+1)^2*dsdwpz^2 + Wn(ii,jj,kk-1)^2*dsdwmz^2;
                ossnoise(ii,jj,kk)=sqrt(ossnoise(ii,jj,kk));               
            end
        end
    end
end

end
            

