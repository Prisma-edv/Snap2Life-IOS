//
//  S2LObjectDef.h
//  Snap2LifeIR
//
//  Created by Antonio Stilo on 02.09.13.
//  Copyright (c) 2013 Prisma-edv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Infos.h"
#import "Featuregroups.h"
#import "Datagroups.h"
#import "Extras.h"

@interface ObjectDef : NSObject

@property (nonatomic, strong) Infos* infos;
@property (nonatomic, strong) Datagroups* datagroups;
@property (nonatomic, strong) Featuregroups* featuregroups;
@property (nonatomic, strong) Extras* extras;

-(NSString*)snapID;

@end
