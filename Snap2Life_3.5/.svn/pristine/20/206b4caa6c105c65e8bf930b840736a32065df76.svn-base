//
//  PurchaseAlert.m
//  snap2life suite
//
//  Created by Antonio Stilo on 29.08.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "PurchaseAlert.h"

@implementation PurchaseAlert
@synthesize item;

-(void)layoutSubviews
{
    
    NSLog(@"--- PurchaseAlert ---");
    int index = 0;
    for (UIView *v in self.subviews) {
        NSLog(@"AlertView: %i --------------",index);
        if ([v isKindOfClass:[UILabel class]]) {
            NSLog(@"is Label");
        }else if ([v isKindOfClass:[UIButton class]]) {
            NSLog(@"is button");
        }
        NSLog(@"---------------------");
        
        index++;
    }

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
