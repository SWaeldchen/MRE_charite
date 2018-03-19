function n = normalize_tour(u, epsilon)

NormEps = @(u,epsilon)sqrt(epsilon^2 + sum(u.^2,3));
Normalize = @(u,epsilon)u./repmat(NormEps(u,epsilon), [1 1 2]);
n = Normalize(u, epsilon);