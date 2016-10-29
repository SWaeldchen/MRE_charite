function [del_J_eb, del_J_tour] = grad_J_mix(y, epsilon, lambda)
    %EB
    gradx = conv2(y, [1 -1], 'same');
    grady = conv2(y, [1; -1], 'same');
    %TOUR
    grad = @(x)cat(3, x-x([end 1:end-1],:), x-x(:,[end 1:end-1]));
    figure(1);
    subplot(2, 2, 1); imshow(gradx, []);
    subplot(2, 2, 2); imshow(grady, []);
    g = grad(y);
    subplot(2, 2, 3); imshow(g(:,:,2), []);
    subplot(2, 2, 4); imshow(g(:,:,1), []);
    
    %EB
    norm_vals = smoothed_L1(gradx, grady, epsilon);
    %TOUR
    NormEps = @(u,epsilon)sqrt(epsilon^2 + sum(u.^2,3));
    normeps = NormEps(grad(y), epsilon);
    figure(2)
    subplot(1, 2, 1); imshow(norm_vals, []);
    subplot(1, 2, 2); imshow(normeps, []);

    %EB
    gradx_norm = gradx ./ norm_vals;
    grady_norm = grady ./ norm_vals;
    %TOUR
    Normalize = @(u,epsilon)u./repmat(NormEps(u,epsilon), [1 1 2]);
    normalize = Normalize(grad(y), epsilon);
    figure(3);
    subplot(2, 2, 1); imshow(gradx_norm, []);
    subplot(2, 2, 2); imshow(grady_norm, []);
    subplot(2, 2, 3); imshow(normalize(:,:,2), []);
    subplot(2, 2, 4); imshow(normalize(:,:,1), []);  
    
    %EB
    divx = conv2(gradx_norm, [1 -1], 'same');
    divy = conv2(grady_norm, [1; -1], 'same');
    del_J_eb = -(divx + divy);
    %TOUR
    div = @(v)v([2:end 1],:,1)-v(:,:,1) + v(:,[2:end 1],2)-v(:,:,2);
    GradJ = @(x,epsilon)-div( Normalize(grad(y),epsilon) );
    del_J_tour = GradJ(y, epsilon);
    figure(4)
    subplot(1, 2, 1); imshow(del_J_eb, []);
    subplot(1, 2, 2); imshow(del_J_tour, []);
    
    %EB
    gradf_eb = gradient_of_objective_function(y, y, lambda, epsilon);
    %TOUR
    Gradf = @(y,x,epsilon)x-y+lambda*GradJ(x,epsilon);
    gradf_tour = Gradf(y, y, epsilon);
    figure(4)
    subplot(1, 2, 1); imshow(gradf_eb, []);
    subplot(1, 2, 2); imshow(gradf_tour, []);
end
