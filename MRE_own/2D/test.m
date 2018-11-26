
n = 3;

ons = ones(n^2,1);

%diffVec = zeros(n^2,1);

%diffVec(

x = rand(n,n);

mu = rand(n,n);

% muDiff = (x(:,3:end) - x(:,1:end-2))/2
% 
% muPad1 = [-muDiff,zeros(n,1),zeros(n,1)]
% muPad2 = [zeros(n,2),muDiff]
% 
% v1 = [-ones(n^2-2*n,1); zeros(2*n,1)]/2;
% v2 = [ones(n,1);zeros(n^2-2*n,1);ones(n,1)];
% v3 = [zeros(2*n,1); ones(n^2-2*n,1)]/2;
% 
% gradMatrix = spdiags([v1,v2,v3],[-n,0, +n], n^2,n^2);
% 
% 
% w1 = repmat([-ones(n-2,1);0;0],n,1)/2
% w2 = repmat([1;zeros(n-2,1);1],n,1)
% w3 = repmat([0;0;ones(n-2,1)],n,1)/2
% 
% 
% 
% gradMatrix = spdiags([vect(muPad1),w2,vect(muPad2)],[-1,0,1], n^2, n^2)
% 
% 
% full(gradMatrix)
% 
% 
muDiff = (x(3:end,:) - x(1:end-2,:))/2

v2 = [ones(n,1);zeros(n^2-2*n,1);ones(n,1)];
muPad1 = [-muDiff;zeros(2,n)];
muPad2 = [zeros(2,n);muDiff];

gradMatrix = spdiags([vect(muPad1),v2,vect(muPad2)],[-n,0, +n], n^2,n^2);
 full(gradMatrix)
return

xRGrad = zeros(n,n);

xR = x';

xRGrad(:) = gradMatrix*xR(:);

x
xGrad = xRGrad'

(x(:,3:end) - x(:,1:end-2))/2

%
% 
