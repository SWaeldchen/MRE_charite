

function A = ordfilt2_eb (A, nth, domain, varargin)

  if (nargin < 3)
    print_usage ();
  elseif (ndims (A) > 2 || ndims (domain) > 2 ) %#ok<ISMAT>
    error ('ordfilt2: A and DOMAIN are limited to 2 dimensinos. Use ''ordfiltn'' for more')
  end
  A = ordfiltn (A, nth, domain, varargin{:});
  end
