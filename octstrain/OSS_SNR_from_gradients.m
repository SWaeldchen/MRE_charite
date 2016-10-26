function [oss,ons,OSS_SNR,OSS_SNR_Dist]=OSS_SNR_from_gradients(dudx,dudy,dudz,dvdx,dvdy,dvdz,dwdx,dwdy,dwdz,mask)

%% Octahedral Shear Strain Based SNR calcualtion

% Original Author: 
% Matt McGarry
% Thayer School of Engineering, Dartmouth College
% 29 March 2011
% Modified to use gradients at Charite
% 6 November 2011
%
% Calculates Octahedral Shear and normal strains , and an optional shear strain SNR. These
% SNR measures are based on an average over the whole volume, the
% Distribution of the SNR distribution is also output. Motion SNR's are
% given as an average over the real and imaginary componenets of all three
% directions.
%
% Function Input Arguments 
% dvdx[nx ny nz nph]: Array of displacement gradient at each measurement timepoint%
% mask[nx ny nz]: Mask
% NOTE MY CONVENTION ON COORDINATE AND MOTION DIRECTIONS:
% u = motion from (1,1,1) to (2,1,1)
% v = motion from (1,1,1) to (1,2,1)
% w = motion from (1,1,1) to (1,1,2)
% x = (:,1,1) direction
% y = (1,:,1) direction
% z = (:,:,1) direction
% Matlab often switches x and y (e.g. gradient function)
%
% The octahedral shear strain is described in this paper
% McGarry, M. D. J., et al. "An octahedral shear strain-based measure of SNR for 3D MR elastography." Physics in medicine and biology 56.13 (2011): N153.
% Since then, I have made several improvements to the calculation which scale 
% the OSS-SNR which need to be accounted for to compare OSS-SNR with results in the paper: 
% 1. I no longer use a random sign to compute the 'strain noise' - propagation of 
%    uncertianties is used assuming a central difference derivative calculation. 
%    Result: This code OSS_SNR = 1.3*OSS_SNR(paper) (See my thesis for details)
% 2. I use the standard deviation of the sinusoidal misfits rather than the
%    mean values. This form of motion noise estimate is 0.7979 of the mean 
%    of misfits (assuming 8 phase offsets).
%    Result: This code OSS_SNR = 1.25*OSS_SNR(paper)
% 3. I correct for the noise in the DC mode and fundamental mode that is
%    not included in a sinusoidal misfit noise estimate
%    Result: This code OSS_SNR = (Nph-3)/(Nph)*OSS_SNR(paper)
% So, for 8 phase offsets this code will have 1.0156 times the SNR for the
% paper. I have not experimented with what happens when the number of phase
% offsets changes from 8.
%
% Computation of noise distributions in the strain components:
% Use the Standard deviation of the misfit to a fitted sinusiod (i.e. assume all
% higher harmonics are due to noise, subtract the mean to remove the DC mode.) 
% Scaled by nph/(nph-3) to correct for the noise in the fundamental mode 
% and DC mode which is missed by this metric.
% Also, scaled by sqrt(2/nph) to get the noise in the complex amplitude from
% noise in the phase offset measurements.
% e.g. for 8 phase offsets, ndudx = sqrt(2/8)*8/(8-3)*std(dudx_i-DUDXe^it)
%
%
% Version History:
% Original Version, Strain_SNR.m Matt McGarry, 29 March 2011.
% 
% Modified to use derivative values

%% Start of Code

% Process Inputs

if(nargin<10)
    error('Requires 9 derivatives and a mask')
end
if(max(mask(:))~=1)
    error('mask should be matrix of zeros and ones')
end

s=size(dudx);
if(~isequal(s(1:3),size(mask)))
    error('Mask and derivs do not have consistent dimensions')
end


derivs=zeros([s 9]);
derivs(:,:,:,:,1)=dudx;
derivs(:,:,:,:,2)=dudy;
derivs(:,:,:,:,3)=dudz;
derivs(:,:,:,:,4)=dvdx;
derivs(:,:,:,:,5)=dvdy;
derivs(:,:,:,:,6)=dvdz;
derivs(:,:,:,:,7)=dwdx;
derivs(:,:,:,:,8)=dwdy;
derivs(:,:,:,:,9)=dwdz;


% fft each of the derivatives to extract the harmonics and noise estmates
%% Generate Complex motion amplitude and errors
deriv1=zeros(s(1),s(2),s(3),9);
nderiv=zeros(s(1),s(2),s(3),9);
nph=s(4);
for jj=1:9
    FFTU=fft(derivs(:,:,:,:,jj),[],4);
    deriv1(:,:,:,jj)=2/nph*FFTU(:,:,:,2);
    t=(0:nph-1)*2*pi/nph;
    % Compute the disagreement of the harmonic estimate with the phase data as
    % an error estimate
    Ustack4D=derivs(:,:,:,:,jj);
    Ustack4D=Ustack4D-repmat(mean(Ustack4D,4),[1 1 1 nph]); % Remove DC component
    Uharm=zeros(s(1:4));
    for kk=1:nph
        Uharm(:,:,:,kk)=real(deriv1(:,:,:,jj)*exp(i*t(kk)));
    end
    nderiv(:,:,:,jj)=nph/(nph-3)*std(Ustack4D-Uharm,0,4);   % Apply correction because this error metric misses the noise in the DC and 1st harmonic.
end


filtwidth=0.5; % Width of Gaussian smoothing filter (pixels). Wider = more smoothing.     

%% Noise Displacements
% Standard deviation of Misfits (SDM):
% ErrorMap(i,j,k,dir) = std(Up_dir(i,j,k,:) - real(U(i,j,k,dir)*exp(i*t)))
% Where Up_dir(i,j,k,:) is the N measurements at each phase offset, and
% U(i,j,k,dir) is the fitted amplitude (assumed to the fundamental
% mode of the DFT in this case), and t is the location of the phase 
% offsets, usually 0:2*pi/N:(N-1)*2*pi/N. dir is the direction (1=x,
% 2=y, 3=z). Note that it needs to be multiplied by sqrt(2/N) to 
% transform it into noise in the complex motion amplitude.  

% smooth the SDM error to reduce the variability caused by taking the 
% standard deviation over a small number of offsets. Experiments showed
% this moderate smoothing has a relativly small effect on the overall
% SNR (An increase of 1%). The smoothed distribution will have less
% effect from the limited sample size for taking the standard deviation.

for ii=1:9
    nderiv(:,:,:,jj)=smooth3dimage(nderiv(:,:,:,jj),filtwidth,mask); % use a gaussian smoothing filter with SD=0.5
end


%% Octahedral Shear Strain Calculations
sxx=deriv1(:,:,:,1);%dudx;
syy=deriv1(:,:,:,5);%dvdy;
szz=deriv1(:,:,:,9);%dwdz;
sxy=deriv1(:,:,:,2)+deriv1(:,:,:,4);%dudy+dvdx;
sxz=deriv1(:,:,:,3)+deriv1(:,:,:,7);%dudz+dwdx;
syz=deriv1(:,:,:,6)+deriv1(:,:,:,8);%dvdz+dwdy;

nsxx=nderiv(:,:,:,1);%dudx;
nsyy=nderiv(:,:,:,5);%dvdy;
nszz=nderiv(:,:,:,9);%dwdz;
nsxy=sqrt(nderiv(:,:,:,2).^2+nderiv(:,:,:,4).^2);%sqrt(dudy.^2+dvdx.^2);
nsxz=sqrt(nderiv(:,:,:,3).^2+nderiv(:,:,:,7).^2);%sqrt(dudz.^2+dwdx.^2);
nsyz=sqrt(nderiv(:,:,:,6).^2+nderiv(:,:,:,8).^2);%sqrt(dvdz.^2+dwdy.^2);


% OSS of motions
[oss,ons]=octshearstrain_derivs(sxx,syy,szz,sxy,sxz,syz);

%% OSS Noise Estimate 
% Use the function OSS_noise, which generates the OSS noise using a 
% propagation of errors analysis, assuming a central difference 
% approximation of the derivatives. No longer assumes isotropic voxels

% Use Gaussian integration to calcualte the average value of OSS noise.
a=0;
b=pi;
wt(1)=(322-13*sqrt(70))/900;
wt(2)=(322+13*sqrt(70))/900;
wt(3)=128/225;
wt(4)=wt(2); %(322+13*sqrt(70))/900;
wt(5)=wt(1); %(322-13*sqrt(70))/900;

gp(1)=-(1/3*sqrt(5+2*sqrt(10/7)));
gp(2)=-(1/3*sqrt(5-2*sqrt(10/7)));
gp(3)=0.d0;
gp(4)=-gp(2); %(1/3*sqrt(5-2*sqrt(10/7)));
gp(5)=-gp(1); %(1/3*sqrt(5+2*sqrt(10/7)));
xi=(a+b)/2.d0+(b-a)/2.d0*gp;

oss_nse=zeros(size(mask));
for ii=1:5
    % Calculate motion components at the gauss point
    sxxgp=real(sxx).*cos(xi(ii)) - imag(sxx).*sin(xi(ii));
    syygp=real(syy).*cos(xi(ii)) - imag(syy).*sin(xi(ii));
    szzgp=real(szz).*cos(xi(ii)) - imag(szz).*sin(xi(ii));
    sxygp=real(sxy).*cos(xi(ii)) - imag(sxy).*sin(xi(ii));
    sxzgp=real(sxz).*cos(xi(ii)) - imag(sxz).*sin(xi(ii));
    syzgp=real(syz).*cos(xi(ii)) - imag(syz).*sin(xi(ii));

    % Std deviation of motion noise is constant over the harmonic cycle
    [oss_noisegp]=OSS_noise_fromstrains(oss,sxxgp,syygp,szzgp,sxygp,sxzgp,syzgp,nsxx,nsyy,nszz,nsxy,nsxz,nsyz);
    oss_nse=oss_nse+oss_noisegp*wt(ii)*((b-a)/2)/pi;
end

%% OSS SNR
Imsk=find(mask==1);
OSS_SNR=mean(oss(Imsk))/mean(oss_nse(Imsk));
OSS_SNR_Dist=oss./oss_nse;
OSS_SNR_Dist(mask~=1)=0;
OSS_SNR_Dist(mask~=1)=0;

save OSS_SNR.mat filtwidth OSS_SNR OSS_SNR_Dist oss ons

end % End of Strain SNR calculation

function [ossval,onsval]=octshearstrain_derivs(sxx,syy,szz,sxy,sxz,syz)
% Function to calculate the octahedral shear strain given a polynomial fit
% of a local block of dispalcements
% Inputs : dudx etc = displacement derivatives
% Output : ossval = average octahedral shear strain at center of fitted local block
%          onsval = average octahedral normal strain at center of fitted
%          local block.

% Strain_normal = 1/3 * (S_xx +S_yy + S_zz)
% Strain_shear = 2/3 * [ (S_xx-S_yy)^2 + (S_yy-S_zz)^2 + (S_zz-S_xx)^2 + 3/2*(Sxy^2 + Syz^2 + S_zx^2) ]^(1/2)

% Set up 5 point gaussian integration to get average strain (See Oct Shear
% SNR Paper for why I do this.
a=0;
b=pi;
wt(1)=(322-13*sqrt(70))/900;
wt(2)=(322+13*sqrt(70))/900;
wt(3)=128/225;
wt(4)=wt(2); %(322+13*sqrt(70))/900;
wt(5)=wt(1); %(322-13*sqrt(70))/900;

gp(1)=-(1/3*sqrt(5+2*sqrt(10/7)));
gp(2)=-(1/3*sqrt(5-2*sqrt(10/7)));
gp(3)=0.d0;
gp(4)=-gp(2); %(1/3*sqrt(5-2*sqrt(10/7)));
gp(5)=-gp(1); %(1/3*sqrt(5+2*sqrt(10/7)));

xi=(a+b)/2.d0+(b-a)/2.d0*gp;
ossval=zeros(size(sxx));

for ii=1:size(sxx,1)
    for jj=1:size(sxx,2)
        for kk=1:size(sxx,3)
            octsgp=2/3*sqrt(real((sxx(ii,jj,kk)-syy(ii,jj,kk))*exp(1i*xi)).^2+real((syy(ii,jj,kk)-szz(ii,jj,kk))*exp(1i*xi)).^2+real((szz(ii,jj,kk)-sxx(ii,jj,kk))*exp(1i*xi)).^2 +3/2*(real(sxy(ii,jj,kk)*exp(1i*xi)).^2+real(sxz(ii,jj,kk)*exp(1i*xi)).^2+real(syz(ii,jj,kk)*exp(1i*xi)).^2));
            ossval(ii,jj,kk)=(sum(wt.*octsgp)*(b-a)/2)/pi; % Average value over one cycle
        end
    end
end
onsval=1/3*abs(sxx+syy+szz)*2/pi; % Average absolute value over one cycle


end