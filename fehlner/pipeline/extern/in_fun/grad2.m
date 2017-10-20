function [GXX, GXY, GYX, GYY]=grad2(SIG)
% discrete second order gradient
% [GXX, GXY, GYX, GYY]=grad2(SIG)
%
%

GXX=zeros(size(SIG));
GXY=zeros(size(SIG));
GYX=zeros(size(SIG));
GYY=zeros(size(SIG));


GXX(:,1:end-1)=SIG(:,1:end-1)-SIG(:,2:end);
GXX(:,2:end)=GXX(:,2:end)+SIG(:,2:end)-SIG(:,1:end-1);

GXY(2:end,1:end-1)=SIG(2:end,1:end-1) - SIG(1:end-1,2:end);
GXY(1:end-1,2:end)=GXY(1:end-1,2:end) + SIG(1:end-1,2:end)-SIG(2:end,1:end-1);

GYX(2:end,2:end)=SIG(2:end,2:end) - SIG(1:end-1,1:end-1);
GYX(1:end-1,1:end-1)=GYX(1:end-1,1:end-1) + SIG(1:end-1,1:end-1)-SIG(2:end,2:end);

GYY(1:end-1,:)=SIG(1:end-1,:)-SIG(2:end,:);
GYY(2:end,:)=GYY(2:end,:)+SIG(2:end,:)-SIG(1:end-1,:);
