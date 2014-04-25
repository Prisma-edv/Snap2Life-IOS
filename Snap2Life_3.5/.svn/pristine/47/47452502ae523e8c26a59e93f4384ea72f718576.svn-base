//
//  Serializer.m
//  Snap2Life
//
//  Created by Alex Corbi on 1/31/11.
//  Copyright 2011 Prisma Gmbh. All rights reserved.
//

#import "SerializerAPI2.h"
#import "Datagroup.h"
#import "RequestUtils.h"
#import "GalleryItemDef.h"
#import "GalleryImageDef.h"
#import "PersistenceManager.h"
#import "UtilsDef.h"
#import "S2LIRRequestMaker.h"
#import "Data.h"
#import "Featuregroup.h"
#import "Feature.h"
#import "Extra.h"
#import "S2LCommunitySnapDef.h"

@implementation SerializerAPI2

-(NSString*)serializeProfile:(Profile*)profile
{
    
    /**
     <?xml version="1.0" encoding="UTF-8"?><interactions><interaction objectid="1037" objecttype="Snapper" timestamp="2013-12-05T16:30:26" type="PROFILE"><value/><extras><extra key="profile.name" value="TEST_1386257425564"/><extra key="profile.email" value="somebody@nowhere.com"/><extra key="profile.facebook" value="offline"/></extras></interaction></interactions>
     */
    
    
    DDXMLDocument *xml = [[DDXMLDocument alloc] initWithXMLString:@"<interactions/>" options:0 error:nil];
    DDXMLElement *interactions = [xml rootElement];
    DDXMLElement *interaction = [[DDXMLElement alloc] initWithName:@"interaction"];
    [interactions addChild:interaction];
    
    [interaction addAttribute:[DDXMLNode attributeWithName:@"type" stringValue:@"PROFILE"]];
    [interaction addAttribute:[DDXMLNode attributeWithName:@"timestamp" stringValue:[RequestUtils isoStringFromDate:[NSDate date]]]];
    [interaction addAttribute:[DDXMLNode attributeWithName:@"objecttype" stringValue:@"SnapperId"]];
    [interaction addAttribute:[DDXMLNode attributeWithName:@"objectid" stringValue:profile.secretObectID]];
    
    DDXMLElement *value = [[DDXMLElement alloc] initWithName:@"value"];
    [interaction addChild:value];
    
    DDXMLElement *extras = [[DDXMLElement alloc] initWithName:@"extras"];
    DDXMLElement *extra = [[DDXMLElement alloc] initWithName:@"extra"];
    [extra addAttribute:[DDXMLNode attributeWithName:@"key" stringValue:@"profile.name"]];
    [extra addAttribute:[DDXMLNode attributeWithName:@"value" stringValue:profile.name]];
    [extras addChild:extra];
    
    DDXMLElement *extra0 = [[DDXMLElement alloc] initWithName:@"extra"];
    [extra0 addAttribute:[DDXMLNode attributeWithName:@"key" stringValue:@"profile.email"]];
    [extra0 addAttribute:[DDXMLNode attributeWithName:@"value" stringValue:profile.email]];
    [extras addChild:extra0];
    
    DDXMLElement *extra1 = [[DDXMLElement alloc] initWithName:@"extra"];
    [extra1 addAttribute:[DDXMLNode attributeWithName:@"key" stringValue:@"profile.facebook"]];
    [extra1 addAttribute:[DDXMLNode attributeWithName:@"value" stringValue:@"offline"]];
    [extras addChild:extra1];

    
    [interaction addChild:extras];
    
    if (DEBUG_VERBOSE) NSLog(@"%@",xml);
    
    return [NSString stringWithFormat:@"%@",xml];
}


-(NSInteger)deserializeVote:(NSString*)xmlString
{
    
    DDXMLDocument *theDocument = [[DDXMLDocument alloc] initWithXMLString:xmlString options:0 error:nil];
    NSArray *rootArray = [theDocument nodesForXPath:@"/interactions" error:nil];

}

-(NSString*)serializeVote:(NSString*)value andObjectID:(NSInteger)objID
{

    AppDataObject *ado = [[S2LIRRequestMaker sharedClient] ado];
    
    DDXMLDocument *xml = [[DDXMLDocument alloc] initWithXMLString:@"<interactions/>" options:0 error:nil];
    DDXMLElement *interactions = [xml rootElement];
    DDXMLElement *interaction = [[DDXMLElement alloc] initWithName:@"interaction"];
    [interactions addChild:interaction];
    
    [interaction addAttribute:[DDXMLNode attributeWithName:@"type" stringValue:@"VOTE"]];
    [interaction addAttribute:[DDXMLNode attributeWithName:@"timestamp" stringValue:[RequestUtils isoStringFromDate:[NSDate date]]]];
    [interaction addAttribute:[DDXMLNode attributeWithName:@"objecttype" stringValue:@"GryphosObjectDef"]];
    [interaction addAttribute:[DDXMLNode attributeWithName:@"objectid" stringValue:[NSString stringWithFormat:@"%u",objID]]];
    
    DDXMLElement *extras = [[DDXMLElement alloc] initWithName:@"extras"];
    DDXMLElement *extra = [[DDXMLElement alloc] initWithName:@"extra"];
    [extra addAttribute:[DDXMLNode attributeWithName:@"key" stringValue:@"Modus-Imei"]];
    [extra addAttribute:[DDXMLNode attributeWithName:@"value" stringValue:ado.deviceInfo.deviceId]];
    [extras addChild:extra];
    
    DDXMLElement *extra0 = [[DDXMLElement alloc] initWithName:@"extra"];
    [extra0 addAttribute:[DDXMLNode attributeWithName:@"key" stringValue:@"Modus-Gps"]];
    [extra0 addAttribute:[DDXMLNode attributeWithName:@"value" stringValue:ado.deviceInfo.locale]];
    [extras addChild:extra0];
    
    DDXMLElement *extra1 = [[DDXMLElement alloc] initWithName:@"extra"];
    [extra1 addAttribute:[DDXMLNode attributeWithName:@"key" stringValue:@"Modus-Gps-Acc"]];
    [extra1 addAttribute:[DDXMLNode attributeWithName:@"value" stringValue:@"10"]];
    [extras addChild:extra1];
    
    DDXMLElement *extra2 = [[DDXMLElement alloc] initWithName:@"extra"];
    [extra2 addAttribute:[DDXMLNode attributeWithName:@"key" stringValue:@"Modus-Dev-Model"]];
    [extra2 addAttribute:[DDXMLNode attributeWithName:@"value" stringValue:ado.deviceInfo.model]];
    [extras addChild:extra2];
    
    DDXMLElement *extra3 = [[DDXMLElement alloc] initWithName:@"extra"];
    [extra3 addAttribute:[DDXMLNode attributeWithName:@"key" stringValue:@"Modus-Dev-Os"]];
    [extra3 addAttribute:[DDXMLNode attributeWithName:@"value" stringValue:ado.deviceInfo.osVersion]];
    [extras addChild:extra3];
    
    [interaction addChild:extras];
    
    DDXMLElement *valueNode = [[DDXMLElement alloc] initWithName:@"value"];
    [valueNode setStringValue:value];
    
    [interaction addChild:valueNode];
    
    if (DEBUG_VERBOSE) NSLog(@"%@",xml);
    
    return [NSString stringWithFormat:@"%@",xml];
}

/*    <?xml version="1.0" encoding="UTF-8"?>
 <interactions>
 <interaction objectid="390" objecttype="SnapperId" timestamp="2013-12-11T16:20:19" type="COMMENT">
 <value>this is a Comment</value>
 <extras>
 <extra key="SnapperId" value="390"/>
 <extra key="GryphosObjectId" value="421"/>
 </extras>
 </interaction>
 <interaction objectid="421" objecttype="GryphosObjectId" timestamp="2013-12-11T16:20:19" type="COMMENT">
 <value>this is a Comment</value>
 <extras>
 <extra key="SnapperId" value="390"/>
 <extra key="GryphosObjectId" value="421"/>
 </extras>
 </interaction>
 </interactions>
 */

-(NSString*)serializeComment:(NSString*)value snapID:(NSString*)snapID
{
    
    PersistenceManager *pm = [PersistenceManager sharedInstance];
    
    DDXMLDocument *xml = [[DDXMLDocument alloc] initWithXMLString:@"<interactions/>" options:0 error:nil];
    DDXMLElement *interactions = [xml rootElement];
    
    DDXMLElement *interaction = [[DDXMLElement alloc] initWithName:@"interaction"];
    [interaction addAttribute:[DDXMLNode attributeWithName:@"type" stringValue:@"COMMENT"]];
    [interaction addAttribute:[DDXMLNode attributeWithName:@"timestamp" stringValue:[RequestUtils isoStringFromDate:[NSDate date]]]];
    
    [interaction addAttribute:[DDXMLNode attributeWithName:@"objecttype" stringValue:@"SnapperId"]];
    [interaction addAttribute:[DDXMLNode attributeWithName:@"objectid" stringValue:pm.profile.secretObectID]];
    
    DDXMLElement *extras = [[DDXMLElement alloc] initWithName:@"extras"];
    DDXMLElement *extra = [[DDXMLElement alloc] initWithName:@"extra"];
    [extra addAttribute:[DDXMLNode attributeWithName:@"key" stringValue:@"SnapperId"]];
    [extra addAttribute:[DDXMLNode attributeWithName:@"value" stringValue:pm.profile.secretObectID]];
    [extras addChild:extra];
    
    DDXMLElement *extra0 = [[DDXMLElement alloc] initWithName:@"extra"];
    [extra0 addAttribute:[DDXMLNode attributeWithName:@"key" stringValue:@"GryphosObjectId"]];
    [extra0 addAttribute:[DDXMLNode attributeWithName:@"value" stringValue:snapID]];
    [extras addChild:extra0];
    
    [interaction addChild:extras];
    
    DDXMLElement *valueNode = [[DDXMLElement alloc] initWithName:@"value"];
    [valueNode setStringValue:value];
    
    [interaction addChild:valueNode];
    
    DDXMLElement *interaction0 = [[DDXMLElement alloc] initWithName:@"interaction"];
    [interaction0 addAttribute:[DDXMLNode attributeWithName:@"type" stringValue:@"COMMENT"]];
    [interaction0 addAttribute:[DDXMLNode attributeWithName:@"timestamp" stringValue:[RequestUtils isoStringFromDate:[NSDate date]]]];
    
    [interaction0 addAttribute:[DDXMLNode attributeWithName:@"objecttype" stringValue:@"GryphosObjectId"]];
    [interaction0 addAttribute:[DDXMLNode attributeWithName:@"objectid" stringValue:snapID]];
    
    DDXMLElement *extras0 = [[DDXMLElement alloc] initWithName:@"extras"];
    DDXMLElement *extra_0 = [[DDXMLElement alloc] initWithName:@"extra"];
    [extra_0 addAttribute:[DDXMLNode attributeWithName:@"key" stringValue:@"SnapperId"]];
    [extra_0 addAttribute:[DDXMLNode attributeWithName:@"value" stringValue:pm.profile.secretObectID]];
    [extras0 addChild:extra_0];
    
    DDXMLElement *extra_1 = [[DDXMLElement alloc] initWithName:@"extra"];
    [extra_1 addAttribute:[DDXMLNode attributeWithName:@"key" stringValue:@"GryphosObjectId"]];
    [extra_1 addAttribute:[DDXMLNode attributeWithName:@"value" stringValue:snapID]];
    [extras0 addChild:extra_1];
    
    [interaction0 addChild:extras0];
    
    DDXMLElement *valueNode0 = [[DDXMLElement alloc] initWithName:@"value"];
    [valueNode0 setStringValue:value];
    
    [interaction0 addChild:valueNode0];
    
    [interactions addChild:interaction];
    [interactions addChild:interaction0];
    
    if (DEBUG_VERBOSE) NSLog(@"%@",xml);
    
    return [NSString stringWithFormat:@"%@",xml];
}

-(NSString*)serializeComment:(NSString*)value snapDef:(S2LCommunitySnapDef*)snapDef
{
    return [self serializeComment:value snapID:snapDef.snapId];
}

-(NSString*)serializeInteraction:(InteractionLog*)value
{
    AppDataObject *ado = [[S2LIRRequestMaker sharedClient] ado];
    
    DDXMLDocument *xml = [[DDXMLDocument alloc] initWithXMLString:@"<interactions/>" options:0 error:nil];
    DDXMLElement *interactions = [xml rootElement];
    DDXMLElement *interaction = [[DDXMLElement alloc] initWithName:@"interaction"];
    [interactions addChild:interaction];
    
    [interaction addAttribute:[DDXMLNode attributeWithName:@"type" stringValue:value.type]];
    [interaction addAttribute:[DDXMLNode attributeWithName:@"timestamp" stringValue:[RequestUtils isoStringFromDate:value.timestamp]]];
    
    NSString *objectType;
    if([value.type isEqualToString:@"ACTION"] || [value.type isEqualToString:@"TRACKED"]){
        objectType = @"AR";
    }else if([value.type isEqualToString:@"LINKED"]){
        objectType = @"GryphosObjectDef";
    }
    
    [interaction addAttribute:[DDXMLNode attributeWithName:@"objecttype" stringValue:objectType]];
    [interaction addAttribute:[DDXMLNode attributeWithName:@"objectid" stringValue:value.imageTargetName]];
    
    DDXMLElement *extras = [[DDXMLElement alloc] initWithName:@"extras"];
    DDXMLElement *extra = [[DDXMLElement alloc] initWithName:@"extra"];
    [extra addAttribute:[DDXMLNode attributeWithName:@"key" stringValue:@"Modus-Imei"]];
    [extra addAttribute:[DDXMLNode attributeWithName:@"value" stringValue:ado.deviceInfo.deviceId]];
    [extras addChild:extra];
    
    DDXMLElement *extra0 = [[DDXMLElement alloc] initWithName:@"extra"];
    [extra0 addAttribute:[DDXMLNode attributeWithName:@"key" stringValue:@"Modus-Gps"]];
    [extra0 addAttribute:[DDXMLNode attributeWithName:@"value" stringValue:ado.deviceInfo.locale]];
    [extras addChild:extra0];
    
    DDXMLElement *extra1 = [[DDXMLElement alloc] initWithName:@"extra"];
    [extra1 addAttribute:[DDXMLNode attributeWithName:@"key" stringValue:@"Modus-Gps-Acc"]];
    [extra1 addAttribute:[DDXMLNode attributeWithName:@"value" stringValue:@"10"]];
    [extras addChild:extra1];
    
    DDXMLElement *extra2 = [[DDXMLElement alloc] initWithName:@"extra"];
    [extra2 addAttribute:[DDXMLNode attributeWithName:@"key" stringValue:@"Modus-Dev-Model"]];
    [extra2 addAttribute:[DDXMLNode attributeWithName:@"value" stringValue:ado.deviceInfo.model]];
    [extras addChild:extra2];
    
    DDXMLElement *extra3 = [[DDXMLElement alloc] initWithName:@"extra"];
    [extra3 addAttribute:[DDXMLNode attributeWithName:@"key" stringValue:@"Modus-Dev-Os"]];
    [extra3 addAttribute:[DDXMLNode attributeWithName:@"value" stringValue:ado.deviceInfo.osVersion]];
    [extras addChild:extra3];
    
    [interaction addChild:extras];
    
    DDXMLElement *valueNode = [[DDXMLElement alloc] initWithName:@"value"];
    [valueNode setStringValue:value.linkHref];
    
    [interaction addChild:valueNode];
    
    if (DEBUG_VERBOSE) NSLog(@"%@",xml);
    
    return [NSString stringWithFormat:@"%@",xml];
}

/**
 * Used to serialize a ObjDef instance to xml string
 */
- (NSString *) serializeObjDef:(ObjectDef *)object{
    
    DDXMLDocument *xml = [[DDXMLDocument alloc] initWithXMLString:@"<objDef/>" options:0 error:nil];
    DDXMLElement *objdef = [xml rootElement];
    
    //Infos
    DDXMLElement *infos = [[DDXMLElement alloc] initWithName:@"infos"];
    if (object.infos.cat!=nil){
        DDXMLElement *cat = [[DDXMLElement alloc] initWithName:@"cat"];
        [cat setStringValue:object.infos.cat];
        [infos addChild:cat];
    }
    if (object.infos.subcat!=nil){
        DDXMLElement *subcat = [[DDXMLElement alloc] initWithName:@"subcat"];
        [subcat setStringValue:object.infos.subcat];
        [infos addChild:subcat];
    }
    if (object.infos.title!=nil){
        DDXMLElement *title = [[DDXMLElement alloc] initWithName:@"title"];
        [title setStringValue:object.infos.title];
        [infos addChild:title];
    }
    if (object.infos.desc!=nil){
        DDXMLElement *desc = [[DDXMLElement alloc] initWithName:@"desc"];
        [desc setStringValue:object.infos.desc];
        [infos addChild:desc];
    }
    DDXMLElement *active = [[DDXMLElement alloc] initWithName:@"active"];
    [active setStringValue:((object.infos.active) ? @"true" : @"false")];
    [infos addChild:active];
    if (object.infos.validStart!=nil){
        DDXMLElement *validStart = [[DDXMLElement alloc] initWithName:@"validStart"];
        [validStart setStringValue:object.infos.validStart];
        [infos addChild:validStart];
    }
    if (object.infos.validEnd!=nil){
        DDXMLElement *validEnd = [[DDXMLElement alloc] initWithName:@"validEnd"];
        [validEnd setStringValue:object.infos.validEnd];
        [infos addChild:validEnd];
    }
    
        
    //Datagroups
    DDXMLElement *datagroups = [[DDXMLElement alloc] initWithName:@"datagroups"];
    
    for (Datagroup *d in object.datagroups.datagroup) {
        DDXMLElement *datagroup = [[DDXMLElement alloc] initWithName:@"datagroup"];
        [datagroup addAttribute:[DDXMLNode attributeWithName:@"id" stringValue:[NSString stringWithFormat:@"%d", d.id]]];
        [datagroup addAttribute:[DDXMLNode attributeWithName:@"border" stringValue:((d.border) ? @"true" : @"false")]];
        [datagroup addAttribute:[DDXMLNode attributeWithName:@"img" stringValue:d.img]];
        [datagroup addAttribute:[DDXMLNode attributeWithName:@"visible" stringValue:((d.visible) ? @"true" : @"false")]];

        //Data
        for (Data* dd in d.data){
            DDXMLElement *data = [[DDXMLElement alloc] initWithName:@"data"];
            [data addAttribute:[DDXMLNode attributeWithName:@"url" stringValue:dd.url]];
            [datagroup addChild:data];
        }
        
        [datagroups addChild:datagroup];            
    }
    
    //Featuregroups
    DDXMLElement *featuregroups = [[DDXMLElement alloc] initWithName:@"featuregroups"];
    [featuregroups addAttribute:[DDXMLNode attributeWithName:@"version" stringValue:[NSString stringWithFormat:@"%d", object.featuregroups.version]]];
    
    for (Featuregroup* fg in object.featuregroups.featuregroup) {
        DDXMLElement *featuregroup = [[DDXMLElement alloc] initWithName:@"featuregroup"];
        [featuregroup addAttribute:[DDXMLNode attributeWithName:@"id" stringValue:[NSString stringWithFormat:@"%d", fg.id]]];        
        
        //Feature
        for (Feature* f in fg.feature){
            DDXMLElement *feature = [[DDXMLElement alloc] initWithName:@"feature"];
            [feature addAttribute:[DDXMLNode attributeWithName:@"name" stringValue:f.name]];
            [feature addAttribute:[DDXMLNode attributeWithName:@"id" stringValue:[NSString stringWithFormat:@"%d", f.id]]];
            [feature addAttribute:[DDXMLNode attributeWithName:@"type" stringValue:[NSString stringWithFormat:@"%d", f.type]]];
            [feature addAttribute:[DDXMLNode attributeWithName:@"value" stringValue:f.value]];
            [feature addAttribute:[DDXMLNode attributeWithName:@"tolerance" stringValue:[NSString stringWithFormat:@"%d", f.tolerance]]];
            [feature addAttribute:[DDXMLNode attributeWithName:@"order" stringValue:[NSString stringWithFormat:@"%d", f.order]]];
            
            [featuregroup addChild:feature];
        }
        
        [featuregroups addChild:featuregroup];            
    }
    
    //Extras
    DDXMLElement *extras = [[DDXMLElement alloc] initWithName:@"extras"];
    
    for (Extra *e in object.extras.extra){
        DDXMLElement *extra = [[DDXMLElement alloc] initWithName:@"extra"];
        [extra addAttribute:[DDXMLNode attributeWithName:@"key" stringValue:e.key]];
        [extra addAttribute:[DDXMLNode attributeWithName:@"value" stringValue:e.value]];
        [extra addAttribute:[DDXMLNode attributeWithName:@"type" stringValue:[NSString stringWithFormat:@"%d", e.type]]];
        [extras addChild:extra];

    }
    
    //Add main children to document
    [objdef addChild:infos];    
    if ([object.datagroups.datagroup count]>0)[objdef addChild:datagroups];
    if ([object.featuregroups.featuregroup count]>0)[objdef addChild:featuregroups];
    if ([object.extras.extra count]>0)[objdef addChild:extras];
    
    if (DEBUG_VERBOSE) NSLog(@"%@",xml);
    
    return [NSString stringWithFormat:@"%@",xml];
}

/**
 * Used to deserialize a ObjDef instance from xml string
 */
- (ObjectDef *)deserializeObjDef:(NSString *)object{
    
    ObjectDef *toReturn = [[ObjectDef alloc ] init];
    
    DDXMLDocument *theDocument = [[DDXMLDocument alloc] initWithXMLString:object options:0 error:nil];
    
    NSArray *rootArray = [theDocument nodesForXPath:@"/objDef" error:nil];
    if (rootArray==nil) return nil;
    
    //Infos
	NSArray *infosArray = [theDocument nodesForXPath:@"/objDef/infos" error:nil];
    
    if ([infosArray count]!=1) return nil;
    
    DDXMLElement *infos = [infosArray objectAtIndex:0];
    toReturn.infos = [[Infos alloc]  init];
    
    
	for (DDXMLElement *e in [infos children]) {
        
		if ([[e name] isEqualToString:@"cat"]){
            toReturn.infos.cat = [e stringValue];
        }
        else if ([[e name] isEqualToString:@"subcat"]){
            toReturn.infos.subcat = [e stringValue];
        }
        else if ([[e name] isEqualToString:@"title"]){
            toReturn.infos.title = [e stringValue];
        }
        else if ([[e name] isEqualToString:@"desc"]){
            toReturn.infos.desc = [e stringValue];
        }
        else if ([[e name] isEqualToString:@"timestamp"]){
            toReturn.infos.timestamp = [e stringValue];
        }
        else if ([[e name] isEqualToString:@"active"]){
            toReturn.infos.active = [[e stringValue] isEqualToString:@"true"];
        }
        else if ([[e name] isEqualToString:@"validStart"]){
            toReturn.infos.validStart = [e stringValue];
        }
        else if ([[e name] isEqualToString:@"validEnd"]){
            toReturn.infos.validEnd = [e stringValue];
        }
	}
    
    //Datagroups
    NSArray *datagroupsArray = [theDocument nodesForXPath:@"/objDef/datagroups" error:nil];
    
    if ([datagroupsArray count]==1){
    
        toReturn.datagroups = [[Datagroups alloc]  init];
        toReturn.datagroups.datagroup = [[NSMutableArray alloc ] init];

        NSArray *datagroupArray = [theDocument nodesForXPath:@"/objDef/datagroups/datagroup" error:nil];
    
        for (DDXMLElement *e in datagroupArray) {
            Datagroup *datagroup = [[Datagroup alloc] init];
            datagroup.id = [[[e attributeForName:@"id"] stringValue] intValue];
            NSString *border = [[e attributeForName:@"border"] stringValue];
            datagroup.border = [border isEqualToString:@"true"];
            datagroup.img = [[e attributeForName:@"img"] stringValue];
            NSString *visible = [[e attributeForName:@"visible"] stringValue];
            datagroup.visible = [visible isEqualToString:@"true"];
            datagroup.data =  [[NSMutableArray alloc] init];
        
            for (DDXMLElement *d in [e elementsForName:@"data"]){
                Data *data = [[Data alloc] init];
                data.url = [[d attributeForName:@"url"] stringValue];
                [datagroup.data addObject:data];            
            }   
            [toReturn.datagroups.datagroup addObject:datagroup];        
        }
    }
    
    //Featuregroups
    NSArray *featuregroupsArray = [theDocument nodesForXPath:@"/objDef/featuregroups" error:nil];
    
    if ([featuregroupsArray count]==1){
    
        toReturn.featuregroups = [[Featuregroups alloc]  init];
        toReturn.featuregroups.featuregroup = [[NSMutableArray alloc ] init];
    
    
        NSArray *featuregroupArray = [theDocument nodesForXPath:@"/objDef/featuregroups/featuregroup" error:nil];
    
        for (DDXMLElement *e in featuregroupArray) {
            Featuregroup *featuregroup = [[Featuregroup alloc] init];

            featuregroup.id =  [[[e attributeForName:@"id"] stringValue] intValue];    
            featuregroup.feature =  [[NSMutableArray alloc] init];
        
            for (DDXMLElement *d in [e elementsForName:@"feature"]){
                Feature *feature = [[Feature alloc] init];
                feature.id = [[[d attributeForName:@"id"] stringValue] intValue];
                feature.name = [[d attributeForName:@"name"] stringValue];
                feature.value = [[d attributeForName:@"value"] stringValue];
                feature.type = [[[d attributeForName:@"type"] stringValue] intValue];
                feature.tolerance = [[[d attributeForName:@"tolerance"] stringValue] intValue];
                feature.order = [[[d attributeForName:@"order"] stringValue] intValue];
                [featuregroup.feature addObject:feature];            
            }   
            [toReturn.featuregroups.featuregroup addObject:featuregroup];        
        }
    }
    
    NSArray *extras = [theDocument nodesForXPath:@"/objDef/extras" error:nil];
    
    if ([extras count]==1){
        
        toReturn.extras = [[Extras alloc]  init];
        toReturn.extras.extra = [[NSMutableArray alloc ] init];
        
        NSArray *extraArray = [theDocument nodesForXPath:@"/objDef/extras/extra" error:nil];
        
        for (DDXMLElement *e in extraArray) {
            Extra *extra = [[Extra alloc] init];
            extra.value = [[e attributeForName:@"value"] stringValue];
            extra.key = [[e attributeForName:@"key"] stringValue];
            /*
            extra.id =  [[[e attributeForName:@"id"] stringValue] intValue];
            featuregroup.feature =  [[NSMutableArray alloc] init];
            
            for (DDXMLElement *d in [e elementsForName:@"feature"]){
                Feature *feature = [[Feature alloc] init];
                feature.id = [[[d attributeForName:@"id"] stringValue] intValue];
                feature.name = [[d attributeForName:@"name"] stringValue];
                feature.value = [[d attributeForName:@"value"] stringValue];
                feature.type = [[[d attributeForName:@"type"] stringValue] intValue];
                feature.tolerance = [[[d attributeForName:@"tolerance"] stringValue] intValue];
                feature.order = [[[d attributeForName:@"order"] stringValue] intValue];
                [featuregroup.feature addObject:feature];
            }
             */
             [toReturn.extras.extra addObject:extra];
        }
    }
    
    NSLog(@"** extras %@",[(Extra*)[toReturn.extras.extra objectAtIndex:0] value]);
    
    return toReturn; 
}

/**
 * Used to serialize a Error instance to xml string
 */
//- (NSString *)serializeError:(Error *)object;

/**
 * Used to deserialize an xml string to an Error instance
 */
- (ErrorDef *)deserializeError:(NSString *)object{
    
    ErrorDef *toReturn = [[ErrorDef alloc ] init];
    
    DDXMLDocument *theDocument = [[DDXMLDocument alloc] initWithXMLString:object options:0 error:nil];
    
    NSArray *rootArray = [theDocument nodesForXPath:@"/error" error:nil];
    if (rootArray==nil) return nil;
    
    //Infos
	NSArray *fieldsArray = [theDocument nodesForXPath:@"/error/fields" error:nil];
    
    if ([fieldsArray count]==0) return nil;
    
    toReturn.fields = [[Fields alloc] init];
    toReturn.fields.field = [[NSMutableArray alloc] init];
    
    DDXMLElement *fields = [fieldsArray objectAtIndex:0];
    for (DDXMLElement *f in [fields elementsForName:@"field"]) {
        
        Field *field = [[Field alloc] init];
        field.msg = [[f attributeForName:@"msg"] stringValue];
        
        NSArray *actionsArray = [f elementsForName:@"actions"];
        if ([actionsArray count]==1){
            
            DDXMLElement *aa = [actionsArray objectAtIndex:0];
            NSArray *actionArray = [aa elementsForName:@"action"];
            
            field.actions = [[Actions alloc] init];
            field.actions.action = [[NSMutableArray alloc] init];
            
            if ([actionArray count]>0){
                
                for (DDXMLElement *a in actionArray){
                    Action *action = [[Action alloc] init];
                    action.label = [[a attributeForName:@"label"] stringValue];            
                    action.url = [[a attributeForName:@"url"] stringValue];                
                    action.type = [[[a attributeForName:@"type"] stringValue] intValue];
                    
                    [field.actions.action addObject:action];
                }                                
            }            
        }
        
        [toReturn.fields.field addObject:field];
        
    }
    
    return toReturn;
    
}


/**
 * Used to deserialize a GalleryDef instance from xml string
 */
- (GalleryDef*)deserializeGalleryDef:(NSString *)object {
    
    GalleryDef* toReturn = [[GalleryDef alloc ] init];
    DDXMLDocument* theDocument = [[DDXMLDocument alloc] initWithXMLString:object options:0 error:nil];
    
    // The GalleryDef root and its attributes.
    NSArray* rootArray = [theDocument nodesForXPath:@"/gallery" error:nil];
    if (rootArray == nil || [rootArray count] > 1) return nil;
    DDXMLElement* packageElem = [rootArray objectAtIndex:0];
    [toReturn setVersion:[[packageElem attributeForName:@"version"] stringValue]];
    [toReturn setItems:[NSMutableArray array]];
    [toReturn setUtils:[NSMutableArray array]];
    
    // GalleryDef's items.
    for (DDXMLElement* itemElem in [theDocument nodesForXPath:@"/gallery/item" error:nil]) {
        GalleryItemDef* itemDef = [[GalleryItemDef alloc] init];
        [[toReturn items] addObject:itemDef];
        
        // GalleryItemDef attributes.
        [itemDef setPackageHref:[[itemElem attributeForName:@"packageHref"] stringValue]];
        [itemDef setLabel:[[itemElem attributeForName:@"label"] stringValue]];
        
        [itemDef setDetailPrice:[[itemElem attributeForName:@"price"] stringValue]];
        [itemDef setDetailDescription:[[itemElem attributeForName:@"description"] stringValue]];
        [itemDef setDetailPassword:[[itemElem attributeForName:@"protect"] stringValue]];
        NSLog(@"******************************** itemDef.detailDescription %@",itemDef.detailDescription);
        [itemDef setImages:[NSMutableArray array]];
        
        // Generate GalleryItemDef's contained GalleryImageDefs.
        for (DDXMLElement *e in [itemElem children]) {
            if ([[e name] isEqualToString:@"image"]) {
                GalleryImageDef* imageDef = [[GalleryImageDef alloc] init];
                [imageDef setHref:[[e attributeForName:@"href"] stringValue]];
                [imageDef setCaption:[[e attributeForName:@"caption"] stringValue]];
                [imageDef setLink:[[e attributeForName:@"link"] stringValue]];
                [[itemDef images] addObject:imageDef];
            }
            else {
                // TODO for other potental children of GalleryItemDef.
            }
        }
    }
    NSLog(@"[theDocument nodesForXPath: %@",[theDocument nodesForXPath:@"/gallery/utils" error:nil]);
    for (DDXMLElement* itemElem in [theDocument nodesForXPath:@"/gallery/utils" error:nil]) {
        for (DDXMLElement *e in [itemElem children]) {
            UtilsDef* itemDef = [[UtilsDef alloc] init];
            [[toReturn utils] addObject:itemDef];
            [itemDef setHref:[[e attributeForName:@"href"] stringValue]];
            [itemDef setLabel:[[e attributeForName:@"label"] stringValue]];
            NSLog(@">> %@",e);
        }
    }
    
    return toReturn;
}
@end
