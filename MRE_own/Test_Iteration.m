clear;

rho     = 1;
omega1   = 160;
omega2   = 300;

resol = 20;

gridSize = resol*max(omega1, omega2)
deltaX = 1/gridSize;
xVec = (1:gridSize)'/gridSize;

D1 = deltaX^2*rho*omega1^2;
D2 = deltaX^2*rho*omega2^2;

muVec = mu_func(xVec)';
 
u1 = invert_for_u(muVec, D1, 1, 1, gridSize);
u2 = invert_for_u(muVec, D2, 1, 1, gridSize);

snr = 10;

u1Noise = u1 + max(u1)*randn(size(u1))/snr;
u2Noise = u2 + max(u2)*randn(size(u2))/snr;

level = ceil(log2(gridSize))

u1Denoised = wlet_denoise(u1Noise, level, 'db10', 0.95, 0, 5);
u2Denoised = wlet_denoise(u2Noise, level, 'db10', 0.95, 0, 5);

bestDist = 100000000;

maxLevel = level; %fix(log2(gridSize))

% plot(xVec, u1, 'g', xVec, u1Noise+4, 'r', xVec, u1Denoised, 'b');
% return

muRec = invert_for_mu(D1, D2, u1Denoised, u2Denoised, gridSize);
%muRec = iterate_mu(u1Denoised, u2Denoised, D1, D2, gridSize, muStart);

plot(xVec, muVec, 'b', xVec, muRec, 'g');
return

plot(xVec(2:end-1), diff(diff(u1))/deltaX, xVec, muVec)

% for stop = 5
%     for bottom = 0.9:0.01:0.99
%         
%         u1Denoised = wlet_denoise(u1Noise, level, 'db10', bottom, 0, stop);
%         u2Denoised = wlet_denoise(u2Noise, level, 'db10', bottom, 0, stop);
%         recMu = invert_for_mu(D1, D2, u1Denoised, u2Denoised, gridSize);
%         
%         %curDist = rel_dist(diff(u1Denoised), diff(u1));
%         stop
%         bottom
%         curDist = sum(abs(muVec - recMu))
%         
%         if curDist <= bestDist
%             bestDist = curDist;
%             bestValues = [stop, bottom];
%             bestU1 = u1Denoised;
%             bestMu = recMu;
%         end
%     end
% end
% % 
bestDist
bestValues
plot(xVec, muVec, 'b', xVec, bestMu, 'g');
% 
% plot(xVec, u1, 'g', xVec, u1Noise+4, 'r', xVec, bestU1, 'b');
return

% plot(xVec, u1, 'g', xVec, u1Noise+4, 'r', xVec, bestU1, 'b', xVec(1:end-1), diff(u1)/deltaX-3, 'g',...
% xVec(1:end-1), diff(bestU1)/deltaX-3, 'b', xVec(2:end-1), diff(diff(u1))-6, 'g', xVec(2:end-1), diff(diff(bestU1))-6, 'b');

recMu = invert_for_mu(D1, D2, u1Denoised, u2Denoised, gridSize);
%numOfMuSteps = 100000;

plot(xVec, muVec, 'b', xVec, recMu, 'g');
return
% muIter = recMu;
% beta = 0.00001;
% gamma = 10;

% for muStep = 1:numOfMuSteps
% 
%     muSign = sign(muIter(1:end-1) - muIter(2:end));
% 
%     muTV = zeros(size(muIter));
%     muTV(2:end) = muTV(2:end) - muSign;
%     muTV(1:end-1) = muTV(1:end-1) + muSign;
% 
%     muIter = muIter - beta*((muIter - recMu) + gamma*muTV);
% 
% end

recMu = wlet_denoise(recMu, 11, 'db1', 1, 8);

diffOp1 = waveOp_u(recMu, D1, gridSize);
diffOp2 = waveOp_u(recMu, D2, gridSize);
%diffOp1 = diffOp1(1:end,:);

boundVec = [u1Denoised(1); zeros(gridSize-2,1); u1Denoised(end)];

tune = 0.1;
u1Iter = wlet_denoise(u1Noise, 10, 'db10', 0.01, 10);
u2Iter = wlet_denoise(u2Noise, 10, 'db10', 0.01, 10);
alpha = 0.01;
numofUSteps = 10000;

for uStep=1:numofUSteps
    u1Iter = u1Iter - alpha*((diffOp1'*diffOp1)*u1Iter - diffOp1'*boundVec);
    u2Iter = u2Iter - alpha*((diffOp2'*diffOp2)*u2Iter - diffOp2'*boundVec);
    %u1Iter = u1Iter - alpha*(u1Iter - u1);
end

recMu2 = invert_for_mu(D1, D2, u1Iter, u2Iter, gridSize);
herecMu2 = wlet_denoise(recMu2, 11, 'db1', 1, 8);

%plot(xVec, muVec, 'b', xVec, recMu2, 'r', xVec, recMu, 'g');

LapU1 = diff(diff(u1Iter))/deltaX;


