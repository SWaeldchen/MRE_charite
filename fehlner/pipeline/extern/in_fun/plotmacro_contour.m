function plotmacro_contour(Ux1,Uy1,Ux2,Uy2,ang,val1,val2)


for k=1:length(ang)

    [f1, f2]=pol2cart(ang(k)*pi/180,1);
    [f1_90, f2_90]=pol2cart((ang(k)+90)*pi/180,1);
    U1=fliplr(f1*Ux1 + f2*Uy1);
    U2=fliplr(f1*Ux2 + f2*Uy2);
    U1_90=fliplr(f1_90*Ux1 + f2_90*Uy1);
    U2_90=fliplr(f1_90*Ux2 + f2_90*Uy2);
    %U1=f1*Ux1 + f2*Uy1;
    %U2=f1*Ux2 + f2*Uy2;
    U1=U1+U1_90;
    U2=U2+U2_90;
    
figure('units','normalized','position',[0.0869    0.3555    0.7500    0.4609]);
x=-50:49;
y=-49:50;
% das ist für X- und Y-achsenprofil
%axes('units','normalized','position',[0.55    0.55    0.4    0.4]);
%plot(x,U(50,:));
%set(gca,'Xtick',[],'Yticklabel','','Xticklabel','','Ytick',0,'gridlinestyle','-','Xlim',[-50 49],'Ylim',val(1:2)); grid on
%xlabel('X')
%ylabel('amplitude')

%axes('units','normalized','position',[0.55    0.05    0.4    0.4]);
%title('y axis')
%plot(y,U(:,51));
%set(gca,'Xtick',[],'Yticklabel','','Xticklabel','',...
%    'Ytick',0,'gridlinestyle','-','Xlim',[-49 50],'Ylim',val(3:4)); grid on
%xlabel('Y')
%ylabel('amplitude')

axes('units','normalized','position',[0.05    0.05    0.4    0.9],'dataaspectratio',[1 1 1])
%contour(x,y,U,[-100 cont 100],'k');
imagesc(x,y,U1);
colormap gray
caxis(val1)
set(gca,'Xlim',[-49,49],'Ylim',[-49,49],'Xtick',0,'Ytick',0,...
    'dataaspectratio',[1 1 1],'gridlinestyle','-','Yticklabel','','Xticklabel','',...
    'Ydir','normal'); 
grid on

hold on

a=arrow('start',[0,0],'stop',49*[f1,f2],'width',5,'length',30,'base',45,'facecolor','red','edgecolor','red');
line([0 50],[0 50],'color','y','linestyle','--')

axes('units','normalized','position',[0.55    0.05    0.4    0.9],'dataaspectratio',[1 1 1])
%contour(x,y,U,[-100 cont 100],'k');
imagesc(x,y,U2);
colormap gray
caxis(val2)
set(gca,'Xlim',[-49,49],'Ylim',[-49,49],'Xtick',0,'Ytick',0,...
    'dataaspectratio',[1 1 1],'gridlinestyle','-','Yticklabel','','Xticklabel','',...
    'Ydir','normal'); 
grid on

hold on

a=arrow('start',[0,0],'stop',49*[f1,f2],'width',5,'length',30,'base',45,'facecolor','red','edgecolor','red');

%xlabel('Y')
%ylabel('X')

uicontrol(gcf,'style','text','units','normalized','position',[0.4  0.94  0.2 0.05],'String',['excition angle: ' num2str(round(10*ang(k))/10) '°'])

line([0 25],[0 50],'color','y','linestyle','--')
end