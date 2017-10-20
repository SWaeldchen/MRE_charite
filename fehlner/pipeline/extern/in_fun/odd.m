function ans=odd(x)
%
% Find out wether an integer is odd or even
%
a=mod(x/2,1);
if a == 0.5
   ans=1;
elseif a==0
   ans = 0;
else
   disp('not an integer!');
   return;
end
