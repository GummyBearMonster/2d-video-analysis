//////////////////////////////////////////////////////////////////////////
// Creates C++ MEX-file for Gaussian Mixture-based Background/Foreground 
// Segmentation Algorithm in OpenCV. This uses BackgroundSubtractorMOG2 
// class in OpenCV.
//
// Copyright 2014-2016 The MathWorks, Inc.
//////////////////////////////////////////////////////////////////////////

#include "opencvmex.hpp"
using namespace cv;

static Ptr<BackgroundSubtractorKNN> ptrBackgroundModel = cv::createBackgroundSubtractorKNN();

//////////////////////////////////////////////////////////////////////////////
// Check inputs
//////////////////////////////////////////////////////////////////////////////
void checkInputs(int nrhs, const mxArray *prhs[])
{
    if ((nrhs < 1) || (nrhs > 2))
    {
        mexErrMsgTxt("Incorrect number of inputs. Function expects 1 or 2 inputs.");
    }
}

//////////////////////////////////////////////////////////////////////////////
// Get MEX function inputs
//////////////////////////////////////////////////////////////////////////////
void getParams(int &history, float &dist2Threshold, bool &bShadowDetection, int &kNNSamples, const mxArray* mxParams)
{
    const mxArray* mxfield;

    //--history--
    mxfield = mxGetField(mxParams, 0, "history");
    if (mxfield)
        history = (int)mxGetScalar(mxfield);

    //--dist2Threshold--
    mxfield = mxGetField(mxParams, 0, "dist2Threshold");
    if (mxfield)
        dist2Threshold = (float)mxGetScalar(mxfield);

    //--bShadowDetection--
    mxfield = mxGetField(mxParams, 0, "bShadowDetection");
    if (mxfield)
        bShadowDetection = (bool)mxGetScalar(mxfield);
    
    mxfield = mxGetField(mxParams, 0, "kNNSamples");
    if (mxfield)
        kNNSamples = (int)mxGetScalar(mxfield);
}

//////////////////////////////////////////////////////////////////////////////
// Construct object
//////////////////////////////////////////////////////////////////////////////
void constructObject(const mxArray *prhs[])
{  
    int history;
    float dist2Threshold;
    bool bShadowDetection;
    int kNNSamples;

    // second input must be struct
    if (mxIsStruct(prhs[1]))
        getParams(history, dist2Threshold, bShadowDetection, kNNSamples, prhs[1]);
    
    ptrBackgroundModel->setHistory(history);
    ptrBackgroundModel->setDist2Threshold(dist2Threshold);
    ptrBackgroundModel->setShadowThreshold(bShadowDetection);
    ptrBackgroundModel->setkNNSamples(kNNSamples);
}

//////////////////////////////////////////////////////////////////////////////
// Compute foreground mask
//////////////////////////////////////////////////////////////////////////////
void computeForegroundMask(mxArray *plhs[], const mxArray *prhs[])
{
    if (ptrBackgroundModel!=(std::nullptr_t)NULL)
    {
        Mat fgmask, fgimg;

        cv::Ptr<cv::Mat> img = ocvMxArrayToImage_uint8(prhs[1], true);

        // compute foreground mask
        ptrBackgroundModel->apply(*img, fgmask);
        plhs[0] = ocvMxArrayFromImage_bool(fgmask);
    }
}


//////////////////////////////////////////////////////////////////////////////
// Compute background mask
//////////////////////////////////////////////////////////////////////////////
void getBackgroundMask(mxArray *plhs[])
{
    if (ptrBackgroundModel!=(std::nullptr_t)NULL)
    {
        Mat bgmask;
        // compute background mask
        ptrBackgroundModel->getBackgroundImage(bgmask);
        plhs[0] = ocvMxArrayFromImage_uint8(bgmask);
    }
}

//////////////////////////////////////////////////////////////////////////////
// Exit function
//////////////////////////////////////////////////////////////////////////////
void exitFcn()
{
    
}

//////////////////////////////////////////////////////////////////////////////
// The main MEX function entry point
//////////////////////////////////////////////////////////////////////////////
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{  	
    checkInputs(nrhs, prhs);
    const char *str = mxIsChar(prhs[0]) ? mxArrayToString(prhs[0]) : NULL;

    if (str != NULL) 
    {
        if (strcmp (str,"construct") == 0)
            constructObject(prhs);
        else if (strcmp (str,"compute") == 0)
            computeForegroundMask(plhs, prhs);
        else if (strcmp (str,"destroy") == 0)
            exitFcn();
        else if (strcmp (str,"bg") == 0)
            getBackgroundMask(plhs);
        // Free memory allocated by mxArrayToString
        mxFree((void *)str);
    }
}

