function r = isOctave ()
% isOctave(): Check if the code is currently running on octave or not.
% Copied from
% https://stackoverflow.com/questions/2246579/how-do-i-detect-if-im-running-matlab-or-octave
% Sebatian Hirsch, 2017-03-28

  persistent x;
  if (isempty (x))
    x = exist ('OCTAVE_VERSION', 'builtin');
  end
  r = x;
end