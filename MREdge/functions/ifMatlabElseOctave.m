function fun = ifMatlabElseOctave(fun_matlab, fun_octave)
% ifMatlabElseOctave(fun_matlab, fun_octave): assign one of two functions to a function handle,
% depending on whether the code runs on Octave or Matlab.
% The two arguments must be strings that define function handles. The
% return value is the eval'd version of one of the two strings, depending
% on whether the code is run on Matlab or Octave. Example:
%
% f = ifMatlabElseOctave('@(x) cell2mat(x)', '@(x)' cell2str(x)')
% On Matlab, f(x) will be equivalent to cell2mat(x). On Octave, f(x) will
% be the same as cell2str(x).
%
% Since eval is used to convert the string into a function handle, care has
% to be taken to prevent a user-provided malicious string to be turned into
% a function handle.
%
% Sebastian Hirsch (sebastian.hirsch@charite.de)
% Last change: 2017-03-28

fun = 0; % just to prevent a warning about fun not being set.

if (isOctave())
    eval(['fun = ' fun_octave ';']);
else
    eval(['fun = ' fun_matlab ';']);
end

end