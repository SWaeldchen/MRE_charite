function [] = createImageOverlay(alpha)
% A tool to overlay two images using an alpha channel. The source and
% destination image have to be selected manually, then the source image
% will be plotted over the target image with transparency value alpha (0 ->
% full transparency, 1-> full opacity). In addition to that, a mask can be
% selected. All pixels outside the mask will automatically be set to full
% transparency.
% Sebastian Hirsch, 29-06-11
% Last change: 29-06-11



if (nargin < 1)
	alpha = 0.8;
end

disp('Please select the source image and press any key');
pause;


sourceImg = gca;
sourceFig = gcf;


% get color limits:
clim = get(sourceImg,'CLim');

c1 = clim(1);
c2 = clim(2);
cmap = get(gcf,'Colormap');

disp('Please select the target image and press any key');
pause;

targetImg = gca;
targetFig = gcf;

hold on; % for the target images


img = getimage(sourceImg);

rgb = zeros([size(img) 3]);

for x=1:size(img,1)
	for y=1:size(img,2)
		rgb(x,y,:) = indToRGB(img(x,y));
	end
end

disp('Please select a mask for the alpha channel');
[file, filepath] = uigetfile('*roi.mat', 'Select mask file');

useAlpha = 0;

if (filepath)
	BW = load([filepath file]);
	BW = alpha*double(BW.BW);
	useAlpha = 1;
	
	h = fspecial('gaussian', 5, 0.9);
	BW = imfilter(BW,h).*BW;
end

axes(targetImg);
h = imshow(rgb);


if (useAlpha)
	set(h,'AlphaData', BW);
end





function [rgb] = indToRGB(v)
	% find the relative position of the color value in the current
	% colormap:
	p = ceil((v-c1)/(c2-c1)*size(cmap,1));
	
	p = max(1,p);
	p = min(size(cmap,1),p); % clip values outside [c1 c2]
	
	rgb = cmap(p,:);
	
end
end
