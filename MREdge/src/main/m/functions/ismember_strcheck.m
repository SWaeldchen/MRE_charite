

function [c] = ismember_strcheck (A, B)

if isreal(A)
  a = num2str(A);
else
  a = A;
end

c = ismember(a, B);

end