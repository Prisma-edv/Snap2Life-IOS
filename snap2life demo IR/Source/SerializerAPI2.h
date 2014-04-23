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


/**
 Class for de/serializing the requests/responses between App and server-side
 @brief XML Serializer
 */
@interface SerializerAPI2 : NSObject

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

-(NSString*)serializeComment:(NSString*)value snapID:(NSString*)snapID;

@end
