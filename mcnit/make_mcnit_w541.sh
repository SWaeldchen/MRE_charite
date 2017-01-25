#!/bin/bash

CURRPATH=`pwd`
cd $MATLABMRE/m-code
MCNIT=`pwd`/mcnit
rm $MCNIT/*.m
cp misc/resh.m $MCNIT
cp octave/isoctave.m $MCNIT
cp misc/sparse_deriv.m $MCNIT
cp interpolation/interp_2d.m $MCNIT
cp interpolation/interp_3d.m $MCNIT
cp signal-processing-filtering/butter_2d.m $MCNIT
cp signal-processing-filtering/butter_3d.m $MCNIT
cp figures-plotting-catting/complex_plot.m $MCNIT
cp spectra/dct_octave.m $MCNIT
cp spectra/idct_octave.m $MCNIT
cp spectra/dctn.m $MCNIT
cp spectra/idctn.m $MCNIT
cp spectra/pwrspec_2d.m $MCNIT
cp results-calc-compare/normalize_image.m $MCNIT
cd $CURRPATH
