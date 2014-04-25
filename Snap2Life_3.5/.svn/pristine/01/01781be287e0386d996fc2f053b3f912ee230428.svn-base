//
//  s2lTrackingUtils.m
//  snap2life suite
//
//  Created by Antonio Stilo on 09.04.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "s2lTrackingUtils.h"
#import "SerializerAPI2.h"
#import "AFHTTPRequestOperation.h"
#import "PersistenceManager.h"
#import "InteractionLog.h"
#import "S2LIRRequestMaker.h"

@implementation s2lTrackingUtils
@synthesize ado;

-(id)init
{
    self = [super init];
    if(self){
        ado = [[S2LIRRequestMaker sharedClient] ado];
    }

    return self;
}

-(void)retriveVote:(NSInteger)_objID
{
    AFS2LAppAPIClient *httpClient = [AFS2LAppAPIClient sharedClient];
    [httpClient configuringDefaultHeadersWithADO:self.ado];
    
    objID = _objID;
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"GET" path:[NSString stringWithFormat:@"/interaction/retrieve/GryphosObjectDef/%u/VOTE",_objID] parameters:nil constructingBodyWithBlock:NULL];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [httpClient enqueueHTTPRequestOperation:operation];

}

-(void)sendVote:(NSString*)value andObjectID:(NSInteger)_objID
{
    AFS2LAppAPIClient *httpClient = [AFS2LAppAPIClient sharedClient];
    [httpClient configuringDefaultHeadersWithADO:self.ado];
    
    objID = _objID;
    SerializerAPI2 *serializer = [[SerializerAPI2 alloc] init];
    NSString *metadata = [serializer serializeVote:value andObjectID:objID];
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"interaction/store/" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        
        [formData appendPartWithFileData:[metadata dataUsingEncoding:NSUTF8StringEncoding] name:@"interaction" fileName:@"interaction.xml" mimeType:@"application/octet-stream"];
        
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //[self retriveVote:objID];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [httpClient enqueueHTTPRequestOperation:operation];

    
}

-(void)sendInteractionLog
{
    PersistenceManager *pm = [PersistenceManager sharedInstance];
    NSArray *interactions = [pm allInteractions];
    
    AFS2LAppAPIClient *httpClient = [AFS2LAppAPIClient sharedClient];
    [httpClient configuringDefaultHeadersWithADO:self.ado];
    SerializerAPI2 *serializer = [[SerializerAPI2 alloc] init];
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"interaction/store/" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        
        for(int i = 0; i < interactions.count; i++)
        {
            InteractionLog *tmpInteraction = [interactions objectAtIndex:i];
            NSString *metadata = [serializer serializeInteraction:tmpInteraction];
            [formData appendPartWithFileData:[metadata dataUsingEncoding:NSUTF8StringEncoding] name:@"interaction" fileName:[NSString stringWithFormat:@"interaction%u.xml",i] mimeType:@"application/octet-stream"];
        }

    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        PersistenceManager *pm = [PersistenceManager sharedInstance];
        [pm deleteAllInteractions];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [httpClient enqueueHTTPRequestOperation:operation];
    
}

@end
