//
//  Error.h
//  Snap2Life
//
//  Created by prisma on 06.09.11.
//  Copyright 2011 Prisma Gmbh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fields.h"
#import "Field.h"
#import "Action.h"

@interface ErrorDef : NSObject

@property (nonatomic, strong) Fields* fields;

@end
