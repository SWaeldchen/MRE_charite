function uw=unwrap2(w)
% uw=unwrap2(w)
% 1D pahse unwrapping according to Itho's method
% see book 2D-phase unwrapping page 21
% uw has one element less than w

%uw=cumsum(atan2(sin(diff(w)),cos(diff(w))));

%uw=cumsum(atan2(sin(4*gradient(w)),cos(4*gradient(w))))/4;

%uw=cumsum(atan2(sin(2*gradient(w)),cos(2*gradient(w))))/2;

si=size(w);

if length(si) == 3 % 3D array entfaltung entlang 3.Dimension
    
    [wx,wy,wt]=gradient(w);
    uw=cumsum(atan(tan(wt)),3);

else
    
uw=cumsum(atan(tan(gradient(w))));

end