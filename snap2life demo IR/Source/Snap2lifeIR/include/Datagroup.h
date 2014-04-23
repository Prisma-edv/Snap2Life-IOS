//
//  Datagroup.h
//  Snap2LifeIR
//
//  Created by Antonio Stilo on 02.09.13.
//  Copyright (c) 2013 Prisma-edv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Datagroup : NSObject

@property (nonatomic, strong) NSMutableArray* data;
@property int id;
@property BOOL border;
@property (nonatomic, strong) NSString* img;
@property BOOL visible;

@end
