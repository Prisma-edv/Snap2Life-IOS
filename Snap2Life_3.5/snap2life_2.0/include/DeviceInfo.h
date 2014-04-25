//
//  S2LDeviceInfo.h
//  Snap2LifeIR
//
//  Created by Antonio Stilo on 02.09.13.
//  Copyright (c) 2013 Prisma-edv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInfo : NSObject

@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *hAcc;
@property (nonatomic, strong) NSString *gpsCompleteString;
@property (nonatomic, strong) NSString *deviceId;
@property (nonatomic, strong) NSString *locale;
@property (nonatomic, strong) NSString *osVersion;
@property (nonatomic, strong) NSString *model;
@property NSInteger modelInteger;
@property (nonatomic, strong) NSString *appVersion;
@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSString *deviceName;

@end
