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
#import "S2LIRRequestMaker.h"
#import "Data.h"
#import "Featuregroup.h"
#import "Feature.h"
#import "Extra.h"

@implementation SerializerAPI2




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

@end
