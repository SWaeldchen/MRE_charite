function smooth_1d
%
% smooth 1d via splines
%

obj=gco;

y=get(gco,'Ydata');
x=get(gco,'Xdata');

  prompt={'difference treshold:'};
   def={'1'};
   dlgTitle='Input for smooth 1D';
   lineNo=1;
   answer=inputdlg(prompt,dlgTitle,lineNo,def);
   
   if isempty(answer)
      return
   end
   
   toli=str2num(answer{1});

   
   cut=find(abs(diff(y)) > toli);
   
   y2=y;
   x2=x;
   
   y2(cut)=[];
   x2(cut)=[];
   
   y3=interp1(x2,y2,x,'spline');
   
   set(obj,'Ydata',y3);