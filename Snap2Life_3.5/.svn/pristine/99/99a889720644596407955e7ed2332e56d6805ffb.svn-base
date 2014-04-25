//
//  S2LCommentPopoView.m
//  snap2life3.5
//
//  Created by iOS on 04.04.14.
//  Copyright (c) 2014 Prisma Gmbh. All rights reserved.
//

#import "S2LCommentPopoView.h"

@implementation S2LCommentPopoView
@synthesize snapID,parent,success,abort;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        comment = [[UITextField alloc] initWithFrame:CGRectMake(0, 6, 230, 44)];
        comment.text = NSLocalizedString(@"new_comment", nil);
        comment.backgroundColor = UIColorFromRGB(BACKGROUND, 1.0);
        comment.textColor = UIColorFromRGB(GREEN, 1.0);
        comment.delegate = self;
        [self addSubview:comment];
        
        submit = [UIButton buttonWithType:UIButtonTypeCustom];
        submit.frame = CGRectMake((230-120)/2, 12+44, 120, 44);
        [submit setTitle:NSLocalizedString(@"btn_save&share", nil) forState:UIControlStateNormal];
        [submit setStyle];
        [submit addTarget:self action:@selector(submitHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:submit];
    }
    return self;
}

-(IBAction)submitHandler:(id)sender
{
    if(![comment.text isEqualToString:@""] && ![comment.text isEqualToString:NSLocalizedString(@"new_comment", nil)]){
        
        submit.enabled = NO;
        [[S2LCommunityManager sharedInstance] flush];
        
        AFS2LAppAPIClient *httpClient = [AFS2LAppAPIClient sharedClient];
        [httpClient configuringDefaultHeadersWithADO:[[S2LIRRequestMaker sharedClient] ado]];
        
        SerializerAPI2 *serializer = [[SerializerAPI2 alloc] init];
        NSString *metadata = [serializer serializeComment:comment.text snapID:snapID];
        
        NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"interaction/store/" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
            
            [formData appendPartWithFileData:[metadata dataUsingEncoding:NSUTF8StringEncoding] name:@"interaction.xml" fileName:@"interaction.xml" mimeType:@"application/octet-stream"];
            
        }];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(success)success();
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(abort)abort();
        }];
        [httpClient enqueueHTTPRequestOperation:operation];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert_comment_title", nil) message:NSLocalizedString(@"alert_comment_message", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.text = @"";
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
