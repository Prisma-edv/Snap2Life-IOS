//
//  S2LCoreLocationControllerDelegate.h
//  Snap2LifeIR
//
//  Created by Antonio Stilo on 02.09.13.
//  Copyright (c) 2013 Prisma-edv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol S2LCoreLocationControllerDelegate
@optional

- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;
- (void)locationHead:(CLHeading*)head onLocation:(CLLocation*)location;

@end


@interface S2LCoreLocationController : NSObject <CLLocationManagerDelegate>
{
    CLLocation *currentLocation;
    BOOL isFirstLocation;
}


@property (nonatomic, strong) CLLocationManager *locManager;
@property (nonatomic, unsafe_unretained) id delegate;
@property (nonatomic, unsafe_unretained) id<S2LCoreLocationControllerDelegate> headDelegate;


@end
