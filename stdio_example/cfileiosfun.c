/* Give S-function a name */
#define S_FUNCTION_NAME  cfileiosfun
#define S_FUNCTION_LEVEL 2

/* Include SimStruct definition and file I/O functions */
#include "simstruc.h"
#include <stdio.h>


/* Called at the beginning of the simulation */
static void mdlInitializeSizes(SimStruct *S)
{

    ssSetNumSFcnParams(S, 0); 
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
        return;
    }

    ssSetNumContStates(S, 0);
    ssSetNumDiscStates(S, 0);

    if (!ssSetNumInputPorts(S, 0)) return;
    if (!ssSetNumOutputPorts(S, 1)) return;
    ssSetOutputPortWidth(S, 0, 1);
    ssSetOutputPortDataType(S,0,SS_SINGLE);

    ssSetNumPWork(S,1);
    ssSetNumSampleTimes(S, 1);
}


/* Set sample times for the block */
static void mdlInitializeSampleTimes(SimStruct *S)
{
    ssSetSampleTime(S, 0, 1.0);
    ssSetOffsetTime(S, 0, 0.0);
}



#define MDL_START  /* Change to #undef to remove function */
#if defined(MDL_START) 
  /* Function: mdlStart =======================================================
   * Abstract:
   *    This function is called once at start of model execution. If you
   *    have states that should be initialized once, this is the place
   *    to do it.
   */
  static void mdlStart(SimStruct *S)
  {
      /*at start of model execution, open the file and store the pointer
       *in the pwork vector */
      void** pwork = ssGetPWork(S);
      FILE *datafile;
      
      datafile = fopen("datafile.dat","r");
      pwork[0] =  datafile;
      
  }
#endif /*  MDL_START */



/* Function: mdlOutputs =======================================================
 * Abstract:
 *    In this function, you compute the outputs of your S-function
 *    block. Generally outputs are placed in the output vector, ssGetY(S).
 */
static void mdlOutputs(SimStruct *S, int_T tid)
{
    //get pointer to the block's output signal
    real_T       *y = ssGetOutputPortSignal(S,0);
    
    /*get pointer to array of pointers, where the first element is the address
     *of the open file */
    void** pwork = ssGetPWork(S);
    
    /*read a floating point number and then the comma delimiter
     *store the result in y*/
    fscanf(pwork[0],"%f%*c",y);
}



/* Function: mdlTerminate =====================================================
 * Abstract:
 *    In this function, you should perform any actions that are necessary
 *    at the termination of a simulation.  For example, if memory was
 *    allocated in mdlStart, this is the place to free it.
 */
static void mdlTerminate(SimStruct *S)
{
    //close the file
    void** pwork = ssGetPWork(S);
      FILE *datafile;
      
      datafile = pwork[0];
      fclose(datafile);
      
}



/*=============================*
 * Required S-function trailer *
 *=============================*/

#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
#include "simulink.c"      /* MEX-file interface mechanism */
#else
#include "cg_sfun.h"       /* Code generation registration function */
#endif
