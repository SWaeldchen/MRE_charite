function makekopp(k_l,k_q)
%
%
%

global W

d1=size(k_q,1);
d2=size(k_l,2);
nzes=d1*d2+2*((d1-1)*d2)+2*(d1*(d2-1));
fprintf(1,'number of non zero elements: %d\n',nzes);
W=spalloc(d1*d2,d1*d2,nzes);

W=spdiags(reshape([zeros(1,d2); k_l],d1*d2,1),1,d1*d2,d1*d2) + ...
  spdiags(reshape([k_l; zeros(1,d2)],d1*d2,1),-1,d1*d2,d1*d2) + ...
  spdiags(reshape([zeros(d1,1), k_q],d1*d2,1),d1,d1*d2,d1*d2) + ...
  spdiags(reshape([k_q, zeros(d1,1)],d1*d2,1),-d1,d1*d2,d1*d2);  

k_diagonal=-sum(W);
W=spdiags(k_diagonal',0,W);


spy(W)
