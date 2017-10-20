function keyfcn(key)
%
% 'a' apply contrast, brightness and cutted size of the current image to all images in the figure
% 'A' change color axis of current axis
% 'b' brighten in
% 'B' brighten out
% 'c' contrast in
% 'C' contrast out
% 'd' display contour of any ROI
% 'e' enlarge current image into separate figure
% 'f' fft smooth
% 'F' create animated gif from all axes and save it as 'tmp.gif' 
% 'g' smooth by Gauss convolution
% 'G' smooth by Gauss convolution all images
% 'i' invert current image
% 'j' save current image as jpg
% 'J' save all axes in separate directory as jpg's
% 'l' LFE for current image
% 'L' LFE for all images
% 'm' save current image as mat-file
% 'M' save all images as 3D matlab matrix (equal sizes required)
% 'n' smooth by median filter 
% 'N' smooth by normalized convolution (Gauss-filter) for all images 
% 'O' plot profile over series of mean of selected ROI
% 'p' plot profile of selected line
% 'P' plot profile over series at current point
% 'r' reset contrast and brightness
% 'R' 3D ROI is saved wit extension '_3Droi.mat'
% 's' cut out region of interest
% 'S' cut out region of interest of all images
% 't' xt-plot (profile over series)
% 'T' transform images to surface plots
% 'u' unwrap
% 'V' make avi movie of out of all axes
% 'w' which image of each axis (serie) is displayed
% 'W' put 3D images into global variabel tmp_w
% 'x' chop current image 
% 'X' chop all images (equal sizes required)
% 'z' zoom (right mouse button) | zoom off (left mouse buttonS)
% 'Z' apply zoom of current axes to all axes
% '+' average over all images into separate figure
%
%
% '1..9' show 1st .. 6th layer if exists 
% 'Del' delete current image
%
% '?' this help


if nargin < 1
key=get(gcf,'CurrentCharacter');
end

ca=caxis;
fac=(max(max(caxis))-min(min(caxis)))/10;

if strcmp(key,'1') |  strcmp(key,'2') | strcmp(key,'3') | strcmp(key,'4') | strcmp(key,'5') | strcmp(key,'6') | strcmp(key,'7') | strcmp(key,'8') | strcmp(key,'9')
    knum=str2num(key);
    key='num';
end



switch key

case 'z'

    a=getrect(gca);
    butt=get(gcf,'selectiontype');
    switch butt
    case 'normal'
    x1=a(1); x2=a(1)+a(3); y1=a(2); y2=a(2)+a(4);
    if (x1 < x2) & (y1 < y2) 
    set(gca,'Xlim',[x1 x2],'Ylim',[y1 y2]);
    else
    axis image
    end
    case 'alt'
    axis image
    end
    
case 'Z'
    
    X=get(gca,'Xlim');
    Y=get(gca,'Ylim');
    
        kids=get(gcf,'children');
        ax=findobj(kids,'type','axes');
        for k=1:length(ax)
        set(ax(k),'Xlim',X,'Ylim',Y);
        end
   
case 'c'
caxis(ca*0.9);

case 'C'
caxis(ca*1.1);
    
case 'b'
caxis(ca-fac);

case 'B'
caxis(ca+fac);
   
case 'r'
    
im=get(gca,'children');
im=findobj(im,'type','image','visible','on');
Cdat=get(im,'CData');
mi=min(min(Cdat));
ma=max(max(Cdat));

caxis([mi, ma]);


    case 'a'
   
   clim=get(gca,'clim');
   kids=get(gcf,'children');
   ax=findobj(kids,'type','axes');
   set(ax,'clim',[clim]);
    
case 'A'

prompt={'color axis'};
                       def={num2str(caxis)};
                       dlgTitle=['new color axis'];
                       lineNo=1;
                       ans=inputdlg(prompt,dlgTitle,lineNo,def);
                            
                       if isempty(ans)
                           return
                       end
                       
                        ca=str2num(ans{1});          
                        caxis(ca)
    case 'i'
    
    im=findobj(gca,'type','image','visible','on');
    y=get(im,'Cdata');
    set(im,'Cdata',y*-1);
    
case 'p'
   
   fig=gcf;
   showprofile;
   set(fig,'pointer','arrow');
   
case 'j'
    
    ax2jpg

case 'e'
    
    all_ax=findobj(gcf,'type','axes');
    all_ax=flipud(all_ax);
    ax=gca;
    ud.all_ax=all_ax;
    ud.num=find(all_ax == gca);

    
    c=colormap;
    
    fig=figure('userdata',ud);
    ax2=copyobj(ax,fig);
    set(ax2,'position','default');
    colormap(c)
    set(fig,'keypressfcn','scroll')
    

case 'F'
     
    all_ax=findobj(gcf,'type','axes');
    all_ax=flipud(all_ax);
    
    
    c=colormap;
    
    for k=1:length(all_ax)
    fig=figure('name','tmp');
    ax2=copyobj(all_ax(k),fig);
    set(ax2,'position','default');
   text(0,0,num2str(k),'color','w')
    colormap(c)
    
    f=getframe(ax2);
    cmp=colormap;
    im(:,:,:,k)= rgb2ind(f.cdata,cmp,'nodither');
    close(fig)
    end
time_delay=0.1;
imwrite(im,c,'tmp.gif','DelayTime',time_delay,'LoopCount',inf)
        

case 'x'
    
    im=get(gca,'children');
    im=findobj(im,'type','image','visible','on');
    Cdat=get(im,'CData');

    [x,y]=ginput(2);
    x=round(sort(x));
    y=round(sort(y));
    
    si=[y(2)-y(1)+1 x(2)-x(1)+1];

    if strcmp(get(gcf,'Selectiontype'),'normal')
    
                       prompt={'upper corner (row):','upper corner (column):','number of rows:','number of columns:'};
                       def={num2str(y(1)),num2str(x(1)),num2str(si(1)),num2str(si(2))};
                       dlgTitle=['confirm new image size (old: ' num2str(size(Cdat)) ')'];
                       lineNo=1;
                       ans=inputdlg(prompt,dlgTitle,lineNo,def);
                            
                       if isempty(ans)
                           return
                       end
                       
                        y(1)=str2num(ans{1});
                        x(1)=str2num(ans{2});
                        si2(1)=str2num(ans{3});
                        si2(2)=str2num(ans{4});
      
    y(2)=y(1)+si2(1)-1;
    x(2)=x(1)+si2(2)-1;
    
    if y(2) > size(Cdat,1) y(2) = size(Cdat,1); end
    if x(2) > size(Cdat,2) x(2) = size(Cdat,2); end

   
    Cdat=Cdat(y(1):y(2),x(1):x(2));
    
    set(im,'Cdata',Cdat);
    axis tight
    
    end

case 'X'
 
    im=get(gca,'children');
    im=findobj(im,'type','image','visible','on');
    Cdat=get(im,'CData');

    [x,y]=ginput(2);
    x=round(sort(x));
    y=round(sort(y));
    
    si=[y(2)-y(1)+1 x(2)-x(1)+1];
  
                       prompt={'upper corner (row):','upper corner (column):','number of rows:','number of columns:'};
                       def={num2str(y(1)),num2str(x(1)),num2str(si(1)),num2str(si(2))};
                       dlgTitle=['confirm new image size (old: ' num2str(size(Cdat)) ')'];
                       lineNo=1;
                       ans=inputdlg(prompt,dlgTitle,lineNo,def);
                            
                       if isempty(ans)
                           return
                       end
                       
                        y(1)=str2num(ans{1});
                        x(1)=str2num(ans{2});
                        si2(1)=str2num(ans{3});
                        si2(2)=str2num(ans{4});
                        
    y(2)=y(1)+si2(1)-1;
    x(2)=x(1)+si2(2)-1;
    
    if y(2) > size(Cdat,1) y(2) = size(Cdat,1); end
    if x(2) > size(Cdat,2) x(2) = size(Cdat,2); end
    
    
    if strcmp(get(gcf,'Selectiontype'),'normal')
 
        kids=get(gcf,'children');
        ax=findobj(kids,'type','axes');
   
        if length(ax) > 1
        im=get(ax,'children');
        im=cat(1,im{:});
        im=findobj(im,'type','image','visible','on');
        Cdat=get(im,'CData');
        Cdat=cat(2,Cdat{:});
        Cdat=reshape(Cdat,size(Cdat,1),size(Cdat,2)/size(im,1),size(im,1));
        Cdat=Cdat(y(1):y(2),x(1):x(2),:);
        gca_old=gca;
   
        for k=1:size(im,1)
       
       set(gcf,'currentaxes',ax(k));
       set(im(k),'Cdata',Cdat(:,:,k));
       axis tight;
       
       end
   
        set(gcf,'currentaxes',gca_old);
        else % multi axes
            
            if strcmp(questdlg('cut images from the other figures'),'Yes')
            kids=get(0,'children');
            ax=get(kids,'children');
            ax=cat(1,ax{:});
            im=get(ax,'children');
            im=cat(1,im{:});
            im=findobj(im,'type','image','visible','on');
            Cdat=get(im,'CData');
            Cdat=cat(2,Cdat{:});
            Cdat=reshape(Cdat,size(Cdat,1),size(Cdat,2)/size(im,1),size(im,1));
            Cdat=Cdat(y(1):y(2),x(1):x(2),:);
            
            for k=1:size(Cdat,3)
                plot2dwaves(Cdat(:,:,k))
            end
            end % quesdlg
        end % multi axes
    end
    
case 'm'
        im=get(gca,'children');
        im=findobj(im,'type','image','visible','on');
        w=get(im,'Cdata');
        here=pwd;
        [n p]=uiputfile('*.mat','3D save matlab matrix');
        cd(here);
        
        if n == 0
            return 
        end
        
        save([p n],'w');
        
        
case 'M' 
    
        kids=get(gcf,'children');
        ax=findobj(kids,'type','axes');
        
        if length(ax) > 1
        im=get(ax,'children');
        im=cat(1,im{:});
        im=findobj(im,'type','image','visible','on');
        w=get(im,'CData');
        w=cat(2,w{:});
        w=reshape(w,size(w,1),size(w,2)/size(im,1),size(im,1));
        else % multi axes
            
            if strcmp(questdlg('save images from the other figures'),'Yes')
            kids=get(0,'children');
            ax=get(kids,'children');
            ax=cat(1,ax{:});
            im=get(ax,'children');
            im=cat(1,im{:});
            im=findobj(im,'type','image','visible','on');
            Cdat=get(im,'CData');
            Cdat=cat(2,Cdat{:});
            w=reshape(Cdat,size(Cdat,1),size(Cdat,2)/size(im,1),size(im,1));
            else 
            return
            end
        end %multi axes
        here=pwd;
        [n p]=uiputfile('*.mat','3D save matlab matrix');
        cd(here);
        
        if n == 0
            return 
        end
        
        w=flipdim(w,3);
        save([p n],'w');
        
case 'f'
    
    fftsmooth;
    
case 'n'
    
    %normconv;
    im=findobj(gca,'type','image');
    
    if isempty(im)
        return
    end
    
                       prompt={'filter width'};
                       def={'5  5'};
                       dlgTitle=['median filter'];
                       lineNo=1;
                       ans=inputdlg(prompt,dlgTitle,lineNo,def);
                            
                       if isempty(ans)
                           return
                       end
                       
                        para=str2num(ans{1});
                        
    im=im(im == gco);
    Cd1=get(im,'Cdata');
    Cd2=medfilt2(Cd1,para);
    
    set(im,'visible','off');
    him=findobj(gca,'Tag','smoothmedfilt2');
    if isempty(him)
    hold on
    h=image(Cd2,'Cdatamapping','scaled','Tag','smoothmedfilt2');
    hold off
    else
    set(him(1),'Cdata',Cd2,'visible','on');
    end

    
    
case 'N'
        axcurr=gca;    
        ax=findobj(gcf,'type','axes');
       
                       prompt={'filter width'};
                       def={'5  5'};
                       dlgTitle=['median filter'];
                       lineNo=1;
                       ans=inputdlg(prompt,dlgTitle,lineNo,def);
                            
                       if isempty(ans)
                           return
                       end
                       
                        para=str2num(ans{1});

        for k=1:length(ax)
        
        im=findobj(ax(k),'type','image','visible','on');
        set(gcf,'currentaxes',ax(k));
    if isempty(im)
        return
    end
    
                        
    Cd1=get(im,'Cdata');
    Cd2=medfilt2(Cd1,para);
    
    set(im,'visible','off');
    him=findobj(ax(k),'Tag','smoothmedfilt2');
    if isempty(him)
    hold on
    h=image(Cd2,'Cdatamapping','scaled','Tag','smoothmedfilt2');
    hold off
    else
    set(him(1),'Cdata',Cd2,'visible','on');
    end
    drawnow
end % for ax   
       set(gcf,'currentaxes',axcurr);
 
case 'g'
    
    ws=smoothgaussconv;
    if isempty(ws)
        return
    end
    
    
    im=findobj(gca,'type','image');
    set(im,'visible','off');
    him=findobj(gca,'Tag','smoothgauss');
    if isempty(him)
    hold on
    h=image(ws,'Cdatamapping','scaled','Tag','smoothgauss');
    hold off
    else
    set(him(1),'Cdata',ws,'visible','on');
    end

case 'G'
    
    imf=findobj(gcf,'type','image','visible','on');
    
       axcur_old=gca;

   prompt={'Enter ratio of filter width:'};
   def={'0.01'};
   dlgTitle='Input for Gauss smoothing';
   lineNo=1;
   answer=inputdlg(prompt,dlgTitle,lineNo,def);
   
   
   if isempty(answer)
       return
   end

   fw=str2num(answer{1})/2;

    for k=1:length(imf)
    
    w = get(imf(k),'Cdata');
    ws=smoothgaussconv(w,fw);
    if isempty(ws)
        return
    end
    
    axcur=get(imf(k),'parent');
    set(gcf,'currentaxes',axcur);
    im=findobj(axcur,'type','image');
    set(im,'visible','off');
    him=findobj(axcur,'Tag','smoothgauss');
    if isempty(him)
    hold on
    h=image(ws,'Cdatamapping','scaled','Tag','smoothgauss','buttondownfcn','buttonfcn');
    hold off
    else
    set(him(1),'Cdata',ws,'visible','on');
    end
    
    drawnow
    end % imf
    
    set(gcf,'currentaxes',axcur_old);

    
case 's'
    
    segment;

case 'S'
    
    x=segment;
    
        kids=get(gcf,'children');
        ax=findobj(kids,'type','axes');
   
        if length(ax) > 1
            for k=1:length(ax)
                im=get(ax(k),'children');
                im=findobj(im,'type','image','visible','on');
                CD=get(im,'CData');
                CD(x)=0;
                set(im,'Cdata',CD);
            end
        end
        
case 'R'


here=pwd;
[n p]=uigetfile('*_3Droi.mat','load 3D roi-file');
cd(here);

ax=findobj(gcf,'type','axes');
ax=flipud(ax);

if n
    load([p n]);
else
im=get(findobj(gca,'type','image'),'Cdata');
BW=zeros(size(im,1),size(im,2),length(ax));
end

ind=find(ax == gca);
BW2=roipoly;
BW(:,:,ind)=BW2;

if n
    save([p n],'BW')
else
    [n p]=uiputfile('*_3Droi.mat','save 3D roi-file');
if n
    save([p n],'BW')
else
    return
end

end

delete(findobj(ax,'type','hggroup','color','g'))
contour_bw(BW,'g')

case '?'
    
    help keyfcn
    
case 'num' 
                    im=get(gca,'children');
                    im=findobj(im,'type','image');
                    im=flipdim(im,1);
                    set(im,'visible','off');
                    if length(im) >= knum
                    set(im(knum),'visible','on');
                    else
                    set(im(1),'visible','on');
                    end
                    caxis('auto')

case 'w'
           str{1}='1';str{2}='2';str{3}='3';str{4}='4';str{5}='5';str{6}='6';str{7}='7';str{8}='8';str{9}='9';
           kids=get(gcf,'children');
           ax=findobj(kids,'type','axes');

           num=menu('series number',str);
           for k=1:length(ax)
                    im=get(ax(k),'children');
                    im=findobj(im,'type','image');
                    im=flipdim(im,1);
                    set(im,'visible','off');
                    
                    if length(im) >= num
                    set(im(num),'visible','on');
                    end
                    set(gcf,'currentaxes',ax(k));
                    caxis('auto');
                end
                
   
case ''
    
    YN=questdlg('delete current axes?');
    
    if strcmp(YN,'Yes')
    delcurim;
    end

case 'l'
    
    im=findobj(gca,'type','image','visible','on');
    w=get(im,'Cdata');
    para=[]; 
    
    a=menu('which method?','Knutsson LFE','Gauss LFE');
    switch a
    case 1
        
        [SIG, para]=lfe_knutsson_2(w,para);
       
    if isempty(SIG)
        return
    end
    
    
    im=findobj(gca,'type','image');
    set(im,'visible','off');
    h=findobj(gca,'Tag','lfe_knutsson');
    if isempty(h)
    hold on
    h=image(SIG,'Cdatamapping','scaled','Tag','lfe_knutsson','buttondownfcn','buttonfcn');
    hold off
    else
    set(h(1),'Cdata',SIG,'visible','on');
    end
    
    UD=get(gca,'userdata');
    UD.lfe_g=[];
    UD.lfe_k=para;
    set(gca,'userdata',UD);
    
    case 2
        
              [SIG, para]=lfe_gauss(w,para);
       
    if isempty(SIG)
        return
    end
    
    
    im=findobj(gca,'type','image');
    set(im,'visible','off');
    h=findobj(gca,'Tag','lfe_gauss');
    if isempty(h)
    hold on
    h=image(SIG,'Cdatamapping','scaled','Tag','lfe_gauss','buttondownfcn','buttonfcn');
    hold off
    else
    set(h(1),'Cdata',SIG,'visible','on');
    end
    
    UD=get(gca,'userdata');
    UD.lfe_k=[];
    UD.lfe_g=para;
    set(gca,'userdata',UD);
 
    end % switch method
    
case 'L'

    UD=get(gca,'userdata');
    
    knut=0;
    para=[];
    if isfield(UD,'lfe_k')    
        if ~isempty(UD.lfe_k) 
            knut=1;    
        end
            
    end

    ax=findobj(gcf,'type','axes');
    
    for k=1:length(ax)
        
      im=findobj(ax(k),'type','image','visible','on');
      
      if knut
      [SIG, para]=lfe_knutsson(get(im,'Cdata'),para);
      tag='lfe_knutsson';
      else
      [SIG, para]=lfe_gauss(get(im,'Cdata'),para);
      tag='lfe_gauss';
      end
      
      im=findobj(ax(k),'type','image');
      set(im,'visible','off');
    
      
    h=findobj(ax(k),'Tag',tag);
    if isempty(h)
    set(gcf,'currentaxes',ax(k));
    hold on
    h=image(SIG,'Cdatamapping','scaled','Tag',tag,'buttondownfcn','buttonfcn');
    hold off
    else
    set(h(1),'Cdata',SIG,'visible','on');
    end
    
    drawnow;
    UD=get(ax(k),'userdata');
    
    if knut
    UD.lfe_k=para;
    UD.lfe_g=[];
    else
    UD.lfe_k=[];
    UD.lfe_g=para;
    end
    
    set(ax(k),'userdata',UD);
    
    end
case '+'
    
    im=findobj(gcf,'type','image','visible','on');
    Cdat=get(im,'Cdata');
    Cdat=cat(3,Cdat{:});
    
    plot2dwaves(sum(Cdat,3)/size(Cdat,3));
    set(gcf,'name','average over all images');

case 'O'

    oldax=gca;
    cmp=colormap;
    newfig=figure('name','select ROI for profile plot');    
    copyobj(oldax,newfig)
    set(gca,'position','default')
    colormap(cmp)
    
    BW=roipoly;
    save('tmpBW_roi.mat','BW');

    close(newfig)
    im=flipdim(findobj(gcf,'type','image','visible','on'),1);
    for k=1:length(im)
        cdat=get(im(k),'Cdata');
        prof(k)=mean(cdat(BW(:)));
    end
    
       if length(prof) > 1
        
        if  isempty(findobj(0,'tag','P'))
            figure('name',['profile tmpBW_roi'], 'numbertitle','off','tag','P');
            plot(prof)
        else
            set(0,'currentfigure',findobj(0,'tag','P'));
            hold on
            plot(prof)
            shg
        end
       end
    
case 'P'
    
    XY=round(get(gca,'currentpoint'));
    im=flipdim(findobj(gcf,'type','image','visible','on'),1);
    
    for k=1:length(im)
        cdat=get(im(k),'Cdata');
        prof(k)=cdat(XY(3),XY(1));
    end
    
    if length(prof) > 1
        
        if  isempty(findobj(0,'tag','P'))
            figure('name',['profile at ' num2str(XY(3)) '  ' num2str(XY(1))], 'numbertitle','off','tag','P');
        else
            set(0,'currentfigure',findobj(0,'tag','P'));
            shg
        end
         
         %a=plot(abs((fft(prof))));axis tight;Xlim=get(gca,'Xlim');set(gca,'Xlim',[1 Xlim(2)/2]);
        
         a=plot(prof);axis tight
        %set(a,'Buttondownfcn','tmp=get(gco,''Ydata''); global tmp_w; if size(tmp_w,2) == size(tmp,2) tmp_w=[tmp_w; tmp]; else tmp_w=tmp; end; disp(''new data on tmp_w'');')
        set(a,'Buttondownfcn','y=get(gco,''Ydata'');y=unwrap2(y);set(gco,''Ydata'',y);axis tight');
        hold on
        shg
    end
    
    %disp('profile: ');
    %disp(prof);
    case 't'
        
  xtplot;
case 'J'        

      ax=flipdim(findobj(gcf,'type','axes'),1);
    im=flipdim(findobj(gcf,'type','image','visible','on'),1);
    
  
     cmp=colormap;
    fig=figure('name','tmp','numbertitle','off');
    colormap(cmp)
    
     for k=1:length(ax)
        
        
        
        h=copyobj(ax(k),fig);
        set(h,'position','default','box','off');
        
        
        set(0,'currentfigure',fig)
        shg

        if k < 10
        print(fig, '-djpeg', ['tmp_00' num2str(k)]);
       % print(fig, '-dtiff', ['tmp_00' num2str(k)]);
        end
        
        if (k >=10) && (k < 100) 
        print(fig, '-djpeg', ['tmp_0' num2str(k)]);
   %     print(fig, '-dtiff', ['tmp_0' num2str(k)]);
        end
        
        if k >= 100
       print(fig, '-djpeg', ['tmp_' num2str(k)]);
%        print(fig, '-dtiff', ['tmp_' num2str(k)]);
        end
        
        delete(h);
        
    end
    
    
    
case 'V'

%     here=pwd;
%     [n p]=uiputfile('*.avi','output file')
%     cd(here);
% 
%     if n == 0
%         return
%     end

    
    ax=flipdim(findobj(gcf,'type','axes'),1);
    im=flipdim(findobj(gcf,'type','image','visible','on'),1);
    

    mov=avifile('tmp.avi');
 %    mov=avifile([p n]);
    mov.compression='Cinepak';
    cmp=colormap;
    fig=figure('name','tmp','numbertitle','off');
    colormap(cmp)
    for k=1:length(ax)
        
        
        
        h=copyobj(ax(k),fig);
        set(h,'position','default','box','off');
        
        
        set(0,'currentfigure',fig)
        shg
        mov_frame(k)=getframe(gca);
        delete(h);
        
    end
 
   prompt={'frames per second:','quality:'};
   def={'15','75'};
   dlgTitle='movie parameter';
   lineNo=1;
   answer=inputdlg(prompt,dlgTitle,lineNo,def);
 
   if isempty(answer)
       fps=15;
       qual=75;
   else
   
   fps=str2num(answer{1});
   qual=str2num(answer{2});
   end
   
   mov.quality=qual;
   mov.fps=fps;
     
   h=addframe(mov,mov_frame);
   h=close(mov)
   close(fig)
   
case 'u'
    
       prompt={'unwrap direction [1 (Y) 2 (X) 3 (XY)]:'};
        def={'1'};
        dlgTitle='unwrap parameter';
        lineNo=1;
        answer=inputdlg(prompt,dlgTitle,lineNo,def);
 
   if isempty(answer)
       return
   end
   
   flag=str2num(answer{1});
 
    im=get(gco,'Cdata');
    im=unwrap_simple(im,flag);
    set(gco,'Cdata',im);
    
case 'U'
        
        prompt={'unwrap direction [1 (Y) 2 (X) 3 (XY)]:'};
        def={'1'};
        dlgTitle='unwrap parameter';
        lineNo=1;
        answer=inputdlg(prompt,dlgTitle,lineNo,def);
 
   if isempty(answer)
       return
   end
   
   flag=str2num(answer{1});
 
            
        kids=get(gcf,'children');
        ax=findobj(kids,'type','axes');
        
        im=get(ax,'children');
        im=cat(1,im{:});
        im=findobj(im,'type','image','visible','on');
        im=flipud(im);
        w=get(im,'CData');
        w=cat(2,w{:});
        w=reshape(w,size(w,1),size(w,2)/size(im,1),size(im,1));
        wu=zeros(size(w));
        for N=1:length(flag)
  
        for k=1:size(w,3)
            
            wu(:,:,k)=unwrap_simple(w(:,:,k),flag(N));
        end
        
        plot2dwaves(wu)
        set(gcf,'name',['2D waves (3D input) unwrap ', num2str(flag(N))])
        

        end

    case 'W'
        
        
        kids=get(gcf,'children');
        ax=findobj(kids,'type','axes');
        
        im=get(ax,'children');
        im=cat(1,im{:});
        im=findobj(im,'type','image','visible','on');
        w=get(im,'CData');
        w=cat(2,w{:});
        w=reshape(w,size(w,1),size(w,2)/size(im,1),size(im,1));
        
        w=flipdim(w,3);
        global tmp_w
        tmp_w=w;
        disp(['new variable tmp_w size    ',num2str(size(w))])

    case 'T'
        
        im2surf
        
    case 'd'
        
        contour_bw

end % case

    
   