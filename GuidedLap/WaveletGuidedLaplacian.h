#include<cstddef>

#ifndef WAVGUIDEDLAP_H_
#define WAVGUIDEDLAP_H_

class WaveletGuidedLaplacian {

	public:
        double* computeLaplacian(double* image, double* mask, size_t* dims, double* spacing); 

};


#endif
