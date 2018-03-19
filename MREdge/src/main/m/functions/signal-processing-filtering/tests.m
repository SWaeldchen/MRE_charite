## Copyright (C) 2016 Eric Barnhill
## 
## This program is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*- 
## @deftypefn {} {@var{retval} =} tests (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Eric Barnhill <ericbarnhill@pwr-lep>
## Created: 2016-10-02

[mag_04 phi_04] = ESP(firstHarmCorr(:,:,:,:,:,5), [18 20 22], [.002 .002 .002], 0, 1, 0, 0, 0.04);
U_denoise_04 = U_denoise;
%[mag_05 phi_05] = ESP(firstHarmCorr(:,:,:,:,:,5), [18 20 22], [.002 .002 .002], 0, 1, 0, 0, 0.05);
%U_denoise_05 = U_denoise;
%[mag_06 phi_06] = ESP(firstHarmCorr(:,:,:,:,:,5), [18 20 22], [.002 .002 .002], 0, 1, 0, 0, 0.06);
%U_denoise_06 = U_denoise;

save -mat7-binary 'florian_new_hhd.mat'