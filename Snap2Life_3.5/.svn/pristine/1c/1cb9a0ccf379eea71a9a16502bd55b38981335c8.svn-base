//
//  Button+properties.m
//  Snap2Life
//
//  Created by prisma on 08.09.11.
//  Copyright 2011 Prisma Gmbh. All rights reserved.
//

#import "Button+properties.h"
#import <objc/runtime.h>

@implementation UIButton(Property)

static char UIB_PROPERTY_KEY;

@dynamic buttonUrl;

-(void)setButtonUrl:(NSObject *)buttonUrl
{
    objc_setAssociatedObject(self, &UIB_PROPERTY_KEY, buttonUrl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSObject*)buttonUrl
{
    return (NSObject*)objc_getAssociatedObject(self, &UIB_PROPERTY_KEY);
}


@end
