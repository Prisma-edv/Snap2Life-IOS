//
//  ASHilfeGalleryView.m
//  snap2life suite
//
//  Created by Antonio Stilo on 07.02.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "ASHilfeGalleryView.h"

@implementation ASHilfeGalleryView

- (id)initWithFrame:(CGRect)frame andAttributes:(NSDictionary*)attributes
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *image = [UIImage imageNamed:[attributes objectForKey:@"image"]];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        _imageView.image = image;
        [self addSubview:_imageView];
        
        _title = [[UILabel alloc] initWithFrame:CGRectMake(40, 180, 260, 30)];
        _title.font = [UIFont boldSystemFontOfSize:14];
        _title.text = [attributes objectForKey:@"title"];
        _title.backgroundColor = [UIColor clearColor];
        [self addSubview:_title];
        
        _description = [[UILabel alloc] initWithFrame:CGRectMake(40, 210, 200, 160)];
        _description.font = [UIFont systemFontOfSize:12];
        _description.text = [attributes objectForKey:@"description"];
        _description.backgroundColor = [UIColor clearColor];
        _description.numberOfLines = 6;
        [self addSubview:_description];
        
    }
    return self;
}

-(void)buildToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if(!isIPad){
        if (UIInterfaceOrientationIsPortrait(orientation)) {
            int offsetY = -20;
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                offsetY = 0;
            }
            _imageView.frame = CGRectMake(0, offsetY, _imageView.frame.size.width, _imageView.frame.size.height);
            _title.frame = CGRectMake(40, 240, 260, 30);
            _description.frame = CGRectMake(40, 230, 200, 160);
        }else{
            _imageView.frame = CGRectMake(0, -40, _imageView.frame.size.width, _imageView.frame.size.height);
            _title.frame = CGRectMake(258, 40, 200, 30);
            _description.frame = CGRectMake(258, 30, 200, 160);
        }
    }else{
        _imageView.frame = CGRectMake(0, 0, _imageView.frame.size.width, _imageView.frame.size.height);
        _title.frame = CGRectMake(_imageView.frame.size.width-60, 60, 300, 30);
        _description.frame = CGRectMake(_imageView.frame.size.width-60, 60, 300, 160);
    }

}

@end
