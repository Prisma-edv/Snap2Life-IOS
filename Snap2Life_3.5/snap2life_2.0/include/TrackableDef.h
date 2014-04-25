//
//  TrackableDef.h
//  Snap2Life
//
//  Created by prisma on 16.07.12.
//  Copyright (c) 2012 Prisma Gmbh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrackableDef : NSObject

@property (nonatomic, strong) NSString* configHref;
@property (nonatomic, strong) NSString* datHref;
@property (nonatomic, strong) NSMutableArray* models;

@end
