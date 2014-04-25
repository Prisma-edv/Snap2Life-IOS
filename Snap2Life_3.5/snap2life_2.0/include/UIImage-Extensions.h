//
//  UIImage-Extensions.h
//  Snap2Life
//
//  Created by prisma on 14.07.11.
//  Copyright 2011 Prisma Gmbh. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "Constants.h"

@interface UIImage (CS_Extensions)
- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
- (UIImage *)imageRotateCropAndScale:(Boolean)crop withFinger1:(CGPoint)finger1 withFinger2:(CGPoint)finger2 withOrientation:(UIDeviceOrientation)orientation;
@end;
