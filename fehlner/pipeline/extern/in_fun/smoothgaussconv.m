function ws=smoothgaussconv(w,fw)
%
% normalized convolution by Gauss-Filters
%

ws=[];

if nargin < 1
    w = get(gco,'Cdata');

   prompt={'Enter ratio of filter width:'};
   def={'0.01'};
   dlgTitle='Input for Gauss smoothing';
   lineNo=1;
   answer=inputdlg(prompt,dlgTitle,lineNo,def);
   
   
   if isempty(answer)
       return
   end

   fw=str2num(answer{1})/2;

end 

   si=size(w);
   
   x1=linspace(0,1,si(1));
   x2=linspace(0,1,si(2));
   
   y1=exp(-((x1-0.5)/fw).^2);
   y2=exp(-((x2-0.5)/fw).^2);
   
   ws=filter2(y1'*y2,w);