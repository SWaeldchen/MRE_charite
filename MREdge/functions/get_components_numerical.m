function [comp_ind] = get_components_numerical(comp_order_str)
% comp_ind = get_components_numerical(component_order_string)
% Convert a numerical descriptor of component orders to a string with
% indices.
% E.g.
% get_components_numerical('yxz') -> [2 1 3]

comp_ind = zeros(1,length(comp_order_str));
count = 1;

for c=comp_order_str
   switch c
       case 'x'
           comp_ind(count) = 1;
       case 'y'
           comp_ind(count) = 2;
       case 'z'
           comp_ind(count) = 3;
       otherwise
           error(['Unknown direction descriptor: ' c]);
   end
   count = count+1;
end
