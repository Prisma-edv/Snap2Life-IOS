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
#import "IRConstants.h"


/**
 Class for de/serializing the requests/responses between App and server-side
 @brief XML Serializer
 */
@interface S2LSerializerAPI2 : NSObject


/**
 * Used to serialize an ObjDef instance to an xml string 
 */
- (NSString *)serializeObjectDef:(ObjectDef *)object;

-(NSDictionary*)deserializeProfileInteraction:(DDXMLDocument*)document;

- (NSArray *)deserializeObjectsDef:(DDXMLDocument *)document;

/**
 * Used to deserialize an ObjDef instance from an xml string
 */
- (ObjectDef *)deserializeObjectDef:(DDXMLDocument *)document;
-(ObjectDef*)deserializeObjectDefWithString:(NSString*)source;

/**
 * Used to deserialize an Error instance from xml string
 */
- (ErrorDef *)deserializeError:(DDXMLDocument *)document;

- (NSArray *)deserializeComments:(DDXMLDocument *)document;
- (NSArray *)deserializeSnaps:(DDXMLDocument *)document;

@end
