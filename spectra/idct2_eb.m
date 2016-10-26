function y = idct2(x)
  t = idct_eb(x);
  t = idct_eb(t');
  y = t';
