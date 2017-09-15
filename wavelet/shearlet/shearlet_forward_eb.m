
function v = shearlet_forward_eb(u)

%%settings
sigma = 30;
scales = 3;
shearLevels = [1 1];
thresholdingFactor = 3;
directionalFilter = modulate2(dfilters('cd','d')./sqrt(2),'c');

%%create shearlets
shearletSystem = SLgetShearletSystem3D(0,size(X,1),size(X,2),size(X,3),scales,shearLevels,0,directionalFilter);

elapsedTime = toc;
fprintf([num2str(elapsedTime), ' s\n']);
tic;
fprintf('decomposition, thresholding and reconstruction... ');

%%decomposition
coeffs = SLsheardec3D(Xnoisy,shearletSystem);

%%thresholding
for n = 1:size(coeffs,4)-1
    coeffs(:,:,:,n) = coeffs.*(abs(coeffs) > thresholdingFactor*reshape(repmat(shearletSystem.RMS,[size(X,1)*size(X,2)*size(X,3) 1]),[size(X,1),size(X,2),size(X,3),length(shearletSystem.RMS)])*sigma);

%%reconstruction
Xrec = SLshearrec3D(coeffs,shearletSystem);

elapsedTime = toc;
fprintf([num2str(elapsedTime), ' s\n']);

%%compute psnr
PSNR = SLcomputePSNR(X,Xrec);

fprintf(['PSNR: ', num2str(PSNR) , ' db\n']);

%
%  Copyright (c) 2014. Rafael Reisenhofer
%
%  Part of ShearLab3D v1.1
%  Built Mon, 10/11/2014
%  This is Copyrighted Material
%
%  If you use or mention this code in a publication please cite the website www.shearlab.org and the following paper:
%  G. Kutyniok, W.-Q. Lim, R. Reisenhofer
%  ShearLab 3D: Faithful Digital SHearlet Transforms Based on Compactly Supported Shearlets.
%  ACM Trans. Math. Software 42 (2016), Article No.: 5.
