function setcolor
%
%
%

col=get(gco,'color');

   prompt={'enter new color'};
   def={num2str(col)};
   dlgTitle='set color';
   lineNo=1;
   answer=inputdlg(prompt,dlgTitle,lineNo,def);
   
   if isempty(answer)
      return
  end
  
  
  new_col=str2num(answer{1});
  
  set(gco,'color',new_col);