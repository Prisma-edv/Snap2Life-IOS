/*==============================================================================
 Copyright (c) 2010-2013 QUALCOMM Austria Research Center GmbH.
 All Rights Reserved.
 Qualcomm Confidential and Proprietary
 ==============================================================================*/

#import <UIKit/UIKit.h>
#import "S2LARDelegate.h"
#import "ARpackage.h"

@class EAGLView, QCARutils;

@interface ARViewController : UIViewController {
@public
    IBOutlet EAGLView *arView;  // the Augmented Reality view
    CGSize arViewSize;          // required view size

@protected
    QCARutils *qUtils;          // QCAR utils singleton class
@private
    UIView *parentView;         // Avoids unwanted interactions between UIViewController and EAGLView
    NSMutableArray* textures;   // Teapot textures
    BOOL arVisible;             // State of visibility of the view
}

/*! This is a 3D Opengl View */
@property (nonatomic, retain) IBOutlet EAGLView *arView;
/*! arDelegate responds to the protocol S2LARDelegate and manage all the callbacks for the AR state of the view */
@property (nonatomic,assign) id<S2LARDelegate> arDelegate;
/*! CGSize for the opengl view */
@property (nonatomic) CGSize arViewSize;
/*! a BOOL value if AR global setting is YES or NO */
@property (nonatomic) BOOL isAR;

/*! this method rotate and move the opengl view call this method in -(void)viewWillLayoutSubviews iOs 6+ to handle the portrait or landscape screen*/
- (void) handleARViewRotation:(UIInterfaceOrientation)interfaceOrientation;
/*! it free the ram from OpenGL resource */
- (void)freeOpenGLESResources;
/*! load and change the selected package for the 3D objects*/
-(void)loadPackage:(ARpackage*)package;
/*! call this method to produce an UIImage of the camera (snap) */
-(UIImage*)getSnap;
/*! toggle the hadware flash */
-(void)setFalsh:(BOOL)isFlash;

/*! constructor method */
-(id)initWithSize:(CGSize)size;
/*! if pause resume the camera */
-(void)resumeCamera;
-(void)pauseCamera;

@end
