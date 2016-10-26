function [imaf SF]=uh_filtspatio2d(ima, samplingintervals, SFlowcut, SFloworder, SFhighcut, SFhighorder, SFmode, outflag);
%function [imaf]=uh_filtspatio2d(ima, samplingintervals, SFlowcut, SFloworder, SFhighcut, SFhighorder, SFmode, outflag);
%for k=1:20 u(:,:,k)=uh_filtspatio2d((wa(:,:,k)), [1; 1]*192/128*1e-3,100/0.192,3, 10/0.192,3, 'bwbwband', 0); end
%input
% ima:                              image data
% samplingintervals:                column vector of samplingintervals of the image grid [m]
% SFlowcut:                         wave number limit for the spatial low pass filter [1/m]
% SFloworder:                       order of the spatial butterworth low pass filter [1]
% SFhighcut:                        wave number limit for the spatial high pass filter [1/m]
% SFhighorder:                      order of the spatial butterworth high pass filter [1]
% SFmode:                           string which chooses sort of spatial filter
%                                   id: ideal filter, ga: gauss filter, bw: butterworth filter,
%                                   high: high pass filter, low: low pass filter, band: band pass filter
%                                   possible filter combinations:
%                                   'idlow', 'idhigh', 'galow', 'gahigh', 'bwlow', 'bwhigh'
%                                   'ididband', 'idgaband', 'idbwband',
%                                   'gaidband', 'gagaband', 'gabwband',
%                                   'bwidband', 'bwgaband', 'bwbwband'
% outflag:                          0: graphical output on, 1: graphical output off
%
%output
% imaf:                             filtered image data
%


matsize = size(ima)';
samplinglengths = matsize .* samplingintervals;

Ima = fftshift(fftn(ima));
if ~outflag, clear('ima');end;

origin=floor(matsize./2)+1;
[x1,x2] = ndgrid(1-origin(1):matsize(1)-origin(1), 1-origin(2):matsize(2)-origin(2));

dk1=1/samplinglengths(1);
dk2=1/samplinglengths(2);

u1 = zeros(matsize');
u2 = zeros(matsize');

u1=dk1.*x1;
u2=dk2.*x2;


% x1 = samplingintervals(1).*x1;
% x2 = samplingintervals(2).*x2;
% 
% u1 = zeros(matsize');
% u2 = zeros(matsize');
% 
% u1 = (1/(samplinglengths(1)*samplingintervals(1)))*x1;
% u2 = (1/(samplinglengths(2)*samplingintervals(2)))*x2;
clear('x*');

uabs = zeros(matsize');
uabs = sqrt(u1.*u1+u2.*u2);
clear('u1','u2');

%Spatial filter
SF = ones(matsize');
SFlow = ones(matsize');
SFhigh = ones(matsize');
switch SFmode
    case 'idlow'    %ideal low pass filter
        SF(find(uabs>=SFlowcut)) = 0;
    case 'idhigh'   %ideal high pass filter
        SF(find(uabs<=SFhighcut)) = 0;    
    case 'galow'    %gauss low pass filter
        SF = exp(-(uabs.^2)/(2*SFlowcut^2));
    case 'gahigh'   %gauss high pass filter
        SF = SF-exp(-(uabs.^2)/(2*SFhighcut^2));    
    case 'bwlow'    %butterworth low pass filter
        SF = SF./(1+(uabs/SFlowcut).^(2*SFloworder));
    case 'bwhigh'   %buttworth high pass filter
        SF = SF./(1+(SFhighcut*SF./(uabs+eps)).^(2*SFhighorder));    
    case 'ididband' %ideal band pass filter
        SFlow(find(uabs>=SFlowcut)) = 0;
        SFhigh(find(uabs<=SFhighcut)) = 0;
        SF = SFlow .* SFhigh;
    case 'idgaband' %ideal  pass filter
        SFlow(find(uabs>=SFlowcut)) = 0;
        SFhigh = SFhigh-exp(-(uabs.^2)/(2*SFhighcut^2));
        SF = SFlow .* SFhigh;
        SF = SF/max(max(SF));
    case 'idbwband'        
        SFlow(find(uabs>=SFlowcut)) = 0;
        SFhigh = SFhigh./(1+(SFhighcut*SFhigh./(uabs+eps)).^(2*SFhighorder));
        SF = SFlow .* SFhigh;
        SF = SF/max(max(SF));
    case 'gaidband'        
        SFlow = exp(-(uabs.^2)/(2*SFlowcut^2));
        SFhigh(find(uabs<=SFhighcut)) = 0;
        SF = SFlow .* SFhigh;
        SF = SF/max(max(SF));
    case 'gagaband'        
        SFlow = exp(-(uabs.^2)/(2*SFlowcut^2));
        SFhigh = SFhigh-exp(-(uabs.^2)/(2*SFhighcut^2));
        SF = SFlow .* SFhigh;
        SF = SF/max(max(SF));
    case 'gabwband'
        SFlow = exp(-(uabs.^2)/(2*SFlowcut^2));
        SFhigh = SFhigh./(1+(SFhighcut*SFhigh./(uabs+eps)).^(2*SFhighorder));
        SF = SFlow .* SFhigh;
        SF = SF/max(max(SF));
    case 'bwidband'        
        SFlow = SFlow./(1+(uabs/SFlowcut).^(2*SFloworder));
        SFhigh(find(uabs<=SFhighcut)) = 0;        
        SF = SFlow .* SFhigh;
        SF = SF/max(max(SF));
    case 'bwgaband'        
        SFlow = SFlow./(1+(uabs/SFlowcut).^(2*SFloworder));
        SFhigh = SFhigh-exp(-(uabs.^2)/(2*SFhighcut^2));
        SF = SFlow .* SFhigh;
        SF = SF/max(max(SF));
    case 'bwbwband'        
        SFlow = SFlow./(1+(uabs/SFlowcut).^(2*SFloworder));
        SFhigh = SFhigh./(1+(SFhighcut*SFhigh./(uabs+eps)).^(2*SFhighorder));
        SF = SFlow .* SFhigh;
        SF = SF/max(max(SF));
    otherwise
end %switch
%clear('SFlow','SFhigh','uabs');


Imaf = Ima .* SF;
%if ~outflag, clear('Ima','SF');end;
imaf = ifftn(ifftshift(Imaf));
%if ~outflag, clear('Imaf');end;

if outflag
    ButtonName = questdlg('Do you want to delete all existing figures?', 'Question', 'yes','no','yes');
	switch ButtonName,
      case 'yes', 
        close all;        
      case 'no',  
	end % switch
    plot2dwaves(cat(3,real(ima),0.5*log10(1+abs(Ima)),SF,real(imaf)));
end %if

