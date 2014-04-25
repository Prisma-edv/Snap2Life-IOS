//
//  History.h
//  snap2life suite
//
//  Created by prisma on 08.02.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface History : NSManagedObject

@property (nonatomic, strong) NSData* snapImage;
@property (nonatomic, strong) NSDate* snapDate;
@property (nonatomic, strong) NSNumber* snapLatitude; // GPS data from the device, dependent on user permission in the Settings
@property (nonatomic, strong) NSNumber* snapLongitude;
@property (nonatomic, strong) NSNumber* snapHorizAcc;
@property (nonatomic, strong) NSString* snapTitle;
@property (nonatomic, strong) NSString* snapDesc;
@property (nonatomic, strong) NSNumber* snapRecognized;
// Boolean true if an ObjDef was successfully returned from the server.

@property (nonatomic, strong) NSNumber* snapFavourite;
@property (nonatomic, strong) NSString* snapServerResponse; // This is: null if not yet sent to server, an ObjDef XML if recognized or an ErrorDef XML.

@property (nonatomic, strong) NSNumber* snapToSendForPdf;
@property (nonatomic, strong) NSNumber* snapVoteValue;
@property (nonatomic, strong) NSNumber* snapHasVoted;

@property (nonatomic, strong) NSNumber* snapID;

@end
