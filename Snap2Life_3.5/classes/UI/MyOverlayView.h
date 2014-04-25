//
//  OverlayView.h
//  Snap2Life
//
//  Created by prisma on 14.06.11.
//  Copyright 2011 Prisma Gmbh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "AppDataObject.h"
#import "S2LProtocols.h"
#import "EAGLView.h"


@interface MyOverlayView : UIView
{
    UISwipeGestureRecognizer *swipeL;
    UISwipeGestureRecognizer *swipeR;
}

/**
 * Resets the Frame and set initial values to variables.
 */
- (void)resetFinderView;


@property (nonatomic,assign) EAGLView *touchDelegate;
@property (nonatomic, unsafe_unretained) id<MyOverlayViewDelegate> delegate;
@property (nonatomic, strong) NSTimer *twoFingersTimer;  
@property CGPoint finger1;
@property CGPoint finger2;
@property CGPoint prevFinger1;
@property CGPoint prevFinger2;
@property bool timerOn;
@property bool shot;
@property NSInteger nFingers;  
@property bool twoFingersTouching;
@property bool crop;
@property bool isSwipe;

-(void)rotateHandler:(UISwipeGestureRecognizer*)swipe;

@end
