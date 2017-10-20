function [wa2 cor]=register_rotateimage(wa,wb,ang,ax,BW)

if nargin < 5
    BW=ones(size(wa));
end


cor=zeros(1,length(ang));

for k=1:length(ang)
    
wa2=rotateimage(wa,ang(k),ax);
cor(k)=mean(mean(abs(wa2(BW(:))-wb(BW(:)))));

end


[m x]=min(cor);
disp(['angle: ' num2str(ang(x)) '°'] )
wa2=rotateimage(wa,ang(x),ax);

%plot2dwaves(cat(3,wa2,wb))