function A = assemble_sfwi_super_matrix_tikhonov(sz, lam)

R = sz(1);
C = sz(2);
RC = sz(1)*sz(2);
N = prod(sz);
szs = sz*2;
NS = prod(szs);
RS = szs(1);
CS = szs(2);
RCS = szs(1)*szs(2);

eye_j = [];
eye_i = [];
eye_v = [];

ceil2 = @(n) ceil(n/2);
%assemble each column
% odd -> known
for n = 1:NS
    [I, J, K] = ind2sub(szs, n);
    i = min(ceil(I/2), sz(1)-1); j = min(ceil(J/2), sz(2)-1); k = min(ceil(K/2),sz(3)-1);
    if odd(K)
        if odd(J)
            if odd(I)
                eye_j = cat(1, eye_j, n);
                eye_i = cat(1, eye_i, sub2ind(sz, i, j, k));
                eye_v = cat(1, eye_v, 1);
            else
                eye_j = cat(1, eye_j, n, n);
                eye_i = cat(1, eye_i, sub2ind(sz, i, j, k), sub2ind(sz, i+1, j, k));
                eye_v = cat(1, eye_v, 0.5, 0.5);
            end
        else
            if odd(I)
                eye_j = cat(1, eye_j, n, n);
                eye_i = cat(1, eye_i, sub2ind(sz, i, j, k), sub2ind(sz, i, j+1, k));
                eye_v = cat(1, eye_v, 0.5, 0.5);
            else
                eye_j = cat(1, eye_j, n, n, n, n);
                eye_i = cat(1, eye_i, sub2ind(sz, i, j, k), sub2ind(sz, i+1, j, k), ...
                                      sub2ind(sz, i, j+1, k), sub2ind(sz, i+1, j+1, k));
                eye_v = cat(1, eye_v, 0.25, 0.25, 0.25, 0.25);
            end
        end
    else
        if odd(J)
            if odd(I)
                eye_j = cat(1, eye_j, n, n);
                eye_i = cat(1, eye_i, sub2ind(sz, i, j, k), sub2ind(sz, i, j, k+1));
                eye_v = cat(1, eye_v, 0.5, 0.5);
            else
                eye_j = cat(1, eye_j, n, n, n, n);
                eye_i = cat(1, eye_i, sub2ind(sz, i, j, k), sub2ind(sz, i+1, j, k), ...
                                      sub2ind(sz, i, j, k+1), sub2ind(sz, i+1, j, k+1));
                eye_v = cat(1, eye_v, 0.25, 0.25, 0.25, 0.25);
           end
        else
            if odd(I)
                eye_j = cat(1, eye_j, n, n, n, n);
                eye_i = cat(1, eye_i, sub2ind(sz, i, j, k), sub2ind(sz, i, j+1, k), ...
                                      sub2ind(sz, i, j, k+1), sub2ind(sz, i, j+1, k+1));
                eye_v = cat(1, eye_v, 0.25, 0.25, 0.25, 0.25);
            else
                eye_j = cat(1, eye_j, n, n, n, n, n, n, n, n);
                eye_i = cat(1, eye_i, sub2ind(sz, i, j, k), sub2ind(sz, i+1, j, k), ...
                                      sub2ind(sz, i, j+1, k), sub2ind(sz, i+1, j+1, k), ...
                                      sub2ind(sz, i, j, k+1), sub2ind(sz, i+1, j, k+1), ...
                                      sub2ind(sz, i, j+1, k+1), sub2ind(sz, i+1, j+1, k+1));
                eye_v = cat(1, eye_v, repmat(0.25, [8 1]));
            end
        end
    end
    
end
eye_ = sparse(eye_i, eye_j, eye_v);
eye_ = eye_(1:N, 1:NS);
delI = eye_;
delI(2:end,:) = delI(2:end,:)-delI(1:end-1,:);
delJ = eye_;
delJ(R+1:end,:) = delJ(R+1:end,:)-delJ(1:end-R,:);
delK = eye_;
delK(RC+1:end,:) = delK(RC+1:end,:)-delK(1:end-RC,:);
A = [eye_; delI; delJ; delK];
eye_tik = speye(NS);
delI_tik = eye_tik;
delI_tik(2:end,:) = delI_tik(2:end,:)-delI_tik(1:end-1,:);
delJ_tik = eye_tik;
delJ_tik(RS+1:end,:) = delJ_tik(RS+1:end,:)-delJ_tik(1:end-RS,:);
delK_tik = eye_tik;
delK_tik(RCS+1:end,:) = delK_tik(RCS+1:end,:)-delK_tik(1:end-RCS,:);
tik = [delI_tik; delJ_tik; delK_tik] * lam;
A = [A; tik];

end