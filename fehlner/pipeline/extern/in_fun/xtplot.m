function [xt DX Dt]=xtplot(w,para)
% para.xp=128;para.dx=1.5625;para.tp=360;para.tau=[3.65 360*3.65];para.method='linear';para.direction='+';
   
if nargin < 1
im=flipdim(findobj(gcf,'type','image','visible','on'),1);
    
    for k=1:length(im)
        w(:,:,k)=get(im(k),'Cdata');
    end
    
else
    imagesc(w(:,:,round(size(w,3)/2)))
    colormap gray
    axis image
    set(gcf,'keypressfcn','keyfcn')
end
    
        si3=size(w,3);
       

if nargin < 2
   prompt={'x_points:','dx','t_points:','t1 t2','method','dir'};
   def={'128','2.5',num2str(si3),'[0.1084 1.935]','linear','+'};
   dlgTitle='xt-plot parameter';
   lineNo=1;
   answer=inputdlg(prompt,dlgTitle,lineNo,def);
 
   if isempty(answer)
   return    
   else
   
   xp=str2num(answer{1});
   dx=str2num(answer{2});
   tp=str2num(answer{3});
   tau=str2num(answer{4});
   meth=answer{5};
   dir=answer{6};

   end
   
else
    
    xp=para.xp;
    dx=para.dx;
    tp=para.tp;
    tau=para.tau;
    meth=para.method;
    dir=para.direction;
    
end

  
     T=linspace(1,si3,tp);    
        
%if nargin < 1

        pos=ginput(2);
        
        hold on
        h=plot(pos(:,1),pos(:,2));
    %    set(h,'buttondownfcn','xtplot(1)','userdata',pos)

% else
%     pos=get(gco,'userdata');
% end
    
        if dir=='-'
        pos=flipud(pos);
        
        end
        
        X=linspace(pos(1,1),pos(2,1),xp);
        Y=linspace(pos(1,2),pos(2,2),xp);
        xt=interp3(w,X(:)*ones(1,tp),Y(:)*ones(1,tp),ones(xp,1)*T,meth);
        figure;
   %     y_ax=sqrt(X.^2+Y.^2)*dx;
        L=sqrt((pos(1,1)-pos(2,1))^2+(pos(1,2)-pos(2,2))^2)*dx;
        DX=L/xp;
        y_ax=linspace(DX,L,xp);
        t_ax=linspace(tau(1),tau(2),tp);
        Dt=t_ax(2)-t_ax(1);
        h=imagesc(t_ax,y_ax,xt);
        colormap gray
       % set(h,'buttondownfcn','give_c')
        set(gcf,'keypressfcn','keyfcn')
        axis tight
        xlabel('t')
        ylabel('x')
        set(gca,'Ydir','normal')