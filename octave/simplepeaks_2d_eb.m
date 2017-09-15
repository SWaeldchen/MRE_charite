% Copyright (c) 2012 Juan Pablo Carbajal <carbajal@ifi.uzh.ch>
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, see <http://www.gnu.org/licenses/>.

% -*- texinfo -*-
% @deftypefn  {Function File} {[@var{pks}, @var{loc}, @var{extra}] =} findpeaks (@var{data})
% @deftypefnx {Function File} {@dots{} =} findpeaks (@dots{}, @var{property}, @var{value})
% @deftypefnx {Function File} {@dots{} =} findpeaks (@dots{}, @asis{'DoubleSided'})
% Finds peaks on @var{data}.
%
% Peaks of a positive array of data are defined as local maxima. For
% double-sided data, they are maxima of the positive part and minima of
% the negative part. @var{data} is expected to be a single column
% vector.
%
% The function returns the value of @var{data} at the peaks in
% @var{pks}. The index indicating their position is returned in
% @var{loc}.
%
% The third output argument is a structure with additional information:
%
% @table @asis
% @item 'parabol'
% A structure containing the parabola fitted to each returned peak. The
% structure has two fields, @asis{'x'} and @asis{'pp'}. The field
% @asis{'pp'} contains the coefficients of the 2nd degree polynomial
% and @asis{'x'} the extrema of the intercal here it was fitted.
%
% @item 'height'
% The estimated height of the returned peaks (in units of @var{data}).
%
% @item 'baseline'
% The height at which the roots of the returned peaks were calculated
% (in units of @var{data}).
%
% @item 'roots'
% The abscissa values (in index units) at which the parabola fitted to
% each of the returned peaks crosses the @asis{'baseline'} value. The
% width of the peak is calculated by @command{diff(roots)}.
% @end table
%
% This function accepts property-value pair given in the list below:
%
% @table @asis
%
% @item 'MinPeakHeight'
% Minimum peak height (positive scalar). Only peaks that exceed this
% value will be returned. For data taking positive and negative values
% use the option 'DoubleSided'. Default value @code{2*std (abs (detrend
% (data,0)))}.
%
% @item 'MinPeakDistance'
% Minimum separation between (positive integer). Peaks separated by
% less than this distance are considered a single peak. This distance
% is also used to fit a second order polynomial to the peaks to
% estimate their width, therefore it acts as a smoothing parameter.
% Default value 4.
%
% @item 'MinPeakWidth'
% Minimum width of peaks (positive integer). The width of the peaks is
% estimated using a parabola fitted to the neighborhood of each peak.
% The neighborhood size is equal to the value of
% @asis{'MinPeakDistance'}. The width is evaluated at the half height
% of the peak with baseline at 'MinPeakHeight'. Default value 2.
%
% @item 'DoubleSided'
% Tells the function that data takes positive and negative values. The
% base-line for the peaks is taken as the mean value of the function.
% This is equivalent as passing the absolute value of the data after
% removing the mean.
% @end table
%
% Run @command{demo findpeaks} to see some examples.
% @end deftypefn

function [peaks, locs] = simplepeaks_2d_eb (data)

sz = size(data);

  % Rough estimates of first and second derivative
  df1 = diff (data, 1, 2); df1 = [df1(:,1) df1];
  df2 = diff (data, 2, 2); df2 = [df2(:,1) df2(:,1) df2];

  % check for changes of sign of 1st derivative and negativity of 2nd
  % derivative.
  % <= in 1st derivative includes the case of oversampled signals.
  locs = df1.*[df1(:,2:end), zeros(sz(1), 1)] <= 0 & [df2(:,2:end), zeros(sz(1),1)] < 0;
  peaks = data(locs);


end
