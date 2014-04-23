//
//  RequestUtils.h
//  Snap2Life
//
//  Created by prisma on 01.09.11.
//  Copyright 2011 Prisma Gmbh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectDef.h"
#import "Constants.h"
#import "AppDataObject.h"
#import "SerializerAPI2.h"

/**
 * Class containing static utility methods to build the requests more easily.
 */
@interface RequestUtils : NSObject {
    
}

+ (ObjectDef*) buildRequestObjDefForSubcategory:(NSString *)subcat withAppDataObject:(AppDataObject*)ado withImageName:(NSString*)imageName withEmail:(NSString*)_email;

/**
 * Static method to generate an ObjDef instance ready to be used to make a request
 */
+ (ObjectDef*) buildRequestObjDefForSubcategory:(NSString *)subcat withImageName:(NSString *)imgName withImei:(NSString *)deviceUDID withGps:(NSString *)coords withHAcc:(NSString *)hAcc withOsVer:(NSString *)osVer withModel:(NSString*)model withAppId:(NSString*)appId withAppVersion:(NSString*)appVersion withDeviceName:(NSString *)deviceName withWas2fs:(BOOL)was2fs withRequestGroupId:(NSString*) requestGroupId withAppDataObject:(AppDataObject*)ado;

/**
 * Static method to generate an ObjDef instance for insert into the snap2life database
 */
+ (ObjectDef*)buildRequestObjDefForInsertWithTitle:(NSString*)title withSubcatcategory:(NSString *)subcat withLinkName:(NSString *)linkName withUrl:(NSString *)linkUrl withAdLink:(BOOL)withAdLink;

// Transforms an ISO 8601 string of the form "2012-12-24T16:28:29" to an NSDate.
+ (NSDate*)dateFromIsoString:(NSString*)isoString;

// Transforms an NSDate to an ISO 8601 string of the form "2012-12-24T16:28:29".
+ (NSString*)isoStringFromDate:(NSDate*)date;

@end
