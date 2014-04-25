//
//  ARPackageDef.h
//  Snap2Life
//
//  Created by prisma on 16.07.12.
//  Copyright (c) 2012 Prisma Gmbh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrackableDef.h"

@interface ARPackageDef : NSObject

@property (nonatomic, strong) NSString* key;
@property (nonatomic, strong) NSString* version;
@property (nonatomic, strong) TrackableDef* trackable;

@end
