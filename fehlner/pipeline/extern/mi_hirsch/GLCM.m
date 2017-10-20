function g = GLCM(data1, mask1, data2, mask2, glcm, rel)
% GLCM: Calculate a joint (4D) co-occurrence matrix for two images
% Syntax: glcm = GLCM(img1, mask1, img2, mask2, glcm, relation)
% Input arguments:
%	- img1, img2: Input images, 3D arrays of the same size
% - mask1, mask2: Binary masks for the images, same size as the images
% - glcm: A predefined 4D-array to hold the result, this allows for space-efficient summation
% 	of co-occurrence matrices for different neighbour relations.
%		Initially, zeros(n,n,n,n) should be used, where n is the desired
%		number of bins for the histograms. glcm will not be overwritten,
%		but new resuls are added to those already present.
% - rel: A 3D-vector indicating the neighbour relation (connecting a voxel with its neighbour)
% Output arguments:
% - glcm: The 4D co-occurrence matrix, same size as the input parameter glcm

% Written by Sebastian Hirsch, Institute of Neuroscience and Medicine - 4, Forschungszentrum Juelich, 2009
% Reference: R. Marti, R. Zwiggelaar and C. Rubin, "A Novel Similarity Measure to Evaluate Image Correspondence", 15th International Conference on Pattern Recognition, 2000, 3

% If the two binary masks are not identical, their intersection is used.
m = mask1 & mask2;
clear mask1 mask2;

% Consider only voxels within the mask
data1 = data1 .* m;
data2 = data2 .* m;

nBins = size(glcm, 1);
stepSize = 1/nBins;

dx = rel(1);
dy = rel(2);
dz = rel(3);

% Only the values between the 1st and 99th percentile are used to reduce the imapct of outliers.
q1 = quantile(data1(m), [0.01 0.99]);
q2 = quantile(data2(m), [0.01 0.99]);
t = find(data1 < q1(1));
m(t) = 0;
data1(t) = 0;
t = find(data1 > q1(2));
m(t) = 0;
data1(t) = 0;

t = find(data2 < q2(1));
m(t) = 0;
data2(t) = 0;
t = find(data2 > q2(2));
m(t) = 0;
data2(t) = 0;

% Grey values are linearly rescaled to the interval [0,1]
mingray = min(data1(m));
maxgray = max(data1(m));
data1(m) = (data1(m)-mingray)/(maxgray-mingray);

mingray = min(data2(m));
maxgray = max(data2(m));
data2(m) = (data2(m)-mingray)/(maxgray-mingray);

[sx sy sz] = size(data1);

% The computation of the CoMa begins here
for x=1:sx
	for y=1:sy
		for z = 1:sz
			if (m(x,y,z) == 0)
				continue;
			end
			xc = x+dx;
			yc = y+dy;
			zc = z+dz;
			if ((xc < 1) || (xc > sx) || (yc < 1) || (yc > sy) || (zc < 1) || (zc > sz))
				continue;
			end
			if (m(xc,yc,zc) == 0)
				continue;
			end
			% Four pixels (2 from each image, joint by the neighbour relation) are now identified by (x,y,z) and (xc,yc,zc).
			% Determine the histogram bin numbers for the four pixels:
			c1 = ceil(data1(x,y,z)/stepSize);
			c1 = max(c1,1); %ensure that c1 >= 1
			c2 = ceil(data1(xc,yc,zc)/stepSize);
			c2 = max(c2,1);
			c3 = ceil(data2(x,y,z)/stepSize);
			c3 = max(c3,1); 
			c4 = ceil(data2(xc,yc,zc)/stepSize);
			c4 = max(c4,1); 
			% Increase the counter for the cell (c1,c2,c3,c4)
			glcm(c1,c2,c3,c4) = glcm(c1,c2,c3,c4)+1;
		end
	end
end

g=glcm;