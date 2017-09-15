
#include <stdio.h>
#include <memory.h>
#include "mex.h"
#include "WaveletGuidedLaplacian.h"

using namespace std;

void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {

    if(nrhs != 3) {
        mexPrintf("ERROR: requires three arguments: image, mask, and spacing \n");
        return;
    }
	int numDimsGuideage = mxGetNumberOfDimensions(prhs[0]);
	if (numDimsGuideage != 3) {
		mexPrintf("ERROR: 3 dimensional image required... \n");
		return;
	}
	int numDimsGuide = mxGetNumberOfDimensions(prhs[1]);
	if (numDimsGuide != 3) {
		mexPrintf("ERROR: 3 dimensional image required... \n");
		return;
	}
    mexPrintf("in mex function");
	const mwSize* mxdims;
	mxdims= mxGetDimensions(prhs[0]);
    size_t dims[3];
    dims[0] = (size_t)mxdims[0];
    dims[1] = (size_t)mxdims[1];
    dims[2] = (size_t)mxdims[2];
    int volume = dims[0]*dims[1]*dims[2];
	double* image = (double*)mxGetPr(prhs[0]);
	double* mask = (double*)mxGetPr(prhs[1]);
	double* spacing = (double*)mxGetPr(prhs[2]);
	WaveletGuidedLaplacian wgl;
    double* dataOut = wgl.computeLaplacian(image, mask, dims, spacing);
    //double* dataOut = image;
    const size_t* outputDims = new size_t[4]{dims[0], dims[1], dims[2], 1};
    plhs[0] = mxCreateNumericArray(4, outputDims, mxDOUBLE_CLASS, mxREAL);
    memcpy(mxGetPr(plhs[0]),dataOut, volume*sizeof(double));
    delete[] dataOut;
    return;

}

