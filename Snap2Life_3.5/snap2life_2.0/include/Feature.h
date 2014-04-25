//
//  Feature.h
//  Snap2LifeIR
//
//  Created by Antonio Stilo on 02.09.13.
//  Copyright (c) 2013 Prisma-edv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Feature : NSObject

@property (nonatomic, strong) NSString* name;
@property int id;
@property int type;
@property (nonatomic, strong) NSString* value;
@property int tolerance;
@property int order;

@end
