function xys=select_line(num)
%
%
%


hold on
% Initially, the list of points is empty.
xy = [];
n = 0;
% Loop, picking up the points.
disp('Left mouse button picks points.')
disp('Right mouse button quit.')
but = 1;
while but == 1
    [xi,yi,but] = ginput(1);
    
    if but == 1
    h=plot(xi,yi,'r.');
    set(h,'tag','tmp')
    n = n+1;
    xy(:,n) = [xi;yi];
    end
    
end

% Interpolate with a spline curve and finer spacing.
t = 1:n;
ts = linspace(1,n,num);
xys = spline(t,xy,ts);

% Plot the interpolated curve.
a=plot(xys(1,:),xys(2,:),'b-');
set(a,'tag','selected_line')
delete(findobj(gca,'tag','tmp'));
hold off