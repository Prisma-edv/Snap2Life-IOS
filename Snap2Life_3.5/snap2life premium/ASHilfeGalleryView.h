//
//  ASHilfeGalleryView.h
//  snap2life suite
//
//  Created by Antonio Stilo on 07.02.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASHilfeGalleryView : UIView
{
    UIImageView *_imageView;
    UILabel *_title;
    UILabel *_description;
}

- (id)initWithFrame:(CGRect)frame andAttributes:(NSDictionary*)attributes;
-(void)buildToInterfaceOrientation:(UIInterfaceOrientation)orientation;

@end
