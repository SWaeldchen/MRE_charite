
function [imout]=smooth3dimage(im,std,mask)
% 
% Author: Matt Mcgarry, 17 June 2011
% Smooths a 3d image with an optional mask
% Inputs: im: 3d images stack to be smoothed
%         std: Standard devaition of gaussian smoothing kernel, in pixels
%         mask(optional) : Mask, will not use values outside of mask for
%         smoothing. This keeps values past the edges of an object from
%         affecting the smmothed image.
% Examples:  
% [imout]=smooth3dimage(im,2.5,mask) will smooth the masked
%  regions of im with a gaussian filter, standard deviation 2.5 pixels
% [imout]=smooth3dimage(im,1) will smooth the whole of im with a
%  gaussian filter, standard deviation 1 pixel

d=size(im);

if(nargin<2)
    error('Not enough Arguments')
elseif(nargin==2)
    mask=ones(d);
elseif(nargin>3)
    error('too many arguments')
end

if ( sum(size(mask)==d)~=length(d) )
    error('mask must be same size as im')
end
% ensure filter is big enough and odd-sized
siz=round(5*std);
if(mod(siz,2)==0)
    siz=siz+1;
end
if(siz<3)
    siz=3;
end

[H] = gaussian3d(siz,std);
[imout]=filter3Dmask(im,mask,H);

end

function [stackout]=filter3Dmask(stackin,mask,H)
% Performs spatial filtering but does not use values outside the Mask

dim=size(stackin);
stackout=stackin;
filtsiz=size(H);
lf=floor(filtsiz/2); % Distance back and forward of centre of filter
cn=ceil(filtsiz/2); % centre of filter
if(mod(filtsiz(1),2)==0||mod(filtsiz(2),2)==0||mod(filtsiz(3),2)==0)
    error('Filter must be odd-sized')
end

for ii=1:dim(1)
    for jj=1:dim(2)
        for kk=1:dim(3)
            if(mask(ii,jj,kk)==1) %perform filtering
                lm=[max(1,ii-lf(1)) min(dim(1),ii+lf(1)); % Limits to cut out subregion
                      max(1,jj-lf(2)) min(dim(2),jj+lf(2));
                      max(1,kk-lf(3)) min(dim(3),kk+lf(3))];
                subreg=stackin(lm(1,1):lm(1,2),lm(2,1):lm(2,2),lm(3,1):lm(3,2));
                submask=mask(lm(1,1):lm(1,2),lm(2,1):lm(2,2),lm(3,1):lm(3,2));
                % Need to build filter same size as subregion
                la=[max(1,cn(1)-ii+1) max(1,cn(2)-jj+1) max(1,cn(3)-kk+1)]; % first value in each dimension..
                ss=size(subreg);
                Hc=H(la(1):la(1)+ss(1)-1,la(2):la(2)+ss(2)-1,la(3):la(3)+ss(3)-1);
                Hmsk=submask.*Hc;
                Hmsk=Hmsk./sum(Hmsk(:));
                stackout(ii,jj,kk)=sum(Hmsk(:).*subreg(:));                
            end             
        end
    end
end

end









function [H] = gaussian3d(siz,std) % Gaussian filter

 siz   = (siz-1)/2;
 [x,y,z] = meshgrid(-siz:siz,-siz:siz,-siz:siz);
 arg   = -(x.*x + y.*y + z.*z)/(2*std*std);

 H     = exp(arg);
 H(H<eps*max(H(:))) = 0;

 sumh = sum(H(:));
 if sumh ~= 0,
   H  = H/sumh;
 end;

end