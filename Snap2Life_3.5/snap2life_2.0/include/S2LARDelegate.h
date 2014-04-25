//
//  S2LARDelegate.h
//  S2LAR_IOS_1.0
//
//  Created by Antonio Stilo on 18.09.13.
//  Copyright (c) 2013 prisma-edv. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QCARVirtualButtonDef;

@protocol S2LARDelegate <NSObject>

@optional
/*! called when the OpenGL view finished the initialization */
-(void)initARView;
/*! called when the OpenGL view it's dismissed */
-(void)finishARView;
/*! called when the OpenGL view finsihed to load the AR Package */
-(void)finishLoadDataSet;
/*! called at any frame if Vuforia detect a trackable */
-(void)renderARFrame:(NSString*)trackableName andIndex:(NSInteger)index;
/*! called at any frame if Vuforia don't find a trackable*/
-(void)renderNotFound;
/*! called if a 3D virtual button is pressed */
-(void)virtualButtonIsPressed:(QCARVirtualButtonDef*)button;

@end
