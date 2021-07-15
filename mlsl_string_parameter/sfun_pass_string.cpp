#define S_FUNCTION_LEVEL 2
#define S_FUNCTION_NAME  sfun_pass_string

#include "simstruc.h"
#include <string>

static void mdlInitializeSizes(SimStruct *S)
{
    ssSetNumSFcnParams(S, 1);

    ssSetSFcnParamTunable(S, 0, SS_PRM_NOT_TUNABLE);

    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
        return;
    }


    if (!ssSetNumInputPorts(S,1)) return;
	ssSetInputPortWidth(S, 0, DYNAMICALLY_SIZED);
	ssSetInputPortDirectFeedThrough(S, 0, 1);

	if (!ssSetNumOutputPorts(S, 1)) return;
	ssSetOutputPortWidth(S, 0, DYNAMICALLY_SIZED);
 
    ssSetNumSampleTimes(S, 1);

    ssSetOptions(S, SS_OPTION_CALL_TERMINATE_ON_EXIT);

}

static void mdlInitializeSampleTimes(SimStruct *S)
{
	ssSetSampleTime(S, 0, INHERITED_SAMPLE_TIME);
	ssSetOffsetTime(S, 0, 0.0);
	ssSetModelReferenceSampleTimeDefaultInheritance(S);
}

#define MDL_START
static void mdlStart(SimStruct *S)
{
    mexPrintf("class of parameter: %s", mxGetClassName(ssGetSFcnParam(S,0)));
    const mxArray* pArrayValue = ssGetSFcnParam(S,0);
    const char* pCharArray = mxArrayToString(pArrayValue);
    std::string string_1(pCharArray);
    mexPrintf(string_1.c_str());
}

  
static void mdlOutputs(SimStruct *S, int_T tid)
{

}                                                


static void mdlTerminate(SimStruct *S)
{
}                                      

#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
#include "simulink.c"      /* MEX-file interface mechanism */
#else
#include "cg_sfun.h"       /* Code generation registration function */
#endif

