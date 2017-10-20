function format_para(a)
% format_para(a)
% a(1): cx
% a(2): cz
% a(3): cz/cx (not important)
% a(4): std
% a(5): optional if it is given a(4) is std of cx and a(5) is std of cz

if length(a) == 4
    a(5) = a(4);
end

%vec=round([a, ((a(2)+a(4))/(a(1)-a(4))-(a(2)-a(4))/(a(1)+a(4)))/2]*100)/100; 

% rmax=(a(2)+a(4))/(a(1)-a(4));
% rmin=(a(2)-a(4))/(a(1)+a(4));
% %tol=std([rmax, rmin],1)/2;
% tol=(rmax-rmin)/2;
% m=mean([rmax rmin]);
% 
% vec=round([a(1), a(2), m, tol]*100)/100;
% disp([num2str(vec(1)), ' ' num2str(vec(2)) ' ' num2str(vec(3)), '(' num2str(vec(4)) ')'])

mumax1=(a(1)+a(4))^2*1.1;
mumin1=(a(1)-a(4))^2*1.1;
mumax2=(a(2)+a(5))^2*1.1;
mumin2=(a(2)-a(5))^2*1.1;
tol1=(mumax1-mumin1)/2;
tol2=(mumax2-mumin2)/2;
mu1=mean([mumax1 mumin1]);
mu2=mean([mumax2 mumin2]);
rmax=(mu2+tol2)/(mu1-tol1);
rmin=(mu2-tol2)/(mu1+tol1);
rtol=(rmax-rmin)/2;
rm=mean([rmax rmin]);


vec=round([mu1 tol1 mu2 tol2 rm rtol]*100)/100;
%disp([num2str(vec(1)), ' (' num2str(vec(2)), ') ' num2str(vec(3)), ' (' num2str(vec(4)), ') ' num2str(vec(5)), ' (' num2str(vec(6)), ')'])


r1=(a(2)+a(5))/(a(1)-a(4));
r2=(a(2)-a(5))/(a(1)+a(4));
r=mean([r1 r2]);
rtol=(r1-r2)/2;

b=round([a(1) a(4) a(2) a(5) r rtol]*100)/100;


disp([num2str(b(1)) ' (' num2str(b(2)) ') ' num2str(b(3)) ' (' num2str(b(4)) ') ' num2str(b(5)) ' (' num2str(b(6)) ') ' ...
    num2str(vec(1)), ' (' num2str(vec(2)), ') ' num2str(vec(3)), ' (' num2str(vec(4)), ') ' num2str(vec(5)), ' (' num2str(vec(6)), ')'])
