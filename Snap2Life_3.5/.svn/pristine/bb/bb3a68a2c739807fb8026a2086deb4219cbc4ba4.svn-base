//
//  FlashView.m
//  Snap2Life
//
//  Created by prisma on 15.06.11.
//  Copyright 2011 Prisma Gmbh. All rights reserved.
//

#import "FlashView.h"


@implementation FlashView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
	//Get the CGContext from this view
	CGContextRef context = UIGraphicsGetCurrentContext();
    //Draw a rectangle
    CGContextSetFillColorWithColor(context, UIColorFromRGB(SEC_COLOR_1,1.0).CGColor);
    //Define a rectangle
    CGContextAddRect(context, CGRectMake(0,0,320,480));
    //Draw it
    CGContextStrokePath(context);
}


@end
