//
//  S2LRegister.h
//  snap2life suite
//
//  Created by Robin Kolze on 09/12/13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFS2LAppAPIClient.h"


typedef enum
{
    kRegisterCheck,
    kRegisterSecret,
    kRegisterAvatar,
    kRegisterProfile,
    kRegisterReady
    
} S2LRegisterStatus;

typedef void (^checkBlock_t)(UIImage* img);
typedef void (^completeBlock_t)();
typedef void (^errorBlock_t)();

@interface S2LRegister : NSObject

@property (nonatomic)S2LRegisterStatus status;
@property (nonatomic,copy)completeBlock_t compleateBlock;
@property (nonatomic,copy)errorBlock_t errorBlock;

+ (S2LRegister *)sharedInstance;
-(void)sendSecret;
-(void)checkAvatar:(checkBlock_t)checkBlock;

@end
