function y=awgn_eb(varargin)
%AWGN Add white Gaussian noise to a signal.
%   Y = AWGN(X,SNR) adds white Gaussian noise to X.  The SNR is in dB.
%   The power of X is assumed to be 0 dBW.  If X is complex, then 
%   AWGN adds complex noise.
%
%   Y = AWGN(X,SNR,SIGPOWER) when SIGPOWER is numeric, it represents 
%   the signal power in dBW. When SIGPOWER is 'measured', AWGN measures
%   the signal power before adding noise.
%
%   Y = AWGN(X,SNR,SIGPOWER,S) uses S, which is a random stream handle, to
%   generate random noise samples with RANDN. If S is an integer, then
%   resets the state of RANDN to S. The latter usage is obsoleted and may
%   be removed in a future release.  If you want to generate repeatable
%   noise samples, then provide the handle of a random stream or use reset
%   method on the default random stream.  Type 'help RandStream' for more
%   information.
%
%   Y = AWGN(X,SNR,SIGPOWER,STATE) resets the state of RANDN to STATE.
%   This usage is deprecated and may be removed in a future release.
%
%   Y = AWGN(..., POWERTYPE) specifies the units of SNR and SIGPOWER.
%   POWERTYPE can be 'db' or 'linear'.  If POWERTYPE is 'db', then SNR
%   is measured in dB and SIGPOWER is measured in dBW.  If POWERTYPE is
%   'linear', then SNR is measured as a ratio and SIGPOWER is measured
%   in Watts.
%
%   Example 1: 
%        % To specify the power of X to be 0 dBW and add noise to produce
%        % an SNR of 10dB, use:
%        X = sqrt(2)*sin(0:pi/8:6*pi);
%        Y = awgn(X,10,0);
%
%   Example 2: 
%        % To specify the power of X to be 3 Watts and add noise to
%        % produce a linear SNR of 4, use:
%        X = sqrt(2)*sin(0:pi/8:6*pi);
%        Y = awgn(X,4,3,'linear');
%
%   Example 3: 
%        % To cause AWGN to measure the power of X and add noise to
%        % produce a linear SNR of 4, use:
%        X = sqrt(2)*sin(0:pi/8:6*pi);
%        Y = awgn(X,4,'measured','linear');
%
%   Example 4: 
%        % To specify the power of X to be 0 dBW, add noise to produce
%        % an SNR of 10dB, and utilize a local random stream, use:
%        S = RandStream('mt19937ar','seed',5489);
%        X = sqrt(2)*sin(0:pi/8:6*pi);
%        Y = awgn(X,10,0,S);
%
%   Example 5: 
%        % To specify the power of X to be 0 dBW, add noise to produce
%        % an SNR of 10dB, and produce reproducible results, use:
%        reset(RandStream.getGlobalStream)
%        X = sqrt(2)*sin(0:pi/8:6*pi);
%        Y = awgn(X,10,0,S);
%
%
%   See also WGN, RANDN, RandStream/RANDN, and BSC.

%   Copyright 1996-2014 The MathWorks, Inc.

% --- Initial checks
narginchk(2,5);

% --- Value set indicators (used for the string flags)
pModeSet    = 0;
measModeSet = 0;

% --- Set default values
sigPower = 0;
pMode    = 'db';
measMode = 'specify';
state    = [];

% --- Placeholder for the signature string
sigStr = '';

% --- Identify string and numeric arguments
isStream = false;
for n=1:nargin
   if(n>1)
      sigStr(size(sigStr,2)+1) = '/';
   end
   % --- Assign the string and numeric flags
   if(ischar(varargin{n}))
      sigStr(size(sigStr,2)+1) = 's';
   elseif(isnumeric(varargin{n}))
      sigStr(size(sigStr,2)+1) = 'n';
   elseif(isa(varargin{n},'RandStream'))
      sigStr(size(sigStr,2)+1) = 'h';
      isStream = true;
   else
      error('comm:awgn:InvalidArg');
   end
end

% --- Identify parameter signatures and assign values to variables
switch sigStr
   % --- awgn(x, snr)
   case 'n/n'
      sig      = varargin{1};
      reqSNR   = varargin{2};

   % --- awgn(x, snr, sigPower)
   case 'n/n/n'
      sig      = varargin{1};
      reqSNR   = varargin{2};
      sigPower = varargin{3};

   % --- awgn(x, snr, 'measured')
   case 'n/n/s'
      sig      = varargin{1};
      reqSNR   = varargin{2};
      measMode = lower(varargin{3});

      measModeSet = 1;

   % --- awgn(x, snr, sigPower, state)
   case {'n/n/n/n', 'n/n/n/h'}
      sig      = varargin{1};
      reqSNR   = varargin{2};
      sigPower = varargin{3};
      state    = varargin{4};

   % --- awgn(x, snr, 'measured', state)
   case {'n/n/s/n', 'n/n/s/h'}
      sig      = varargin{1};
      reqSNR   = varargin{2};
      measMode = lower(varargin{3});
      state    = varargin{4};

      measModeSet = 1;

   % --- awgn(x, snr, sigPower, 'db|linear')
   case 'n/n/n/s'
      sig      = varargin{1};
      reqSNR   = varargin{2};
      sigPower = varargin{3};
      pMode    = lower(varargin{4});

      pModeSet = 1;

   % --- awgn(x, snr, 'measured', 'db|linear')
   case 'n/n/s/s'
      sig      = varargin{1};
      reqSNR   = varargin{2};
      measMode = lower(varargin{3});
      pMode    = lower(varargin{4});

      measModeSet = 1;
      pModeSet    = 1;

   % --- awgn(x, snr, sigPower, state, 'db|linear')
   case {'n/n/n/n/s', 'n/n/n/h/s'}
      sig      = varargin{1};
      reqSNR   = varargin{2};
      sigPower = varargin{3};
      state    = varargin{4};
      pMode    = lower(varargin{5});

      pModeSet = 1;

   % --- awgn(x, snr, 'measured', state, 'db|linear')
   case {'n/n/s/n/s', 'n/n/s/h/s'}
      sig      = varargin{1};
      reqSNR   = varargin{2};
      measMode = lower(varargin{3});
      state    = varargin{4};
      pMode    = lower(varargin{5});

      measModeSet = 1;
      pModeSet    = 1;

   otherwise
      disp(('comm:awgn:InvalidSyntax'));
end   

% --- Parameters have all been set, either to their defaults or by the values passed in,
%     so perform range and type checks

% --- sig
if(isempty(sig))
   disp(('comm:awgn:NoInput'));
end

if(ndims(sig)>2)
   disp(('comm:awgn:InvalidSignalDims'));
end

% --- measMode
if(measModeSet)
   if(~strcmp(measMode,'measured'))
      disp(('comm:awgn:InvalidSigPower1'));
   end
end

% --- pMode
if(pModeSet)
   switch pMode
   case {'db' 'linear'}
   otherwise
      disp(('comm:awgn:InvalidPowerType'));
   end
end

% -- reqSNR
if(any([~isreal(reqSNR) (length(reqSNR)>1) (isempty(reqSNR))]))
   disp(('comm:awgn:InvalidSNR'));
end

if(strcmp(pMode,'linear'))
   if(reqSNR<=0)
      disp(('comm:awgn:InvalidSNRForLinearMode'));
   end
end

% --- sigPower
if(~strcmp(measMode,'measured'))

   % --- If measMode is not 'measured', then the signal power must be specified
   if(any([~isreal(sigPower) (length(sigPower)>1) (isempty(sigPower))]))
      disp(('comm:awgn:InvalidSigPower2'));
   end
   
   if(strcmp(pMode,'linear'))
      if(sigPower<0)
         disp(('comm:awgn:InvalidSigPowerForLinearMode'));
      end
   end

end

% --- state
if(~isempty(state))
    if ~isStream
        validateattributes(state, {'double', 'RandStream'}, ...
            {'real', 'scalar', 'integer'}, 'awgn', 'S');
    end
end

% --- All parameters are valid, so no extra checking is required

% --- Check the signal power.  This needs to consider power measurements on matrices
if(strcmp(measMode,'measured'))
   sigPower = sum(abs(sig(:)).^2)/length(sig(:));

   if(strcmp(pMode,'db'))
      sigPower = 10*log10(sigPower);
   end
end

% --- Compute the required noise power
switch lower(pMode)
   case 'linear'
      noisePower = sigPower/reqSNR;
   case 'db'
      noisePower = sigPower-reqSNR;
      pMode = 'dbw';
end

% --- Add the noise
if(isreal(sig))
   opType = 'real';
else
   opType = 'complex';
end

y = sig+wgn_eb(size(sig,1), size(sig,2), noisePower, 1, state, pMode, opType);

end

function y = wgn_eb(varargin)
%WGN Generate white Gaussian noise.
%   Y = WGN(M,N,P) generates an M-by-N matrix of white Gaussian noise. P
%   specifies the power of the output noise in dBW. The unit of measure for
%   the output of the wgn function is Volts. For power calculations, it is
%   assumed that there is a load of 1 Ohm. 
%
%   Y = WGN(M,N,P,IMP) specifies the load impedance in Ohms.
%
%   Y = WGN(M,N,P,IMP,S) uses S, which is a random stream handle, to
%   generate random noise samples with RANDN. This syntax is useful to
%   generate repeatable outputs.  Type 'help RandStream' for more
%   information.
%
%   Y = WGN(M,N,P,IMP,STATE) resets the state of RANDN to STATE. This usage
%   is deprecated and may be removed in a future release.
%
%   Additional flags that can follow the numeric arguments are:
%
%   Y = WGN(..., POWERTYPE) specifies the units of P.  POWERTYPE can be
%   'dBW', 'dBm' or 'linear'.  Linear power is in Watts.
%
%   Y = WGN(..., OUTPUTTYPE); Specifies the output type.  OUTPUTTYPE can be
%   'real' or 'complex'.  If the output type is complex, then P is divided
%   equally between the real and imaginary components.
%
%   Example 1: 
%       % To generate a 1024-by-1 vector of complex noise with power
%       % of 5 dBm across a 50 Ohm load, use:
%       Y = wgn(1024, 1, 5, 50, 'dBm', 'complex')
%
%   Example 2: 
%       % To generate a 256-by-5 matrix of real noise with power
%       % of 10 dBW across a 1 Ohm load, use:
%       Y = wgn(256, 5, 10, 'real')
%
%   Example 3: 
%       % To generate a 1-by-10 vector of complex noise with power
%       % of 3 Watts across a 75 Ohm load, use:
%       Y = wgn(1, 10, 3, 75, 'linear', 'complex')
%
%   See also RANDN, AWGN.

%   Copyright 1996-2014 The MathWorks, Inc.

% --- Initial checks
narginchk(3,7);

% --- Value set indicators (used for the strings)
pModeSet    = 0;
cplxModeSet = 0;

% --- Set default values
pMode    = 'dbw';
imp      = 1;
cplxMode = 'real';
seed     = [];

% --- Placeholders for the numeric and string index values
numArg = [];
strArg = [];

% --- Identify string and numeric arguments
%     An empty in position 4 (Impedance) or 5 (Seed) are considered numeric
isStream = false;
for n=1:nargin
   if(isempty(varargin{n}))
      switch n
      case 4
         if(ischar(varargin{n}))
            disp(('comm:wgn:InvalidDefaultImp'));
         end;
         varargin{n} = imp; % Impedance has a default value
      case 5
         if(ischar(varargin{n}))
            disp(('comm:wgn:InvalidNumericInput'));
         end;
         varargin{n} = [];  % Seed has no default
      otherwise
         varargin{n} = '';
      end;
   end;

   % --- Assign the string and numeric vectors
   if(ischar(varargin{n}))
      strArg(size(strArg,2)+1) = n; %#ok<AGROW>
   elseif(isnumeric(varargin{n}))
      numArg(size(numArg,2)+1) = n; %#ok<AGROW>
   elseif(isa(varargin{n},'RandStream'))
      numArg(size(numArg,2)+1) = n; %#ok<AGROW>
      isStream = true;
   else
      disp(('comm:wgn:InvalidArg'));
   end;
end;

% --- Build the numeric argument set
switch(length(numArg))

   case 3
      % --- row is first (element 1), col (element 2), p (element 3)

      if(all(numArg == [1 2 3]))
         row    = varargin{numArg(1)};
         col    = varargin{numArg(2)};
         p      = varargin{numArg(3)};
      else
         disp(('comm:wgn:InvalidSyntax'))
      end;

   case 4
      % --- row is first (element 1), col (element 2), p (element 3), imp (element 4)
      %

      if(all(numArg(1:3) == [1 2 3]))
         row    = varargin{numArg(1)};
         col    = varargin{numArg(2)};
         p      = varargin{numArg(3)};
         imp    = varargin{numArg(4)};
      else
         disp(('comm:wgn:InvalidSyntax'))
      end;

   case 5
      % --- row is first (element 1), col (element 2), p (element 3), imp (element 4), seed (element 5)

      if(all(numArg(1:3) == [1 2 3]))
         row    = varargin{numArg(1)};
         col    = varargin{numArg(2)};
         p      = varargin{numArg(3)};
         imp    = varargin{numArg(4)};
         seed   = varargin{numArg(5)};
      else
         disp(('comm:wgn:InvalidSyntax'));
      end;
   otherwise
      disp(('comm:wgn:InvalidSyntax'));
end;

% --- Build the string argument set
for n=1:length(strArg)
   switch lower(varargin{strArg(n)})
   case {'dbw' 'dbm' 'linear'}
      if(~pModeSet)
         pModeSet = 1;
         pMode = lower(varargin{strArg(n)});
      else
         disp(('comm:wgn:TooManyPowerTypes'));
      end;
   case {'db'}
      disp(('comm:wgn:InvalidPowerType'));
   case {'real' 'complex'}
      if(~cplxModeSet)
         cplxModeSet = 1;
         cplxMode = lower(varargin{strArg(n)});
      else
         disp(('comm:wgn:TooManyOutputTypes'));
      end;
   otherwise
      disp(('comm:wgn:InvalidArgOption'));
   end;
end;

% --- Arguments and defaults have all been set, either to their defaults or by the values passed in
%     so, perform range and type checks

% --- p
if(isempty(p))
   disp(('comm:wgn:InvalidPowerVal'));
end;

if(any([~isreal(p) (length(p)>1) (isempty(p))]))
   disp(('comm:wgn:InvalidPowerVal'));
end;

if(strcmp(pMode,'linear'))
   if(p<0)
      disp(('comm:wgn:NegativePower'));
   end;
end;

% --- Dimensions
if(any([isempty(row) isempty(col) ~isscalar(row) ~isscalar(col)]))
   disp(('comm:wgn:InvalidDims'));
end;

if(any([(row<=0) (col<=0) ~isreal(row) ~isreal(col) ((row-floor(row))~=0) ((col-floor(col))~=0)]))
   disp(('comm:wgn:InvalidDims'));
end;

% --- Impedance
if(any([~isreal(imp) (length(imp)>1) (isempty(imp)) any(imp<=0)]))
   disp(('comm:wgn:InvalidImp'));
end;

% --- Seed
if(~isempty(seed))
    if ~isStream
        validateattributes(seed, {'double', 'RandStream'}, ...
            {'real', 'scalar', 'integer'}, 'WGN', 'S');
    end
end;

% --- All parameters are valid, so no extra checking is required
switch lower(pMode)
   case 'linear'
      noisePower = p;
   case 'dbw'
      noisePower = 10^(p/10);
   case 'dbm'
      noisePower = 10^((p-30)/10);
end;

% --- Generate the noise
if(~isempty(seed))
    if isStream
        hStream = seed;
    else
        hStream = RandStream('shr3cong', 'Seed', seed);
    end
    func = @(a,b)randn(hStream,a,b);
else
    func = @(a,b)randn(a,b);
end;

if(strcmp(cplxMode,'complex'))
   y = (sqrt(imp*noisePower/2))*(func(row, col)+1i*func(row, col));
else
   y = (sqrt(imp*noisePower))*func(row, col);
end;

end
