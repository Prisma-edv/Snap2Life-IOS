//
//  S2LMenuView.m
//  snap2life suite
//
//  Created by Antonio Stilo on 18.11.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "S2LMenuView.h"

@implementation S2LMenuView
@synthesize parentFrame;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
 
    }
    return self;
}

-(void)setParentFrame:(CGRect)_parentFrame
{
    isOpen = YES;
    parentFrame = _parentFrame;
    if(isIPad)
    {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            closePosition = 980;
            openPosition = 888;
        }else{
            closePosition = 960;
            openPosition = 868;
        
        }
    }else{
        closePosition = parentFrame.size.height - 44;
        openPosition = parentFrame.size.height - self.frame.size.height;
    }
    //self.frame = CGRectMake(self.frame.origin.x, closePosition, self.frame.size.width, self.frame.size.height);
    [self openHandler:nil];
}

-(void)animate:(CGFloat)yPosition
{
    [UIView animateWithDuration:0.4 animations:^{
        self.frame = CGRectMake(self.frame.origin.x, yPosition, self.frame.size.width, self.frame.size.height);
    }];
    
}

-(IBAction)openHandler:(id)sender
{
    
    if (isOpen) {
        [self animate:closePosition];
    }else{
        [self animate:openPosition];
    }
    
    isOpen = !isOpen;

}

@end
