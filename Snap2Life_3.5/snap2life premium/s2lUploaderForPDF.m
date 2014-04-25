//
//  s2lUploader.m
//  snap2life suite
//
//  Created by Antonio Stilo on 06.03.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "s2lUploaderForPDF.h"
#import "SerializerAPI2.h"
#import "s2lAppDelegate.h"
#import "S2LIRRequestMaker.h"
#import "Constants.h"
#import "ObjectDef.h"
#import "RequestUtils.h"

@implementation s2lUploaderForPDF
@synthesize delegate;
@synthesize milis;
@synthesize ado;
@synthesize alreadyAlerted;
@synthesize imagesList = _imagesList;

-(void)startUploading:(NSArray*)incomingList
{
    self.imagesList = [incomingList mutableCopy];
    status = kStarted;
    currentImageIndex = 0;
    
    AFS2LAppAPIClient *httpClient = [AFS2LAppAPIClient sharedClient];
    [httpClient configuringDefaultHeadersWithADO:ado];
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:[NSString stringWithFormat:@"query/batch/%@",kSUBCAT_ID] parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        SerializerAPI2 *serializer = [[SerializerAPI2 alloc] init];
        for (int i = 0; i < self.imagesList.count; i++) {
            History *currentHistory = [self.imagesList objectAtIndex:i];
            ObjectDef *requestObject = [RequestUtils buildRequestObjDefForSubcategory:kSUBCAT_ID withAppDataObject:ado withImageName:[NSString stringWithFormat:@"%@%u",kREQUEST_IMAGE_KEY,i] withEmail:[[[PersistenceManager sharedInstance] profile] email] withHistory:currentHistory];
            NSString *metadata = [serializer serializeObjDef:requestObject];
            NSLog(@"---- METADATA ** %@",metadata);
            [formData appendPartWithFileData:currentHistory.snapImage  name:[NSString stringWithFormat:@"%@%u",kREQUEST_IMAGE_KEY,i] fileName:[NSString stringWithFormat:@"%@%u",kREQUEST_IMAGE_KEY,i] mimeType:@"application/octet-stream"];
            [formData appendPartWithFileData:[metadata dataUsingEncoding:NSUTF8StringEncoding] name:[NSString stringWithFormat:@"metadata%u.xml",i] fileName:[NSString stringWithFormat:@"metadata%u.xml",i] mimeType:@"application/octet-stream"];
        }
    }];
    
    NSLog(@"** REQUEST %@ \n\n %@ -- body: %@ \n\n",request.allHTTPHeaderFields, request.HTTPMethod,request.HTTPBodyStream/*[[NSString alloc] initWithData:request.HTTPBodyStream encoding:NSUTF8StringEncoding]*/);
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"PDF RESPONSE::::: %@ %@",operation.response.allHeaderFields,operation.description);
         NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"PDF RESPONSE:::: %@",responseString);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Batch Request" message:@"The batch request was sent successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"PDF RESPONSE ERROR %@",[error localizedDescription]);
    }];

    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);}];
    [httpClient enqueueHTTPRequestOperation:operation];
    

}


-(id)init
{
    self = [super init];
    if (self) {
        ado = [[S2LIRRequestMaker sharedClient] ado];
    }
    
    return self;
}


@end
