#include "opencvmex.hpp"
using namespace cv;

//////////////////////////////////////////////////////////////////////////////
// Check inputs
//////////////////////////////////////////////////////////////////////////////
void checkInputs(int nrhs, const mxArray *prhs[])
{
    if (nrhs !=3)
    {
        mexErrMsgTxt("Incorrect number of inputs. Function expects 3 inputs.");
    }
}


//////////////////////////////////////////////////////////////////////////////
// Compute cvAdaptiveThreshold
//////////////////////////////////////////////////////////////////////////////
void cvAdaptiveThreshold(mxArray *plhs[], const mxArray *prhs[])
{
        Mat src, dst;
        src = *ocvMxArrayToImage_uint8(prhs[0], true);
        int n=(int) *mxGetPr(prhs[1]);
        double c= *mxGetPr(prhs[2]);
        adaptiveThreshold(src, dst, 1, ADAPTIVE_THRESH_GAUSSIAN_C, THRESH_BINARY, n, c);
        plhs[0] = ocvMxArrayFromImage_bool(dst);
}


//////////////////////////////////////////////////////////////////////////////
// The main MEX function entry point
//////////////////////////////////////////////////////////////////////////////
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{  	
    checkInputs(nrhs, prhs);
    cvAdaptiveThreshold(plhs, prhs);
}
