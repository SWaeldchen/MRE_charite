


lx(1) = 5;
lx(2) = 5;
lx(3) = 5;

gridSize = max(lx);
rho = 1;
mu = ones(lx);
omega = 20;

sigma = omega^2/gridSize^3;

dirMat = cell(3,3);

for dirIn = 1:3  
    for dirOut = 1:3
        dirMat{dirOut, dirIn} = sparse(prod(lx), prod(lx));
    end
end

for dirIn = 1:3
    
    for dirOut = 1:3
        
        dirMat{dirIn, dirIn}  = dirMat{dirOut, dirIn} + dmu_dxi_d_dxj(mu, lx, dirOut, dirOut);
        dirMat{dirIn, dirIn}  = dirMat{dirOut, dirIn} + mu_d_dxidxj(mu, lx, dirOut, dirOut);
        
        dirMat{dirOut, dirIn} = dirMat{dirOut, dirIn} + dmu_dxi_d_dxj(mu, lx, dirIn, dirOut);
        if dirOut ~= dirIn
            dirMat{dirOut, dirIn} = dirMat{dirOut, dirIn} + mu_d_dxidxj(mu, lx, dirIn, dirOut);
        end
        
    end
end

diffOp = sparse(cell2mat(dirMat));

boundary = zeros(lx);

x1Vec = zeros(lx(1),1,1); x1Vec(1) =1; x1Vec(end) = 1;
x2Vec = zeros(1,lx(2),1); x2Vec(1) =1; x2Vec(end) = 1;
x3Vec = zeros(1,1,lx(3)); x3Vec(1) =1; x3Vec(end) = 1;

boundary(x1Vec|x2Vec|x3Vec) = 1;
inner = 1 - boundary;

innerId = spdiags([inner(:);inner(:);inner(:)], 0, 3*prod(lx), 3*prod(lx));
boundaryId = spdiags([boundary(:);boundary(:);boundary(:)], 0, 3*prod(lx), 3*prod(lx));

size(innerId)
size(boundaryId)
size(diffOp)

waveOp = diffOp + sigma*innerId + boundaryId;

boundaryU = ones([lx,3]).*boundary;

tic
u = waveOp\boundaryU(:);
toc

u = reshape(u, [lx,3]);

im = reshape(u(:,3,:,1), [lx(1), lx(3)])

MIJ = Miji;
openImage(u(:,:,:,:), MIJ, 'title');


function [muDDxiDxj] = mu_d_dxidxj(mu, lx, i, j)

id = ndSparse(speye(prod(lx)), [lx(1), lx(2), lx(3), lx(1), lx(2), lx(3)]);
kernel = diff_kernel([i,j], [1,2,3], [4,5,6]);

diffOp = red_convn(id, kernel, [1,2,3]);
diffOp = reshape(diffOp, [prod(lx), prod(lx)]);
diffOp = sparse(diffOp);

muDDxiDxj = diffOp.*mu(:)';

end

function [dMuDxiDxj] = dmu_dxi_d_dxj(mu, lx, i, j)

id = ndSparse(speye(prod(lx)), [lx(1), lx(2), lx(3), lx(1), lx(2), lx(3)]);
kernel = diff_kernel([j], [1,2,3], [4,5,6]);

diffOp = red_convn(id, kernel, [1,2,3]);
diffOp = reshape(diffOp, [prod(lx), prod(lx)]);
diffOp = sparse(diffOp);

kernel = diff_kernel([i], [1,2,3], []);

dMuDxi = red_convn(mu, kernel, [1,2,3]);

dMuDxiDxj = diffOp.*dMuDxi(:)';

end



% 
% function [muD2Dxi2] = mu_d2dxi2(mu, lx, i)
% 
% id = ndSparse(speye(prod(lx)), [lx(1), lx(2), lx(3), lx(1), lx(2), lx(3)]);
% 
% kernelShape = ones(1,6);
% kernelShape(i) = 3;
% 
% diffOp = convn(id, reshape(lap_kernel, kernelShape), 'valid');
% diffOp = correct_boundary(diffOp, i, [4,5,6]);
% 
% diffOp = reshape(diffOp, [prod(lx), prod(lx)]);
% diffOp = sparse(diffOp);
% 
% muShaved = correct_boundary(mu, [], []);
% 
% muD2Dxi2 = diffOp.*muShaved(:)';
% 
% end

% 
% 
% 
% function [diffOp] = diff_op(lx, diffKernel, dir)
% %DIFF_OP Summary of this function goes here
% %   Detailed explanation goes here
% 
% id = ndSparse(speye(prod(lx)), [lx(1), lx(2), lx(3), lx(1), lx(2), lx(3)]);
% 
% kernelShape = ones(1,6);
% kernelShape(dir) = 3;
% 
% diffOp = convn(id, reshape(diffKernel, kernelShape), 'valid');
% diffOp = correct_boundary(diffOp, dir, [4,5,6]);
% 
% diffOp = reshape(diffOp, [prod(lx), prod(lx)]);
% diffOp = sparse(diffOp);
% 
% end
% 
% function [kernel] = diff_kernel(diffDims, outDims, inDims)
% 
% diffKernel = [-1, 1, 0];
% lapKernel = [1, -2, 1];
% diff_ijKernel = [[1, -1, 0]; [-1, 1, 0]; [0,0,0]];
% 
% numofArgs = nargin
% 
% outDims
% length(diffDims)
% 
% if length(diffDims) == 1
%     kernel = diffKernel;
% elseif length(diffDims) == 2
%     if diffDims(1) == diffDims(2)
%         kernel = lapKernel;
%     else
%         kernel = diff_ijKernel
%     end
% else
%     error("Don't do more than two derivatives")
% 
% end
% 
% numofDims = length(outDims) + length(inDims);
% 
% kernelShape = ones(1, numofDims);
% kernelShape(diffDims) = 3;
%     
% kernel = reshape(kernel, kernelShape);
% 
% %%% Padding
% 
% padShape = zeros(1, numofDims);
% padShape(setdiff(outDims, diffDims)) = 1;
% 
% kernel = padarray(kernel, padShape);
% 
% 
% end

% d_dx2 = reshape(conv(d_dx2_kernel(:), id(:)), [lx1*lx2*lx3, lx1*lx2*lx3]);
% d_dx3 = reshape(conv(d_dx3_kernel(:), id(:)), [lx1*lx2*lx3, lx1*lx2*lx3]);
% 
