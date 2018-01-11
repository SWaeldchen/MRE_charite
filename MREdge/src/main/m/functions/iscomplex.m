function y = iscomplex(x)

if (isa(x, 'double') || isa(x, 'single')) && ~isreal(x)
    y = 1;
else
    y = 0;
end
