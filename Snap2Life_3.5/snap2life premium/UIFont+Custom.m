//
//  UIFont+Custom.m
//  snap2life suite
//
//  Created by iOS on 20.02.14.
//  Copyright (c) 2014 Prisma Gmbh. All rights reserved.
//

#import "UIFont+Custom.h"
#import <objc/runtime.h>

@implementation UIFont (Custom)

+(UIFont *)regularFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"DIN Alternate" size:size];
}

+(UIFont *)boldFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"DINAlternate-Bold" size:size];
}

+(void)load
{
    SEL original = @selector(systemFontOfSize:);
    SEL modified = @selector(regularFontWithSize:);
    SEL originalBold = @selector(boldSystemFontOfSize:);
    SEL modifiedBold = @selector(boldFontWithSize:);
    
    Method originalMethod = class_getClassMethod(self, original);
    Method modifiedMethod = class_getClassMethod(self, modified);
    method_exchangeImplementations(originalMethod, modifiedMethod);
    
    Method originalBoldMethod = class_getClassMethod(self, originalBold);
    Method modifiedBoldMethod = class_getClassMethod(self, modifiedBold);
    method_exchangeImplementations(originalBoldMethod, modifiedBoldMethod);

}

@end
