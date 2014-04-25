//
//  S2LShearPopView.m
//  snap2life3.5
//
//  Created by iOS on 04.04.14.
//  Copyright (c) 2014 Prisma Gmbh. All rights reserved.
//

#import "S2LShearPopView.h"
#import "Constants.h"

@implementation S2LShearPopView
@synthesize parent,image;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        shearFB = [UIButton buttonWithType:UIButtonTypeCustom];
        shearFB.frame = CGRectMake(6, 6, 260, 44);
        [shearFB addTarget:self action:@selector(shearFBHandler) forControlEvents:UIControlEventTouchUpInside];
        [shearFB setTitle:@"shear on facebook" forState:UIControlStateNormal];
        [shearFB setStyle];
        [self addSubview:shearFB];
        
        shearTW = [UIButton buttonWithType:UIButtonTypeCustom];
        shearTW.frame = CGRectMake(6, 58, 260, 44);
        [shearTW addTarget:self action:@selector(shearTWHandler) forControlEvents:UIControlEventTouchUpInside];
        [shearTW setTitle:@"shear on twitter" forState:UIControlStateNormal];
        [shearTW setStyle];
        [self addSubview:shearTW];
    }
    return self;
}

-(void)shearFBHandler
{
    [S2LNavigationUtils shearOnFaceBook:image fromViewController:parent];
}

-(void)shearTWHandler
{
    [S2LNavigationUtils shearOnTweeter:image fromViewController:parent];
}

@end
