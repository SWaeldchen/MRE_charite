function [p, p_thresh] = t_test_2d (pre, post, thresh)
  % runs t tests on 3d objects for each pixein in the slice
  % (c) Eric Barnhill 2016 all rights reserved
  % INPUTS:
  % pre - control condition stack. each slice is one subject
  % post - treatment condition stack. each slice is one subject. must be 
  % same x and y as post
  % thresh - optional. if included, an additional image will
  % be created thresholding all p values higher than thresh
  % OUTPUTS:
  % p - map of p values for each voxel. please remember that this
  % method makes no attempt to correct for FWER
  % p_thresh - p map, thresholded to value in argument 3
  
  sz = size(pre);
  p = zeros([sz(1) sz(2)]);
  for i = 1:sz(1)
    for j = 1:sz(2)
      pre_ij = squeeze(pre(i,j,:));
      post_ij = squeeze(post(i,j,:));
      [~, p_ij] = ttest2(pre_ij, post_ij);
      p(i,j) = p_ij;
    end
  end
  if nargin == 3
    p_thresh = zeros(size(p));
    p_thresh(abs(p) < thresh) = p(abs(p) < thresh);
  else
    p_thresh = [];
  end
    
  

end
