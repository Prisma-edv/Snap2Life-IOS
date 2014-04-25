//
//  S2LAppDataObject.h
//  Snap2LifeIR
//
//  Created by Antonio Stilo on 02.09.13.
//  Copyright (c) 2013 Prisma-edv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "S2LCoreLocationController.h"
#import "ObjectDef.h"
#import "DeviceInfo.h"
#import "IRConstants.h"
#import "ErrorDef.h"

//Define constants
#define kSTATE_READY 0;
#define kSTATE_LOAD 1;
#define kSTATE_SHOW 2;
#define kSTATE_ERROR 3;


typedef enum {
    MODEL_UNKNOWN = -1,
    MODEL_SIMULATOR = 0,
    MODEL_IPHONE_3G = 1,
    MODEL_IPHONE_3GS = 2,
    MODEL_IPHONE_4 = 3,
    MODEL_IPHONE_4S = 4,
    MODEL_IPAD_1 = 5,
    MODEL_IPAD_2 = 6,
    MODEL_IPOD_1 = 7,
    MODEL_IPOD_2 = 8,
    MODEL_IPOD_3 = 9,
    MODEL_IPOD_4 = 10,
    MODEL_IPHONE_5 = 11,
    MODEL_IPAD_3 = 12
}MODEL_TYPE;

@interface AppDataObject : NSObject <S2LCoreLocationControllerDelegate>

@property (nonatomic,strong) S2LCoreLocationController *gpsController;
@property (nonatomic, strong) NSData* capturedData;
@property (nonatomic, strong) NSObject* requestResult;
@property (nonatomic, strong) DeviceInfo *deviceInfo;
@property (nonatomic) BOOL is2FS;
@property (nonatomic) BOOL isSSL;
@property NSInteger state;

/**
 Initialize DeviceInfo instance so it is available for other instances along the app
 */
- (void)initDeviceInfoWithSettingDeviceID;

/**
 Receive the actual GPS position and sets the variables that will be used once
 a request is done.
 */
- (void)locationUpdate:(CLLocation *)location;

/**
 Error retrieving the GPS position.
 */
- (void)locationError:(NSError *)error;

/**
 Returns the integer representing the model of the device
 */
- (NSInteger) getDeviceModelInteger;

-(void)locationStop;
-(void)locationStart;

@end
