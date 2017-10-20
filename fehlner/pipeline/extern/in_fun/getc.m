function getc(delete_old_line)

if nargin > 0
h=gco;
delete(gco);
delete(findobj(gcf,'userdata',h))
end


shg;
fig=gcf;
hold on

[x y]=ginput(2);

h=plot(x,y,'b');

c=abs(diff(y)/diff(x));


%title(['c = ' num2str(c) ])
h1=text(x(2),y(2),['c = ' num2str(c) ]);
set(h1,'userdata',h)
set(h,'tag','c_line','buttondownfcn','getc(''dummy'')')


