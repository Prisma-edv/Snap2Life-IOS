/*==============================================================================
Copyright (c) 2010-2013 QUALCOMM Austria Research Center GmbH .
All Rights Reserved.
Qualcomm Confidential and Proprietary
==============================================================================*/

#import "AR_EAGLView.h"
#import "TrackableResult.h"
#import "Marker.h"
#import "MarkerResult.h"
#import "Image.h"
#import "Renderer.h"
#import "S2LARDelegate.h"
#import "ObjectManager.h"
#import "QCARmodel.h"


// This class wraps the CAEAGLLayer from CoreAnimation into a convenient UIView
// subclass.  The view content is basically an EAGL surface you render your
// OpenGL scene into.  Note that setting the view non-opaque will only work if
// the EAGL surface has an alpha channel.
@interface EAGLView : AR_EAGLView
{
    GLuint vbShaderProgramID;
    GLint vbVertexHandle;
    
    CGFloat angleValue;
    CGFloat rotationValue;
    
    NSString *oldPackFile;
    

    
}

@property (nonatomic) BOOL isRunning;

@property (nonatomic,strong) NSArray *imageTargetNames;
@property (nonatomic,assign) id<S2LARDelegate> arDelegate;
@property (nonatomic,assign) float angle;
@property (nonatomic,assign) BOOL isAR;
@property (nonatomic,assign) AR::ObjectManager* arObjectManager;

//- (void) updateButtonState:(int)newState;
- (void) postInitQCAR;
- (void) initShaders;

-(UIImage*)getSnap;
-(void)setFalsh:(BOOL)isFlash;
-(void)touch:(CGPoint)loc;
-(void)swipe:(CGFloat)value;
-(void)updateObjectManager:(NSString*)filePath;
-(void)updateObjectManagerWithPAK:(NSString *)filePath model:(QCARmodel*)model;
-(void)flushData;
-(void)deleteDataSet;

@end
