//
//  UIImage-Extensions.m
//  Snap2Life
//
//  Created by prisma on 14.07.11.
//  Copyright 2011 Prisma Gmbh. All rights reserved.
//

#import "UIImage-Extensions.h"

CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI/180;};
CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};

@implementation UIImage (CS_Extensions)

- (UIImage *)imageAtRect:(CGRect)rect
{
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage* subImage = [UIImage imageWithCGImage: imageRef];
    CGImageRelease(imageRef);
    
    return subImage;
    
}

// Scales an image on the main thread using Core Graphics (drawAtRect:).
// Conflicting Apple documentation recommends the main thread when using a UIGraphicsImageContext.
- (UIImage *)imageByScalingToSize:(CGSize)targetSize {
    // Make a block which will create a sized image of self in a graphics context and retrieve it.
    __block UIImage *newImage = nil;
    void (^sizeImage)(void) = ^{
        UIGraphicsBeginImageContext(targetSize);
        [self drawInRect:CGRectMake(0.0f, 0.0f, targetSize.width, targetSize.height)];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    };
    
    // Execute the block on the main thread, checking if we are already in the main thread.
    if ([NSThread isMainThread]) {
        sizeImage();
    }
    else {
        dispatch_sync(dispatch_get_main_queue(), sizeImage);
    }
    return newImage;
}

// Rotates an image on the main thread using Core Graphics (drawAtRect:).
// Conflicting Apple documentation recommends the main thread when using a UIGraphicsImageContext.
- (UIImage *)imageRotatedByRadians:(CGFloat)radians
{
    // Make a block which will create a rotated image of self in a graphics context and retrieve it.
    __block UIImage *newImage = nil;
    void (^rotateImage)(void) = ^{
        // calculate the size of the rotated view's containing box for our drawing space
        UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.size.width, self.size.height)];
        CGAffineTransform t = CGAffineTransformMakeRotation(radians);
        rotatedViewBox.transform = t;
        CGSize rotatedSize = rotatedViewBox.frame.size;
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize);
        CGContextRef bitmap = UIGraphicsGetCurrentContext();
        
        // Move the origin to the middle of the image so we will rotate and scale around the centre.
        CGContextTranslateCTM(bitmap, rotatedSize.width/2.0f, rotatedSize.height/2.0f);
        
        // Rotate the image context
        CGContextRotateCTM(bitmap, radians);
        
        // Now, draw the rotated/scaled image into the context
        CGContextScaleCTM(bitmap, 1.0f, -1.0f);
        CGContextDrawImage(bitmap,
                           CGRectMake(-self.size.width / 2.0f, -self.size.height / 2.0f, self.size.width, self.size.height),
                           [self CGImage]);
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    };
    
    // Execute the block on the main thread, checking if we are already in the main thread.
    if ([NSThread isMainThread]) {
        rotateImage();
    }
    else {
        dispatch_sync(dispatch_get_main_queue(), rotateImage);
    }
    return newImage;
}

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{
    return [self imageRotatedByRadians:DegreesToRadians(degrees)];
}

- (UIImage *)imageRotateCropAndScale:(Boolean)crop withFinger1:(CGPoint)finger1 withFinger2:(CGPoint)finger2 withOrientation:(UIDeviceOrientation)orientation{
    
    UIImage *image;
    
    //STEP1: Crop if necessary
    if (crop == TRUE){
        //Depening on the orientation
        int screenHeight = 436;
        int screenWidth = 320;
        if(!isIPad){
            //Check if device was rotated
            BOOL rotated = FALSE;
            
            if (!rotated){
                screenHeight = 320;
                screenWidth = 436;
            }
        }else{
            //Depening on the orientation
            screenHeight = 864;
            screenWidth = 768;
            
            //Check if device was rotated
            BOOL rotated = FALSE;
            
            if (!rotated){
                screenHeight = 768;
                screenWidth = 864;
            }
            
        }
        
        //Calculate the ratio
        float pictureHeight = (float) [self size].height;
        float pictureWidth = (float) [self size].width;
        float hCropRatio = (float) (pictureHeight / screenHeight);
        float wCropRatio = (float) (pictureWidth / screenWidth);
        
        //Debug logging
        if (DEBUG_VERBOSE) NSLog(@"picture h/w = %f %f",pictureHeight,pictureWidth);
        if (DEBUG_VERBOSE) NSLog(@"screen h/w = %d %d",screenHeight,screenWidth);
        
        
        //Readapt the coordinates of the fingers
        int x0Adapted = (int) (finger1.x * wCropRatio);
        int y0Adapted = (int) (finger1.y * hCropRatio);
        int x1Adapted = (int) (finger2.x * wCropRatio);
        int y1Adapted = (int) (finger2.y * hCropRatio);
        
        //Calculate de sides of the square
        int widthDiff = x0Adapted - x1Adapted;
        int heightDiff = y1Adapted - y0Adapted;
        //Set the square
        CGRect rect;
        
        rect = CGRectMake(y0Adapted,[self size].height - x0Adapted, heightDiff, widthDiff);
        
        if (DEBUG_VERBOSE) NSLog(@"rec h/w = %f %f x/y = %f %f",rect.size.height,rect.size.width,rect.origin.x,rect.origin.y);
        
        //Crop the image
        CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage],rect);
        //self = nil;
        image = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        
        float croppedHeight = image.size.height;
        float croppedWidth = image.size.width;
        
        
        //Scale the cropped image if its bigger than 400
        if (croppedHeight > 400 || croppedWidth > 400){
            float ratio = 0;
            if (croppedHeight > croppedWidth)
                ratio = 400 / croppedHeight;
            else
                ratio = 400 / croppedWidth;
            
            @autoreleasepool {
                CGSize imageSize = CGSizeMake(croppedWidth*ratio,croppedHeight*ratio);
                image = [image imageByScalingToSize:imageSize];
            }
        }
        
    }else{
        
        // Arbitrary delay for slower iPhones to simiulate the crash occurring on faster ones.
        //[NSThread sleepForTimeInterval:1.7];
        
        // If cropping is not needed, just resize.
        if (self.size.height > 400 || self.size.width > 400){
            float ratio = 0;
            if (self.size.height > self.size.width)
                ratio = 400 / self.size.height;
            else
                ratio = 400 / self.size.width;
            
            @autoreleasepool {
                CGSize imageSize = CGSizeMake(self.size.width*ratio,self.size.height*ratio);
                image = [self imageByScalingToSize:imageSize];
            }
        }else{
            image = self;
        }
    }
    
    // Calculate rotation of the image.
    int rotateDegrees = 0;
    switch (orientation) {
        case UIDeviceOrientationLandscapeLeft:
            rotateDegrees = 0;
            if (DEBUG_VERBOSE) NSLog(@"image orientation: %@ @ %d°", @"UIDeviceOrientationLandscapeLeft", rotateDegrees);
            break;
        case UIDeviceOrientationLandscapeRight:
            rotateDegrees = 180;
            if (DEBUG_VERBOSE) NSLog(@"image orientation: %@ @ %d°", @"UIDeviceOrientationLandscapeRight", rotateDegrees);
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            rotateDegrees = -90;
            if (DEBUG_VERBOSE) NSLog(@"image orientation: %@ @ %d°", @"UIDeviceOrientationPortraitUpsideDown", rotateDegrees);
            break;
        case UIDeviceOrientationPortrait:
            rotateDegrees = 90;
            if (DEBUG_VERBOSE) NSLog(@"image orientation: %@ @ %d°", @"UIDeviceOrientationPortrait", rotateDegrees);
            break;
        case UIDeviceOrientationFaceUp:
            rotateDegrees = 90;
            if (DEBUG_VERBOSE) NSLog(@"image orientation: %@ @ %d°", @"UIDeviceOrientationFaceUp", rotateDegrees);
            break;
        case UIDeviceOrientationFaceDown:
            rotateDegrees = -90;
            if (DEBUG_VERBOSE) NSLog(@"image orientation: %@ @ %d°", @"UIDeviceOrientationFaceDown", rotateDegrees);
            break;
        default:
            if (DEBUG_VERBOSE) NSLog(@"unknown orientation with value: %d", rotateDegrees);
            break;
    }
    
    if (rotateDegrees != 0) {
        @autoreleasepool {
            image = [image imageRotatedByDegrees:rotateDegrees];
        }
    }
    
    if (DEBUG_VERBOSE) NSLog(@"scaled image %f x %f", image.size.width, image.size.height);
    
    return image;
}

@end;
