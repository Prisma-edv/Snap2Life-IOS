//
//  S2LRestore.m
//  snap2life suite
//
//  Created by iOS on 10.12.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "S2LRestore.h"
#import "DDXMLDocument.h"
#import "S2LSerializerAPI2.h"
#import "ObjectDef.h"
#import "AFS2LAppAPIClient.h"
#import "S2LRequestUtils.h"
#import "S2LIRRequestMaker.h"
#import "PersistenceManager.h"
#import "Extra.h"

#define kSecret @"community_secret_qs"

@implementation S2LRestore
@synthesize compleateBlock,errorBlock;

- (void) evaluateSecretImageSuccess:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument))success
                   failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument))failure
{
    int initMilis = [[NSDate date] timeIntervalSince1970];
    long requestGroupId = (long) initMilis*1000;
    
    PersistenceManager *pm = [PersistenceManager sharedInstance];
    
    S2LSerializerAPI2 *serializer = [[S2LSerializerAPI2 alloc] init];
    ObjectDef *requestObject = [S2LRequestUtils buildRequestObjDefForSubcategory:kSecret withImageName:kREQUEST_IMAGE_KEY withRequestGroupId:[NSString stringWithFormat:@"%ld",requestGroupId] withAppDataObject:[[S2LIRRequestMaker sharedClient] ado]];
    NSString *metadata = [serializer serializeObjectDef:requestObject];
    
    AFS2LAppAPIClient *httpClient = [AFS2LAppAPIClient sharedClient];
    [httpClient configuringDefaultHeadersWithADO:[[S2LIRRequestMaker sharedClient] ado]];
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:[NSString stringWithFormat:@"query/all25/%@",kSecret] parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        
        [formData appendPartWithFileData:pm.profile.secretImage name:kREQUEST_IMAGE_KEY fileName:[NSString stringWithFormat:@"%@.png",kREQUEST_IMAGE_KEY] mimeType:@"application/octet-stream"];
        [formData appendPartWithFileData:[metadata dataUsingEncoding:NSUTF8StringEncoding] name:kREQUEST_METADATA_KEY fileName:kREQUEST_METADATA_KEY mimeType:@"application/octet-stream"];
        
    }];
    
    AFKissXMLRequestOperation *operation = [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:request success:success failure:failure];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);}];
    [httpClient enqueueHTTPRequestOperation:operation];
}

-(void)restoreProfile:(restoreCompleteBlock_t)compleate error:(restoreErrorBlock_t)error
{
    
    compleateBlock = compleate;
    errorBlock = error;
    
    [self evaluateSecretImageSuccess:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument) {
        
        NSLog(@"XML %@",XMLDocument);
        S2LSerializerAPI2 *serializer = [[S2LSerializerAPI2 alloc] init];
        NSObject *obj = [serializer deserializeObjectsDef:XMLDocument];
        if (obj == nil) {
            obj = [serializer deserializeError:XMLDocument];
        }
        
        if ([obj isKindOfClass:[NSArray class]]) {
            
            PersistenceManager *pm = [PersistenceManager sharedInstance];
            NSArray *list = (NSArray*)obj;
            
            __block BOOL isToRestore = NO;
            
            [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ObjectDef *tempObj = (ObjectDef*)obj;
                if ([tempObj.infos.desc isEqualToString:pm.profile.name]) {
                    NSLog(@"SECRET ID %@",[(Extra*)[tempObj.extras.extra objectAtIndex:0] value]);
                    pm.profile.secretObectID = [(Extra*)[tempObj.extras.extra objectAtIndex:0] value];
                    [pm saveAll];
                    isToRestore = YES;
                    stop = YES;
                }
            }];
            
            if (isToRestore) {
                [self checkAvatar];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Profile" message:NSLocalizedString(@"restore_notStored", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
                errorBlock();
            }
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Profile" message:NSLocalizedString(@"restore_notStored", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            errorBlock();
        }

        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument) {
        
    }];
    
}

-(void)checkAvatar
{
    
    PersistenceManager *pm = [PersistenceManager sharedInstance];
    AppDataObject *ado = [[S2LIRRequestMaker sharedClient]ado];
    
    AFS2LAppAPIClient *httpClient = [AFS2LAppAPIClient sharedClient];
    [httpClient configuringDefaultHeadersWithADO:ado];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/modus/rest/api2/hago/overlayimage/%@",pm.profile.name] parameters:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([(NSData*)responseObject length] > 0) {
            pm.profile.avatar = (NSData*)responseObject;
            [pm saveAll];
            [self checkProfile];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"CHECK FAILED %@",request.URL.description);
        errorBlock();
    }];
    
    [httpClient enqueueHTTPRequestOperation:operation];
    
}

-(void)checkProfile
{
    PersistenceManager *pm = [PersistenceManager sharedInstance];
    AppDataObject *ado = [[S2LIRRequestMaker sharedClient]ado];
    
    AFS2LAppAPIClient *httpClient = [AFS2LAppAPIClient sharedClient];
    [httpClient configuringDefaultHeadersWithADO:ado];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/modus/rest/api2/interaction/retrieve/SnapperId/%@/PROFILE?start=0&count=1",pm.profile.secretObectID] parameters:nil];
    
    AFKissXMLRequestOperation *operation = [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument) {
        NSLog(@"PATH %@",response.URL.description);
        NSLog(@"Interaction PROFILE %@",XMLDocument);
        S2LSerializerAPI2 *serializer = [[S2LSerializerAPI2 alloc] init];
        NSDictionary *profile = [serializer deserializeProfileInteraction:XMLDocument];
        
        pm.profile.email = [profile objectForKey:@"email"];
        pm.profile.name = [profile objectForKey:@"name"];
        
        [pm saveAll];
        
        compleateBlock(profile);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument) {
        errorBlock();
    }];
    
    [httpClient enqueueHTTPRequestOperation:operation];
    
}

+ (S2LRestore *)sharedInstance
{
    static S2LRestore *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[S2LRestore alloc] init];
    });
    return sharedInstance;
}



@end
