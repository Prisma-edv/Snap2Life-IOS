//
//  S2LRestore.h
//  snap2life suite
//
//  Created by iOS on 10.12.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^restoreCompleteBlock_t)(NSDictionary *dict);
typedef void (^restoreErrorBlock_t)();

@interface S2LRestore : NSObject

@property (nonatomic,copy)restoreCompleteBlock_t compleateBlock;
@property (nonatomic,copy)restoreErrorBlock_t errorBlock;

-(void)restoreProfile:(restoreCompleteBlock_t)compleate error:(restoreErrorBlock_t)error;
+ (S2LRestore *)sharedInstance;

@end
