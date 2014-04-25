/****************************************************************************/
/***                                                                      ***/
/***   (C) 2013 Visarity Technology, all rights reserved                  ***/
/***                                                                      ***/
/****************************************************************************/

#ifndef FILE_ELBE_PLAYER_LIB_SHARED_H
#define FILE_ELBE_PLAYER_LIB_SHARED_H

#ifdef __cplusplus
extern "C" {
#endif

#define EPLTARGET_WIN       1
#define EPLTARGET_IOS       2
#define EPLTARGET_ANDROID   3

#ifdef __APPLE__
#include "TargetConditionals.h"
#if TARGET_OS_IPHONE
#define EPLTARGET EPLTARGET_IOS
#endif
#elif defined ANDROID
#define EPLTARGET EPLTARGET_ANDROID
#else
#define EPLTARGET EPLTARGET_WIN
#endif

/****************************************************************************

How to use the library.

If you are an integrator, please read the next lines carefully.
It will help you to avoid wasting your time hunting for bugs.

Limitations / Pitfalls:

-   It is not allowed to call any EPLxxx function from within the Event callback,
    it would cause a deadlock

-   The current implementation only supports one view

-   Most functions are requiring a set OpenGL|ES or DirectX context


Note / Remarks:

-   EventCallbacks are regisered globally, not per view or ad


****************************************************************************/

/****************************************************************************

Error Codes

****************************************************************************/

enum EPLErrCode
{
    EPLEC_OK    = 0,
    EPLEC_INVALIDKEY = 1,
    EPLEC_MULTIPLESYSTEMINITS = 2,
    EPLEC_NOSYSTEMINIT = 3,
    EPLEC_NOVALIDADHANDLE = 4,
    EPLEC_NOVALIDVIEWHANDLE = 5,
    EPLEC_INVALIDPACKFILE = 6,
    EPLEC_INVALIDADFILE = 7,
    EPLEC_INVALIDADFILENOTFOUND = 8,
    EPLEC_NULLPOINTER = 9,
    EPLEC_INVALIDPARAMETER = 10,
    EPLEC_INVALIDIMAGEID = 11,
    EPLEC_NOARCAMERA = 12
};

/****************************************************************************

To utilise the HW most efficiently platform specific features are supported. 
For that the assets most be prepared in advance. 
ElbeComposer takes care of generating all the different platform pack files.

e.g.
porsche.DEFAULT.pak
porsche.2KPVRTC1.pak
porsche.2KETC1.pak
porsche.2KETC2.pak
porsche.2KBC1.pak

****************************************************************************/

enum EPLPakFamily
{
    // Default which works on all OpenGL|ES 2.0 devices
    EPLPF_DEFAULT = 0,          //Max. 2K textures, supported compressoin: none
    // Most suitable for iOS devices
    EPLPF_2KPVRTC1  = 1,          //Max. 2K textures, supported compression: COMPRESSED_RGB_PVRTC_4BPPV1_IMG, COMPRESSED_RGB_PVRTC_2BPPV1_IMG, COMPRESSED_RGBA_PVRTC_4BPPV1_IMG, COMPRESSED_RGBA_PVRTC_2BPPV1_IMG 
    // Note - Textures with alpha are uncompressed (older Mali GPUs)
    EPLPF_2KETC1    = 2,          //Max. 2K textures, supported compression: ETC1_RGB8_OES
    // Mainly for Mali, Vivante GPUs
    EPLPF_2KETC2    = 3,          //Max. 2K textures, supported compression: GL_COMPRESSED_RGB8_ETC2, GL_COMPRESSED_RGBA8_ETC2_EAC
    // Most suitable for Tegra devices
    EPLPF_2KBC1     = 4           //Max. 2K textures, supported compressoin: COMPRESSED_RGB_S3TC_DXT1_EXT, COMPRESSED_RGBA_S3TC_DXT3_EXT, COMPRESSED_RGBA_S3TC_DXT5_EXT
};

/****************************************************************************

The player handles certain images attached to the view.

e.g.
porsche.DEFAULT.pak
porsche.2KPVRTC1.pak
porsche.2KETC1.pak
porsche.2KETC2.pak
porsche.2KBC1.pak

****************************************************************************/

enum EPLImageIDs
{
    EPLII_LOADING = 0,
    EPLII_ERROR,
    EPLII_SCREENSHOT,
    EPLII_MISC
};

enum EPLImageFormat
{
    EPLIF_ARGB8888 = 1
};

enum EPLMatrixType
{
    EPLMT_PROJECTION = 0,
    EPLMT_POSE
};

/****************************************************************************

Event structures

****************************************************************************/

enum EPLEventAction
{
    EPLEA_AD_LOADED = 0,
    EPLEA_AD_CLOSE = 1,    
    EPLEA_GESTURE_TAP = 32
};

typedef void (*EPLEventCallback)(int adHandle, const char *category, const int action, const char *label, void *user);

/****************************************************************************

IOS specific structure to handle touch events into ElbePlayer

****************************************************************************/

struct sIOSPrivateTouchEvent
{
    int taps;
    int x;
    int y;
    unsigned int id;
};

struct sIOSPrivateTouchPackage
{
    int count;
    int timeStamp;
    int mode;
    struct sIOSPrivateTouchEvent events[10];
};

/****************************************************************************

Name:           GetLastErr
Parameter(s):   -
Returns:        Last EPLErrCode
                - EPLEC_NOSYSTEMINIT

Requirement(s): SystemInit

****************************************************************************/

int EPLGetLasErr();


/****************************************************************************

Name:           SystemInit
Parameter(s):   appKey
Returns:        EPLErrCode
                - EPLEC_NULLPOINTER
                - EPLEC_INVALIDKEY  (warning)
                - EPLEC_MULTIPLESYSTEMINITS

Requirement(s): Active graphics context (iOS: OGLES , Android: OGLES, ..)

Note: Please call SystemInit only 1xtime. Once the app gets started.

****************************************************************************/

int EPLSystemInit(const int appKey[4]);


/****************************************************************************

Name:           SystemGetVersion
Parameter(s):   major , minor
Returns:        EPLErrCode
                - EPLEC_NULLPOINTER
                - EPLEC_NOSYSTEMINIT

Requirement(s): SystemInit

****************************************************************************/

int EPLSystemGetVersion(int *major, int *minor);  

/****************************************************************************

Name:           SystemAddSearchDirectory
Parameter(s):   path
Returns:        EPLErrCode
                - EPLEC_NULLPOINTER
                - EPLEC_NOSYSTEMINIT

Requirement(s): SystemInit

****************************************************************************/

int EPLSystemAddSearchDirectory(const char *path);


/****************************************************************************

Name:           SystemExit
Parameter(s):   -
Returns:        -

Requirement(s): Active graphics context (iOS: OGLES , Android: OGLES, ..)

Note: On iOS and Android this function should not be called.

****************************************************************************/

void EPLSystemExit();       


/****************************************************************************

Name:           ViewCreate
Parameter(s):   -
Returns:        -1 = error, >=0 view handle

ErrCodes:       EPLEC_NOSYSTEMINIT

Requirement(s): SystemInit

****************************************************************************/

int EPLViewCreate();


/****************************************************************************

Name:           ViewDelete
Parameter(s):   viewHandle
Returns:        EPLErrCode
                - EPLEC_NOVALIDVIEWHANDLE
                - EPLEC_NOSYSTEMINIT

Requirement(s): SystemInit

****************************************************************************/

int EPLViewDelete(int viewHandle);


/****************************************************************************

Name:           ViewSetActive
Parameter(s):   viewHandle
Returns:        EPLErrCode
                - EPLEC_NOVALIDVIEWHANDLE
                - EPLEC_NOSYSTEMINIT

Requirement(s): SystemInit

****************************************************************************/

int EPLViewSetActive(int viewHandle);


/****************************************************************************

Name:           ViewSetSize
Parameter(s):   viewHandle
                width
                height

Returns:        EPLErrCode
                - EPLEC_NOVALIDVIEWHANDLE
                - EPLEC_NOSYSTEMINIT

Requirement(s): SystemInit

****************************************************************************/

int EPLViewSetSize(int viewHandle, int width, int height);

// returns EPLErrCode
int EPLViewSetGLFrameBuffer(int viewHandle, int glname);

#if EPLTARGET==EPLTARGET_WIN || EPLTARGET==EPLTARGET_IOS
// returns EPLErrCode
int EPLViewOnTouch(int viewHandle, void *native);
#endif

#if EPLTARGET==EPLTARGET_ANDROID
int EPLViewOnTouch(int viewHandle, int pid, int mode, float x, float y);
int EPLViewOnTouchFlush(int viewHandle);
#endif

// returns EPLErrCode
int EPLViewSetImage(int viewHandle, int imageId, void *data, int width, int height, int format);

// returns EPLErrCode
int EPLViewLoadImage(int viewHandle, int imageId, const char *fileName);

// returns EPLErrCode
int EPLPackfileAdd(const char *packFile);

// returns EPLErrCode
int EPLPackfileRemove(const char *packFile);

// -1 = error , >=0 EPLPakFamily
int EPLPackfileGetFamily();

// -1 = error, >=0 view id , 
int EPLAdCreate(const char *wz5);

// returns EPLErrCode
int EPLAdDelete(int adHandle);

// returns EPLErrCode
int EPLAdSetActive(int adHandle);

// returns EPLErrCode
int EPLAdRender();

// returns -1 = error , >= 0 number of trackables
int EPLAdGetNbTrackables(int adHandle);

// null = error , name of trackable
const char *EPLAdGetTrackableName(int adHandle, int trackable);

// returns EPLErrCode
int EPLAdTrackableEnable(int adHandle, int trackable, int enable);

// returns EPLErrCode
int EPLAdSetMatrix(int adHandle, int trackable, const float matrix[16], int type);

// returns EPLErrCode
int EPLEventAddCallback(EPLEventCallback cb, void *user);

// returns EPLErrCode
int EPLEventRemoveCallback(EPLEventCallback cb);

/****************************************************************************/

#ifdef __cplusplus
}
#endif


#endif  // FILE_ELBE_PLAYER_LIB_SHARED_HPP

