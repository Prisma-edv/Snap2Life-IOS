//
//  OverlayView.m
//  Snap2Life
//
//  Created by prisma on 14.06.11.
//  Copyright 2011 Prisma Gmbh. All rights reserved.
//

#import "MyOverlayView.h"
#import "S2LIRRequestMaker.h"
#import "S2LProtocols.h"
#import "PersistenceManager.h"


@implementation MyOverlayView

@synthesize finger1,finger2,twoFingersTouching,nFingers,shot,
prevFinger1,prevFinger2,delegate,crop,twoFingersTimer,timerOn,touchDelegate,isSwipe;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        if (SWAP_TO_ROTATE_AR) {
            swipeL = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rotateHandler:)];
            swipeL.direction = UISwipeGestureRecognizerDirectionLeft;
            [self addGestureRecognizer:swipeL];
            
            swipeR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rotateHandler:)];
            swipeR.direction = UISwipeGestureRecognizerDirectionRight;
            [self addGestureRecognizer:swipeR];
        }

    }
    
    [self resetFinderView];
    
    return self;
}

#pragma mark - View Lifecycle

/**
 * Resets the Frame and set initial values to variables.
 */
- (void)resetFinderView
{
    twoFingersTouching = FALSE;
    shot = FALSE;
    crop = FALSE;
    nFingers = 0;
    [self setNeedsDisplay];

}


-(void)rotateHandler:(UISwipeGestureRecognizer*)swipe
{
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft){
        [touchDelegate swipe:-60];
    
    }else if (swipe.direction == UISwipeGestureRecognizerDirectionRight){
        [touchDelegate swipe:60];
    }
}

- (void)drawRect:(CGRect)rect {
    
    if (!isSwipe) {
        //Get the CGContext from this view
        CGContextRef context = UIGraphicsGetCurrentContext();
        //Set the stroke (pen) color
        CGContextSetStrokeColorWithColor(context, UIColorFromRGB(MAIN_COLOR,0.5).CGColor);
        //Set the width of the pen mark
        CGContextSetLineWidth(context, 2.0);
        
        if (twoFingersTouching || shot == TRUE){
            
            //Start at this point
            CGContextMoveToPoint(context,finger1.x,finger1.y);
            
            //Give instructions to the CGContext
            //(move "pen" around the screen)
            CGContextAddLineToPoint(context, finger1.x, finger2.y);
            CGContextAddLineToPoint(context, finger2.x, finger2.y);
            CGContextAddLineToPoint(context, finger2.x, finger1.y);
            CGContextAddLineToPoint(context, finger1.x,finger1.y);
            
            //Draw it
            CGContextStrokePath(context);
            
            //Draw a rectangle
            CGContextSetFillColorWithColor(context, UIColorFromRGB(SEC_COLOR_2,0.5).CGColor);
            //Define a rectangle
            CGContextAddRect(context, CGRectMake(0,0,finger2.x,self.frame.size.height));
            CGContextAddRect(context, CGRectMake(finger1.x,0,self.frame.size.width,self.frame.size.height));
            CGContextAddRect(context, CGRectMake(finger2.x,finger2.y,finger1.x,self.frame.size.height));
            CGContextAddRect(context, CGRectMake(finger2.x,0,finger1.x,finger1.y));
            //Draw it
            CGContextFillPath(context);
            
            //Draw it
            CGContextStrokePath(context);
            
        }else{
            /* // Draw a line
             //Start at this point
             CGContextMoveToPoint(context, 10.0, 10.0);
             
             //Give instructions to the CGContext
             //(move "pen" around the screen)
             CGContextAddLineToPoint(context, self.frame.size.width-10, 10.0);
             CGContextAddLineToPoint(context, self.frame.size.width-10, self.frame.size.height-75);
             CGContextAddLineToPoint(context, 10.0, self.frame.size.height-75);
             CGContextAddLineToPoint(context, 10.0, 10.0);
             
             //Draw it
             CGContextStrokePath(context);
             */
        }

    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
   
    
    if (shot) return;
    
    
    //Store finger points
    for (UITouch *touch in touches) {
        if (nFingers < 2){
            CGPoint location = [touch locationInView:self];
            if (nFingers == 0){
                finger1 = location;
            }else{
                finger2 = location;
            }
        }
    }
    
    nFingers += [touches count];
    if (nFingers<0) nFingers=0;
    
    PersistenceManager *pm = [PersistenceManager sharedInstance];
    if (!isSwipe && nFingers==2 && [pm.settings.setting2FS boolValue]){
        
        NSLog(@"**** ***** ****** ****** nFingers 2");
        twoFingersTouching = TRUE;
        
        //refresh view
        [self setNeedsDisplay];
    }else{
        NSLog(@"TOUCH LOCATION %1.2f %1.2f",finger1.x,finger1.y);
        [touchDelegate touch:finger1];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    

    PersistenceManager *pm = [PersistenceManager sharedInstance];
    if (![[pm.settings setting2FS] boolValue]) {
        return;
    }
    
    NSLog(@"************ isSwipe %d",isSwipe);
    if (shot || isSwipe) return;
    
    if (twoFingersTouching) {
        
        //Retrieve the points
        int i = 0;
        for (UITouch *touch in touches) {
            CGPoint location = [touch locationInView:self];
            if (i == 0){
                finger1.x = location.x;
                finger1.y = location.y;
            }else{
                finger2.x = location.x;
                finger2.y = location.y;
            }
            i++;
        }
        
        //Adjust values
        if (finger2.x > finger1.x){
            float swap = finger1.x;
            finger1.x = finger2.x;
            finger2.x = swap;
        }
        if (finger2.y < finger1.y){
            float swap = finger1.y;
            finger1.y = finger2.y;
            finger2.y = swap;
        }
        
        //finger1 = finger1;
        //finger2 = finger2;
        
        int sideWith = finger1.x - finger2.x;
        int sideHeight = finger2.y - finger1.y;
        
        if (sideWith < MIN_SIDE){
            finger1.x = prevFinger1.x;
            finger2.x = prevFinger2.x;
        }
        
        if (sideHeight < MIN_SIDE){
            finger1.y = prevFinger1.y;
            finger2.y = prevFinger2.y;
        }
        
        prevFinger1 = finger1;
        prevFinger2 = finger2;
        
        //
        NSString *nTouches = [NSString stringWithFormat:@"Finger 1: %f,%f Finger 2: %f,%f With: %d, Height %d",finger1.x,finger1.y,finger2.x,finger2.y,sideWith,sideHeight];
        if (DEBUG_VERBOSE) NSLog(@"%@",nTouches);
        
        //refresh view
        [self setNeedsDisplay];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    PersistenceManager *pm = [PersistenceManager sharedInstance];
    if (![[pm.settings setting2FS] boolValue]) {
        return;
    }
    if (shot || isSwipe) return;
    //NSString *nTouches = [NSString stringWithFormat:@"%d",[touches count]];
    //NSLog(nTouches);
    
    //Detect if its a "snap" gesture
    if (nFingers == 2 && ([touches count]==2)){
        crop = TRUE;
        shot = TRUE;
        [(id<MyOverlayViewDelegate>)delegate handleTwoFingersSnap];
    }
    
    nFingers -= [touches count];
    
    //If one finger was released, we trigger timer to check if the second finger was
    //released after a max time-window of 0.3 secs
    if (nFingers==1){
        timerOn = TRUE;
        twoFingersTimer = [NSTimer scheduledTimerWithTimeInterval:.3 target:self selector:@selector(twoFingersTimerOff) userInfo:nil repeats:NO];
    }
    
    if (nFingers == 0 && ([touches count] == 1) && timerOn == TRUE){
        crop = TRUE;
        shot = TRUE;
        [(id<MyOverlayViewDelegate>)delegate handleTwoFingersSnap];
    }
    
    if (nFingers!=2) twoFingersTouching = FALSE;

}

-(void)twoFingersTimerOff
{
    timerOn = FALSE;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    if (DEBUG_VERBOSE) NSLog(@"touchesCancelled");
}

@end
