//
//  ASPageGalleryView.m
//  snap2life suite
//
//  Created by Antonio Stilo on 12.03.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "ASPageGalleryView.h" 

@implementation ASPageGalleryView
@synthesize imageView;

- (id)initWithFrame:(CGRect)frame andData:(NSDictionary*)data
{
    self = [super initWithFrame:frame];
    if (self) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
        imageView.image = [UIImage imageWithContentsOfFile:[data objectForKey:@"href"]];
        [self addSubview:imageView];
    }
    return self;
}

-(void)buildToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
}

@end
