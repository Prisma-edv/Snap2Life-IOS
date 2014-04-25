//
//  RequestUtils.m
//  Snap2Life
//
//  Created by prisma on 01.09.11.
//  Copyright 2011 Prisma Gmbh. All rights reserved.
//

#import "RequestUtils.h"
#import "PersistenceManager.h"
#import "Datagroup.h"
#import "Featuregroup.h"
#import "Feature.h"
#import "Extra.h"
#import "Data.h"
#import "IRConstants.h"
#import "History.h"

/**
 * Class containing static utility methods to build the requests more easily.
 */
@implementation RequestUtils

/**
 * Static method to generate an ObjDef instance ready to be used to make a request
 */
+ (ObjectDef*) buildRequestObjDefForSubcategory:(NSString *)subcat withAppDataObject:(AppDataObject*)ado withImageName:(NSString*)imageName withEmail:(NSString*)_email withHistory:(History*)history
{
    
    //Set optional Extras
    ObjectDef *requestObject = [[ObjectDef alloc] init];
    requestObject.infos = [[Infos alloc] init];
    requestObject.infos.subcat = subcat;
    
    Datagroup *datagroup = [[Datagroup alloc] init];
    datagroup.img = imageName;
    datagroup.data = [[NSMutableArray alloc] init];
    Data *mData = [[Data alloc] init];              //  We don't need Data in multipart becasue already in gatagroup. TODO: remove together with Arndt
    mData.url = [NSString stringWithFormat:@"%@",imageName]; //@"%@.jpg" JPG extension not necessary
    [datagroup.data addObject:mData];
    
    requestObject.datagroups = [[Datagroups alloc] init];
    requestObject.datagroups.datagroup = [[NSMutableArray alloc] init];
    [requestObject.datagroups.datagroup addObject:datagroup];
    
    requestObject.extras = [[Extras alloc] init];
    requestObject.extras.extra = [[NSMutableArray alloc] init];
    
    Extra *osExtra = [[Extra alloc] init];
    osExtra.key = kHD_DEV_OS;
    osExtra.value = ado.deviceInfo.osVersion;
    [requestObject.extras.extra addObject:osExtra];
    
    Extra *appVerExtra = [[Extra alloc] init];
    appVerExtra.key = kHD_APP_VER;
    appVerExtra.value = ado.deviceInfo.appVersion;
    [requestObject.extras.extra addObject:appVerExtra];
    
    Extra *devModel = [[Extra alloc] init];
    devModel.key = kHD_DEV_MODEL;
    devModel.value = ado.deviceInfo.model;
    [requestObject.extras.extra addObject:devModel];
    
    Extra *deviceNameExtra = [[Extra alloc] init];
    deviceNameExtra.key = kHD_DEV_NAME;
    deviceNameExtra.value = ado.deviceInfo.deviceName;
    [requestObject.extras.extra addObject:deviceNameExtra];
    
    Extra *snapId = [[Extra alloc] init];
    snapId.key = kHD_SNAPPERID;
    snapId.value = [[[PersistenceManager sharedInstance] profile] secretObectID];
    [requestObject.extras.extra addObject:snapId];
    
    Extra *email = [[Extra alloc] init];
    email.key = kHD_EMAIL;
    email.value = _email;
    [requestObject.extras.extra addObject:email];
    
    Extra *gryphosObjectId = [[Extra alloc] init];
    gryphosObjectId.key = kHD_GRYPHOSOBJECTID;
    gryphosObjectId.value = [history.snapID stringValue];
    [requestObject.extras.extra addObject:gryphosObjectId];
    
    
    if (ACT_SSL){
        Extra *imeiExtra = [[Extra alloc] init];
        imeiExtra.key = kHD_IMEI;
        imeiExtra.value = ado.deviceInfo.deviceId;
        [requestObject.extras.extra addObject:imeiExtra];
        
        //Only transmit GPS data if its set
        if(ado.deviceInfo.gpsCompleteString!=nil){
            Extra *gpsExtra = [[Extra alloc] init];
            gpsExtra.key = kHD_GPS;
            gpsExtra.value = ado.deviceInfo.gpsCompleteString;
            [requestObject.extras.extra addObject:gpsExtra];
            
            Extra *accExtra = [[Extra alloc] init];
            accExtra.key = kHD_GPS_ACC;
            accExtra.value = ado.deviceInfo.hAcc;
            [requestObject.extras.extra addObject:accExtra];
        }
    }
    
    return requestObject;
}

/**
 * Static method to generate an ObjDef instance ready to be used to make a request
 */
+ (ObjectDef*) buildRequestObjDefForSubcategory:(NSString *)subcat withImageName:(NSString *)imgName withImei:(NSString *)deviceUDID withGps:(NSString *)coords withHAcc:(NSString *)hAcc withOsVer:(NSString *)osVer withModel:(NSString*)model withAppId:(NSString*)appId withAppVersion:(NSString*)appVersion withDeviceName:(NSString *)deviceName withWas2fs:(BOOL)was2fs withRequestGroupId:(NSString*) requestGroupId withAppDataObject:(AppDataObject*)ado{
    
    //Set optional Extras
    ObjectDef *requestObject = [[ObjectDef alloc] init];
    requestObject.infos = [[Infos alloc] init];
    requestObject.infos.subcat = subcat;
    
    Datagroup *datagroup = [[Datagroup alloc] init];
    datagroup.img = kIMAGE_MULTIPART;
    
    requestObject.datagroups = [[Datagroups alloc] init];
    requestObject.datagroups.datagroup = [[NSMutableArray alloc] init];
    [requestObject.datagroups.datagroup addObject:datagroup];
    
    requestObject.extras = [[Extras alloc] init];
    requestObject.extras.extra = [[NSMutableArray alloc] init];
    
    Extra *osExtra = [[Extra alloc] init];
    osExtra.key = kHD_DEV_OS;
    osExtra.value = osVer;
    [requestObject.extras.extra addObject:osExtra];
    
    Extra *appVerExtra = [[Extra alloc] init];
    appVerExtra.key = kHD_APP_VER;
    appVerExtra.value = appVersion;
    [requestObject.extras.extra addObject:appVerExtra];
    
    Extra *devModel = [[Extra alloc] init];
    devModel.key = kHD_DEV_MODEL;
    devModel.value = model;
    [requestObject.extras.extra addObject:devModel];
    
    Extra *deviceNameExtra = [[Extra alloc] init];
    deviceNameExtra.key = kHD_DEV_NAME;
    deviceNameExtra.value = deviceName;
    [requestObject.extras.extra addObject:deviceNameExtra];
    
    Extra *was2fsExtra = [[Extra alloc] init];
    was2fsExtra.key = kHD_2FS;
    was2fsExtra.value = was2fs == true ? @"true" : @"false";
    [requestObject.extras.extra addObject:was2fsExtra];
    
    Extra *requestGroupExtra = [[Extra alloc] init];
    requestGroupExtra.key = kHD_REQUEST_GROUP;
    requestGroupExtra.value = requestGroupId;
    [requestObject.extras.extra addObject:requestGroupExtra];

    
    if (ACT_SSL){
        Extra *imeiExtra = [[Extra alloc] init];
        imeiExtra.key = kHD_IMEI;
        imeiExtra.value = deviceUDID;
        [requestObject.extras.extra addObject:imeiExtra];
        
        //Only transmit GPS data if its set
        if(coords!=nil){
            Extra *gpsExtra = [[Extra alloc] init];
            gpsExtra.key = kHD_GPS;
            gpsExtra.value = coords;
            [requestObject.extras.extra addObject:gpsExtra];
            
            Extra *accExtra = [[Extra alloc] init];
            accExtra.key = kHD_GPS_ACC;
            accExtra.value = hAcc;
            [requestObject.extras.extra addObject:accExtra];
        }
        
    }
    
    return requestObject;
}

/**
 * Static method to generate an ObjDef instance for insert into the snap2life database
 */
+ (ObjectDef*)buildRequestObjDefForInsertWithTitle:(NSString*)title withSubcatcategory:(NSString *)subcat withLinkName:(NSString *)linkName withUrl:(NSString *)linkUrl withAdLink:(BOOL)withAdLink {
    
    ObjectDef *requestObject = [[ObjectDef alloc] init];
    
    // Setup the Infos section with a timestamp from the local clock.
    Infos* infos = [[Infos alloc] init];
    infos.title = title;
    infos.subcat = subcat;
    infos.active = YES;
    infos.timestamp = [self isoStringFromDate:[NSDate date]];
    requestObject.infos = infos;
    
    // Setup the Datagroups section with 1 image wihich has the visible flag set.
    Datagroup *datagroup = [[Datagroup alloc] init];
    datagroup.img = kREQUEST_IMAGE_KEY;
    datagroup.visible = YES;

    Data* data = [[Data alloc] init];
    data.url = kIMAGE_MULTIPART;
    datagroup.data = [[NSMutableArray alloc] init];
    [datagroup.data addObject:data];
    
    Datagroups* datagroups = [[Datagroups alloc] init];
    datagroups.datagroup = [[NSMutableArray alloc] init];
    [datagroups.datagroup addObject:datagroup];
    requestObject.datagroups = datagroups;
    
    // Setup a Featuregroups section containing the requested link and a fixed link to the snap2life website.
    Featuregroups* featuregroups = [[Featuregroups alloc] init];
    featuregroups.version = kFEATUREGROUPS_VERSION;
    
    Featuregroup* featuregroup = [[Featuregroup alloc] init];
    featuregroup.id = kFEATUREGROUP_ID;
    
    featuregroups.featuregroup = [[NSMutableArray alloc] init];
    [featuregroups.featuregroup addObject:featuregroup];
    
    Feature* feature = [[Feature alloc] init];
    feature.id = kFEATURE_ID;
    feature.order = 0;
    feature.type = kFEATURE_TYPE;
    feature.name = linkName;
    feature.value = linkUrl;
    featuregroup.feature = [[NSMutableArray alloc] init];
    [featuregroup.feature addObject:feature];
    
    if (withAdLink) {
        Feature* feature = [[Feature alloc] init];
        feature.id = kFEATURE_ID;
        feature.order = [featuregroup.feature count]; // Put at end.
        feature.type = kFEATURE_TYPE;
        feature.name = NSLocalizedString(@"put_adlink_name",nil);
        feature.value = NSLocalizedString(@"put_adlink_url",nil);
        [featuregroup.feature addObject:feature];
    }
    
    requestObject.featuregroups = featuregroups;
    
    return requestObject;
}

// Transforms an ISO 8601 string of the form "2012-12-24T16:28:29" to an NSDate.
+ (NSDate*)dateFromIsoString:(NSString*)isoString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    return [dateFormatter dateFromString:isoString];
}

// Transforms an NSDate to an ISO 8601 string of the form "2012-12-24T16:28:29".
+ (NSString*)isoStringFromDate:(NSDate*)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    return [dateFormatter stringFromDate:date];
}

@end
