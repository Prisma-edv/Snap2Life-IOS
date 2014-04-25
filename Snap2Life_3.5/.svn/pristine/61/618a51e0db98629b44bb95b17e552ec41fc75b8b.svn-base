//
//  S2LAppManager.m
//  snap2life suite
//
//  Created by Antonio Stilo on 01.10.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "S2LAppManager.h"

@implementation S2LAppManager

+ (S2LAppManager *)sharedClient
{
    static S2LAppManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[S2LAppManager alloc] init];
    });
    
    return _sharedClient;
}

@end
