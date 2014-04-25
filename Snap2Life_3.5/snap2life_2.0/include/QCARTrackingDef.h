//
//  QCARTrackingDef.h
//  S2LAR_IOS_1.0
//
//  Created by Antonio Stilo on 23.09.13.
//  Copyright (c) 2013 prisma-edv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCARTrackingDef : NSObject

@property (nonatomic,copy) NSString *key;
@property (nonatomic,copy) NSString *version;
@property (nonatomic,copy) NSString *config;
@property (nonatomic,copy) NSString *dat;
@property (nonatomic,strong) NSMutableArray *imageTargets;

@end
