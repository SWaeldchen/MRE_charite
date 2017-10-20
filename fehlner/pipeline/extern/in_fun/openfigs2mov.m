function openfigs2mov
%  openfigs2mov
% create tmp.avi from all open figures


  
    mov=avifile('tmp.avi');
%    mov.compression='Cinepak';
 
    figs=findobj(0,'type','figure');
    
    for k=1:length(figs)
        
        
        
        ax=findobj(figs(k),'type','axes');
        mov_frame(k)=getframe(ax(1));
        
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
  