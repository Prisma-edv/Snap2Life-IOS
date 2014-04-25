//
//  Settings.h
//  snap2life suite
//
//  Created by prisma on 22.03.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Settings : NSManagedObject

@property (nonatomic, retain) NSString * packageDownloadURL;
@property (nonatomic, retain) NSNumber * setting2FS;
@property (nonatomic, retain) NSNumber * settingAR;
@property (nonatomic, retain) NSNumber * settingCircleConnect;
@property (nonatomic, retain) NSString * settingDeviceID;
@property (nonatomic, retain) NSNumber * settingGPS;
@property (nonatomic, retain) NSNumber * settingHistory;
@property (nonatomic, retain) NSNumber * settingPutOption;
@property (nonatomic, retain) NSNumber * settingSound;
@property (nonatomic, retain) NSNumber * settingBrowser;
@property (nonatomic,retain) NSNumber * historyExpiring;
@property (nonatomic,retain) NSDate *expiringDate;

@end
