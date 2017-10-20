% Framewise Displacement = sqrt( dx^2 + dy^2 + dz^2 + (Alpha/360*2*pi*R)^2 + (Beta...)^2 + (Gamma...)^2)
% with Cranial Capacity = 1550 cm3 () --> Sphere R = 57mm --> 1deg corresponds to 1mm on brain sphere (instead of R=50mm in Power_2012)
% --> FD = sqrt(dx^2+dy^2+dz^2+dAlpha^2+dBeta^2+dGamma^2)
clear all

load('comball_rp_7T.mat');

for s=1:14
    
tx(s,:)  = squeeze(comball.rp(s,:,1));
ty(s,:)  = squeeze(comball.rp(s,:,2));
tz(s,:)  = squeeze(comball.rp(s,:,3));
rx(s,:)  = squeeze(comball.rp(s,:,4))*360/(2*pi) *50*pi/360; % R=50mm [Power_2012]
ry(s,:)  = squeeze(comball.rp(s,:,5))*360/(2*pi) *50*pi/360;
rz(s,:)  = squeeze(comball.rp(s,:,6))*360/(2*pi) *50*pi/360;

dtx(s,:) = diff(tx(s,:));
dty(s,:) = diff(ty(s,:));
dtz(s,:) = diff(tz(s,:));
drx(s,:) = diff(rx(s,:));
dry(s,:) = diff(ry(s,:));
drz(s,:) = diff(rz(s,:));

FD(s,:)  = abs(dtx(s,:)) + abs(dty(s,:)) + abs(dtz(s,:)) + abs(drx(s,:)) + abs(dry(s,:)) + abs(drz(s,:));

sFD(s)   = sum(FD(s,:),2);
mFD(s)   = mean(FD(s,:),2);
eFD(s)   = std(FD(s,:),[],2);

hold on
plot3(tx(s,:),ty(s,:),tz(s,:),'.-')

end

% figure; errorbar(mFD, eFD,'.'), ylabel('mean(FD) [mm]'), xlabel('Subject #')
% mean(mFD), std(mFD)
% % figure; errorbar(sFD, eFD,'.'), ylabel('sum(FD) [mm]'), xlabel('Subject #')
% 
% figure;
% subplot(711)
% errorbar(mean(dtx,1), std(dtx,[],1) ,'k-'), ylabel('dtx [mm]')
% subplot(712)
% errorbar(mean(dty,1), std(dty,[],1) ,'r-'), ylabel('dty [mm]')
% subplot(713)
% errorbar(mean(dtz,1), std(dtz,[],1) ,'b-'), ylabel('dtz [mm]')
% subplot(714)
% errorbar(mean(drx,1), std(drx,[],1) ,'k-.'), ylabel('drx [mm]')
% subplot(715)
% errorbar(mean(dry,1), std(dry,[],1) ,'r-.'), ylabel('dry [mm]')
% subplot(716)
% errorbar(mean(drz,1), std(drz,[],1) ,'b-.'), ylabel('drz [mm]')
% subplot(717)
% errorbar(mean(FD,1), std(FD,[],1)) , ylabel('FD [mm]')

% for s=1:14
% figure;
% subplot(211);hold on
% plot(tx(s,:),'k-')
% plot(ty(s,:),'r-')
% plot(tz(s,:),'b-')
% plot(rx(s,:),'k-.')
% plot(ry(s,:),'r-.')
% plot(rz(s,:),'b-.')
% subplot(212)
% plot(FD(s,:))
% pause(0.5)
% end