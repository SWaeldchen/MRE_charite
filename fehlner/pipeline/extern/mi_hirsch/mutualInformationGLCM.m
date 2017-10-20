function mi = mutualInformationGLCM(data1, mask1, data2, mask2)
% MUTUALINFORMATIONGLCM: Calcuate the mutual information based on co-occurence matrices for two images
% Syntax: mi = mutualInformationGLCM(img1, mask1, img2, mask2)
% Input arguments:
%	- img1, img2: 3D arrays of the same size, containing two input images
% - mask1, mask2: Binary masks for the images (same size as img1 and img2),
%		only voxels within the mask are considered in the calculation. If
%		mask1 != mask2,	the intersection (mask1 & mask2) is used for both images
%	Output arguments:
%	- mi: The mutual information for the images, 0 <= mi <= 1
% 	mi=1 indicates perfect agreement between the information contained
%		in the two images, mi=0 means not information overlap.

% Written by Sebastian Hirsch, Institute of Neuroscience and Medicine - 4, Forschungszentrum Juelich, 2009
% Reference: R. Marti, R. Zwiggelaar and C. Rubin, "A Novel Similarity Measure to Evaluate Image Correspondence", 15th International Conference on Pattern Recognition, 2000, 3

m = mask1 & mask2;
clear mask1 mask2;

nBins = 32; % number of histogram bins for the co-occurence matrix

glcm = zeros(nBins,nBins,nBins,nBins, 'uint32');

% The joint co-occurrence matrix is calculated and added up for all neighbour relations of degree 1,2,3 on a hemisphere.

% First order (d=1) 
glcm = GLCM(data1,m,data2,m,glcm,[0 1 0]);
glcm = GLCM(data1,m,data2,m,glcm,[1 0 0]);
glcm = GLCM(data1,m,data2,m,glcm,[0 0 1]);

% Second order (d=sqrt(2))
glcm = GLCM(data1,m,data2,m,glcm,[0 1 1]);
glcm = GLCM(data1,m,data2,m,glcm,[1 0 1]);
glcm = GLCM(data1,m,data2,m,glcm,[0 1 -1]);
glcm = GLCM(data1,m,data2,m,glcm,[1 0 -1]);
glcm = GLCM(data1,m,data2,m,glcm,[-1 1 0]);
glcm = GLCM(data1,m,data2,m,glcm,[1 1 0]);

% Third order (d=sqrt(3))
glcm = GLCM(data1,m,data2,m,glcm,[1 1 1]);
glcm = GLCM(data1,m,data2,m,glcm,[1 1 -1]);
glcm = GLCM(data1,m,data2,m,glcm,[-1 1 -1]);
glcm = GLCM(data1,m,data2,m,glcm,[-1 1 1]);

% Normalisation of the co-occurence matrix
n=sum(glcm(:));

% The single image co-occurrence matrices are calculated by
% procjecting the joint CoMa along the two axes that belong
% to the other image
glcm1 = squeeze(sum(sum(glcm,4),3))/n;
glcm2 = squeeze(sum(sum(glcm,1),2))/n;

% Calculation of the mutual information from the joint and single-image co-occurrence matrices:

combEntropy = 0;
refEntropy1 = 0;
refEntropy2 = 0;

for p=1:nBins
	for q=1:nBins
		if (glcm1(p,q) ~= 0)
		  refEntropy1 = refEntropy1 - double(glcm1(p,q))*reallog(double(glcm1(p,q)));
		end
		if (glcm2(p,q) ~= 0)
		  refEntropy2 = refEntropy2 - double(glcm2(p,q))*reallog(double(glcm2(p,q)));
		end
		for k=1:nBins
			for l=1:nBins
				if ((glcm2(k,l) == 0) || (glcm(p,q,k,l) == 0))
					continue;
				end
				r=double(glcm(p,q,k,l))/n;
				s=double(glcm1(p,q)*glcm2(k,l));
				combEntropy = combEntropy +  r*reallog(r/s);
			end
		end
	end
end

mi = 2*combEntropy/(refEntropy1+refEntropy2);