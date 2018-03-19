function A = assemble_sfwi_super_matrix(sz)

I = sz(1);
J = sz(2);
IJ = I * J;
N = prod(sz);

A = sparse(N*4, N);

indices = [];
values = [];
%assemble each column
% odd -> known
for n = 1:N
    if mod(n,1000) == 0
        waitbar(n/N)
    end
    [I, J, K] = ind2sub(sz, n);
    new_col_head = zeros(N,1);
    if odd(K)
        if odd(J)
            if odd(I)
                new_col_head(n) = 1;
            else
                new_col_head(n-1) = 0.5;
                new_col_head(n+1) = 0.5;
            end
        else
            if odd(I)
                new_col_head(n-I) = 0.5;
                new_col_head(n+I) = 0.5;
            else
                new_col_head(n-I-1) = 0.25;
                new_col_head(n-I+1) = 0.25;
                new_col_head(n+I-1) = 0.25;
                new_col_head(n+I+1) = 0.25;
            end
        end
    else
        if odd(J)
            if odd(I)
                new_col_head(n-IJ) = 0.5;
                new_col_head(n+IJ) = 0.5;
            else
                new_col_head(n-IJ-1) = 0.25;
                new_col_head(n-IJ+1) = 0.25;
                new_col_head(n+IJ-1) = 0.25;
                new_col_head(n+IJ+1) = 0.25;
            end
        else
            if odd(I)
                new_col_head(n-IJ-I) = 0.25;
                new_col_head(n-IJ+I) = 0.25;
                new_col_head(n+IJ-I) = 0.25;
                new_col_head(n+IJ+I) = 0.25;
            else
                new_col_head(n-IJ-I-1) = 0.125;
                new_col_head(n-IJ-I+1) = 0.125;
                new_col_head(n-IJ+I-1) = 0.125;
                new_col_head(n-IJ+I+1) = 0.125;
                new_col_head(n+IJ-I-1) = 0.125;
                new_col_head(n+IJ-I+1) = 0.125;
                new_col_head(n+IJ+I-1) = 0.125;
                new_col_head(n+IJ+I+1) = 0.125;
            end
        end
    end
    new_col_del_I = new_col_head;
    new_col_del_I(2:end) = -new_col_head(1:end-1);
    new_col_del_J = new_col_head;
    new_col_del_J(I+1:end) = -new_col_head(1:end-I);
    new_col_del_K = new_col_head;
    new_col_del_K(IJ+1:end) = -new_col_head(1:end-IJ);
    new_col = sparse([new_col_head; new_col_del_I; new_col_del_J; new_col_del_K]);
    indices = cat(1, indices, find(new_col ~= 0));
    values = cat(1, values, new_col(indices));
end

A = sparse(indices, values);
end