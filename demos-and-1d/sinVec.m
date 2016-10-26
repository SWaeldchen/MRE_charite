function y = sinVec(length, period, offset)
if (nargin == 2)
    offset = 0;
end
y = sin((1:length)*2*pi/period + offset);