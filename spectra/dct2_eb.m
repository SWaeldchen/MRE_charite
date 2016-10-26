function x = dct2_eb(y)
  t = dct_eb(y);
  t = dct_eb(t');
  x = t';
  
