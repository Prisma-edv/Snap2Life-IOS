//
//  S2LGPSHistoryView.m
//  snap2life suite
//
//  Created by iOS on 04.12.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "S2LGPSHistoryView.h"
#import "UIImage-Extensions.h"

@implementation S2LGPSHistoryView
@synthesize history,y,bearing;

-(void)build:(History*)_history
{
    self.backgroundColor = [UIColor clearColor];
    history = _history;
    UIImageView *snap = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 66, 66)];
    UIImage *cropped = [[UIImage imageWithData:history.snapImage] imageByScalingToSize:CGSizeMake(100, 100)];
    snap.image = [self maskImage:cropped withMask:[UIImage imageNamed:@"mask.png"]];
    [self addSubview:snap];

}

-(void)move:(CGPoint)loc
{
   // xx -= (xx-loc.x)/24;
    self.frame = CGRectMake(loc.x,loc.y, 66, 66);

}

- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
    
    CGImageRef maskRef = maskImage.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef maskedImageRef = CGImageCreateWithMask([image CGImage], mask);
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedImageRef];
    
    CGImageRelease(mask);
    CGImageRelease(maskedImageRef);
    
    // returns new image with mask applied
    return maskedImage;
}

@end
