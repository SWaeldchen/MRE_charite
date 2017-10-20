function fig2mov
%
%
%

here=pwd;
[n p]=uigetfile({'*.fig'},'pick first figure');
cd(here);
    if n == 0
        return
    end
   
   nc=strrep(n,'.fig','');
   
    
   prompt={'name core:','number of slices:','first number:','delta number:'};
   def={nc,'18','1','1'};
   dlgTitle='make movie';
   lineNo=1;
   answer=inputdlg(prompt,dlgTitle,lineNo,def);
 
   if isempty(answer)
       return
   end
   
   
   nc=answer{1};
   num_sli=str2num(answer{2});
   num_1=str2num(answer{3});
   num_d=str2num(answer{4});
   
   
   num=num_1-num_d;
   
   cd(p);
   [n p]=uiputfile([nc '.avi'],'output file');
    cd(here);

    if n == 0
        return
    end

   mov=avifile([p n]);
   mov.compression='Cinepak';
  
   for k=1:num_sli
       
       num=num + num_d;
       n=[nc num2str(num) '.fig'];
       disp(n)
       if exist([p n])
       
       h=open([p n]);
       ax=get(h,'children');
       
       %set(ax,'position',[0.3 0.3 0.4 0.4]);
       %set(h,'position',[0.5990    0.4525    0.3281    0.4421]); 
       %camlight;
       
        mov_frame(k)=getframe(ax);
 %       tmp=addframe(mov,h);
       close(h);
       end
        
   end
   
  
    
   prompt={'frames per second:','quality:'};
   def={'15','75'};
   dlgTitle='movie parameter';
   lineNo=1;
   answer=inputdlg(prompt,dlgTitle,lineNo,def);
 
   if isempty(answer)
       fps=15;
       qual=75;
   end
   
   fps=str2num(answer{1});
   qual=str2num(answer{2});
   
 %  mov=avifile([p n]);
   
   mov.quality=qual;
   mov.fps=fps;
   
   
   h=addframe(mov,mov_frame);
   h=close(mov);
        
        
       
       
       
   
     
       
   
    