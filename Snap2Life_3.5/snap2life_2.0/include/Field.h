//
//  Field.h
//  Snap2Life
//
//  Created by prisma on 06.09.11.
//  Copyright 2011 Prisma Gmbh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Actions.h"

@interface Field : NSObject 

@property (nonatomic, strong) Actions* actions;
@property (nonatomic, strong) NSString* msg;

@end
