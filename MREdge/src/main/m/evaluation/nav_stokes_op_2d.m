function [diffOp] = nav_stokes_op_2d(mu, sigma, lx)
%NAV_STOKES_OP_2D Summary of this function goes here
%   Detailed explanation goes here

dirMat = cell(2,2);

for dirIn = 1:2  
    for dirOut = 1:2
        dirMat{dirOut, dirIn} = sparse(prod(lx), prod(lx));
    end
end

boundaryId = boundary_id_2d(lx);
innerId = speye(prod(lx)) - boundaryId;

for dirIn = 1:2

    dirMat{dirIn, dirIn}  = dirMat{dirIn, dirIn} + innerId;
    dirMat{dirIn, dirIn}  = dirMat{dirIn, dirIn} + boundaryId;
    
    
    for dirOut = 1:2
        
        dirMat{dirIn, dirIn}  = dirMat{dirIn, dirIn}  + dmu_dxi_d_dxj(mu, lx, dirOut, dirOut)/sigma;
        dirMat{dirIn, dirIn}  = dirMat{dirIn, dirIn}  + mu_d_dxidxj(mu, lx, dirOut, dirOut)/sigma;
        
        dirMat{dirOut, dirIn} = dirMat{dirOut, dirIn} + dmu_dxi_d_dxj(mu, lx, dirIn, dirOut)/sigma;
        dirMat{dirOut, dirIn} = dirMat{dirOut, dirIn} + mu_d_dxidxj(mu, lx, dirIn, dirOut)/sigma;
        
    end
end

% dirMat{1,1}

diffOp = sparse(cell2mat(dirMat));


end


function [muDDxiDxj] = mu_d_dxidxj(mu, lx, i, j)

id = ndSparse(speye(prod(lx)), [lx, lx]);
kernel = diff_kernel([i,j], [1,2], [3,4]);

diffOp = red_convn(id, kernel, [1,2]);
diffOp = sparse(reshape(diffOp, [prod(lx), prod(lx)]));

muDDxiDxj = mu(:).*diffOp;

end

function [dMuDxiDxj] = dmu_dxi_d_dxj(mu, lx, i, j)

kernel = diff_kernel(i, [1,2], []);
dMuDxi = red_convn(mu, kernel, [1,2]);

id = ndSparse(speye(prod(lx)), [lx, lx]);
kernel = diff_kernel(j, [1,2], [3,4]);
diffOp = red_convn(id, kernel, [1,2]);
diffOp = sparse(reshape(diffOp, [prod(lx), prod(lx)]));

dMuDxiDxj = dMuDxi(:).*diffOp;

end

