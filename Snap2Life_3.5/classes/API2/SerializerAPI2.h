//
//  Serializer.h
//  Snap2Life
//
//  Created by Alex Corbi on 1/31/11.
//  Copyright 2011 Prisma Gmbh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ErrorDef.h"
#import "ObjectDef.h"
#import "DDXMLDocument.h"
#import "DDXMLElement.h"
#import "DDXMLNode.h"
#import "Constants.h"
#import "History.h"
#import "GalleryDef.h"
#import "InteractionLog.h"
#import "Profile.h"
#import "S2LCommunitySnapDef.h"


/**
 Class for de/serializing the requests/responses between App and server-side
 @brief XML Serializer
 */
@interface SerializerAPI2 : NSObject

-(NSString*)serializeProfile:(Profile*)profile;

/**
 * Used to serialize a Vote to an xml string
 */
-(NSString*)serializeVote:(NSString*)value andObjectID:(NSInteger)objID;

/**
 * Used to serialize an InteractionLog to an xml string
 */
-(NSString*)serializeInteraction:(InteractionLog*)value;
/**
 * Used to serialize an ObjDef instance to an xml string 
 */
- (NSString *)serializeObjDef:(ObjectDef *)object;

/**
 * Used to deserialize an ObjDef instance from an xml string
 */
- (ObjectDef *)deserializeObjDef:(NSString *)object;

/**
 * Used to deserialize an Vote instance from an xml string
 */
-(NSInteger)deserializeVote:(NSString*)xmlString;
/**
 * Used to serialize a Error instance to xml string
 */
//- (NSString *)serializeError:(Error *)object;

/**
 * Used to deserialize an Error instance from xml string
 */
- (ErrorDef *)deserializeError:(NSString *)object;

/**
 * Used to deserialize a GalleryDef instance from xml string
 */
- (GalleryDef*)deserializeGalleryDef:(NSString *)object;

-(NSString*)serializeComment:(NSString*)value snapDef:(S2LCommunitySnapDef*)snapDef;
-(NSString*)serializeComment:(NSString*)value snapID:(NSString*)snapID;

@end
