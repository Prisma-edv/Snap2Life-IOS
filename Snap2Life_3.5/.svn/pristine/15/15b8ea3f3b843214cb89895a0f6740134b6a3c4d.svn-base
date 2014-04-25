//
//  S2LErrorViewController.m
//  snap2life suite
//
//  Created by Antonio_Stilo on 11/21/13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "S2LErrorViewController.h"
#import "PersistenceManager.h"
#import "AppDataObject.h"
#import "S2LIRRequestMaker.h"
#import "S2LPutLinkView.h"
#import "S2LSerializerAPI2.h"
#import "AFS2LAppAPIClient.h"
#import "S2LNewResultViewController.h"
#import "UIButton+UIButton_style.h"
#import "SerializerAPI2.h"
#import "Extra.h"
#import "S2LCommunityManager.h"
#import "Constants.h"

@interface S2LErrorViewController ()

@end

@implementation S2LErrorViewController
@synthesize errorObject,history,resultIndex;

#pragma mark UITextField Delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if([textField.text isEqualToString:NSLocalizedString(@"put_comment_label",nil)] ||
       [textField.text isEqualToString:NSLocalizedString(@"put_key_label",nil)] ||
       [textField.text isEqualToString:NSLocalizedString(@"put_description_label",nil)])
        textField.text = @"";
    
    [self scrollToPosition:textField.frame.origin.y-30];
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)submitComment:(NSString*)comment withObject:(ObjectDef*)obj
{
        AFS2LAppAPIClient *httpClient = [AFS2LAppAPIClient sharedClient];
        [httpClient configuringDefaultHeadersWithADO:[[S2LIRRequestMaker sharedClient] ado]];
        
        SerializerAPI2 *serializer = [[SerializerAPI2 alloc] init];
        NSString *metadata = [serializer serializeComment:comment snapID:[obj snapID]];
    NSLog(@"** METADATA %@",metadata);
    
        NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"interaction/store/" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
            
            [formData appendPartWithFileData:[metadata dataUsingEncoding:NSUTF8StringEncoding] name:@"interaction.xml" fileName:@"interaction.xml" mimeType:@"application/octet-stream"];
            
        }];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            S2LNewResultViewController *resultVC = (S2LNewResultViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"result"];
            resultVC.object = (ObjectDef*)obj;
            SerializerAPI2 *serializer = [[SerializerAPI2 alloc] init];
            NSString *snapServerResponse = [serializer serializeObjDef:(ObjectDef*)obj];
            PersistenceManager *pm = [PersistenceManager sharedInstance];
            if([pm.settings.settingHistory boolValue])[pm removeHistoryItem:history];
            [self persistHistoryAsSuccess:obj forResponse:snapServerResponse];
            resultVC.history = history;
            resultVC.index = resultIndex;
            [self.navigationController pushViewController:resultVC animated:YES];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        [httpClient enqueueHTTPRequestOperation:operation];
    
}

#pragma mark UIViewController

-(void)submitAgainAction
{
    if([[AFS2LAppAPIClient sharedClient] isReachable]){
        S2LIRRequestMaker *requestMaker = [S2LIRRequestMaker sharedClient];
        [requestMaker evaluateBestMatch:background.image success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument) {
            
            S2LSerializerAPI2 *serializer = [[S2LSerializerAPI2 alloc] init];
            NSObject *obj = [serializer deserializeObjectDef:XMLDocument];
            
            if (obj == nil) {
                obj = [serializer deserializeError:XMLDocument];
            }
            
            NSString *snapServerResponse = [NSString stringWithFormat:@"%@",XMLDocument];
            if ([obj isKindOfClass:[ObjectDef class]]) {
                
                if(![commentText.text isEqualToString:@""] && ![commentText.text isEqualToString:NSLocalizedString(@"put_comment_label",nil)]){
                    [self submitComment:commentText.text withObject:(ObjectDef*)obj];
                }else{
                    S2LNewResultViewController *resultVC = (S2LNewResultViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"result"];
                    resultVC.object = (ObjectDef*)obj;
                    PersistenceManager *pm = [PersistenceManager sharedInstance];
                    if([pm.settings.settingHistory boolValue])[pm removeHistoryItem:history];
                    [self persistHistoryAsSuccess:obj forResponse:snapServerResponse];
                    resultVC.history = history;
                    [self.navigationController pushViewController:resultVC animated:YES];
                }
            }else{
                
                NSLog(@"ErrorDef submitAgain %@",obj);
                submitAgain.hidden = YES;
                PersistenceManager *pm = [PersistenceManager sharedInstance];
                if([pm.settings.settingHistory boolValue])[pm removeHistoryItem:history];
                [self persistHistoryAsSuccess:obj forResponse:snapServerResponse];
                [self buildInterface];
            
            }
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument) {
            
        }];
    }
}

- (void)persistHistoryAsSuccess:(NSObject*)obj forResponse:(NSString*)responseString{
    
    
    // Check if the History setting is set.
    PersistenceManager* persistenceManager = [PersistenceManager sharedInstance];
    if (![persistenceManager.settings.settingHistory boolValue]) return;
    
    BOOL wasSuccessful = NO;
    if ([obj isKindOfClass:[ObjectDef class]]) {
        wasSuccessful = YES;
    }
    
    History *_history = [persistenceManager createHistory];
    
    // Set the History to the captured image and a current timestamp
    _history.snapDate = [NSDate date];
    
    AppDataObject *mado = [[S2LIRRequestMaker sharedClient] ado];
    
    // Set the location info of the snap if the device has GPS activated and user has allowed it.
    _history.snapLatitude = (mado.deviceInfo.latitude != nil)? [NSNumber numberWithFloat:[mado.deviceInfo.latitude floatValue]]: nil;
    _history.snapLongitude = (mado.deviceInfo.longitude != nil)? [NSNumber numberWithFloat:[mado.deviceInfo.longitude floatValue]]: nil;
    _history.snapHorizAcc = (mado.deviceInfo.hAcc != nil)? [NSNumber numberWithFloat:[mado.deviceInfo.hAcc floatValue]]: nil;
    
    if(wasSuccessful){
        _history.snapTitle = [[(ObjectDef*)obj infos] title];
        _history.snapDesc = [[(ObjectDef*)obj infos] desc];
        Extra *extra = (Extra*)[[[(ObjectDef*)obj extras] extra] objectAtIndex:0];
        _history.snapID = [NSNumber numberWithInt:[extra.value integerValue]];
    }
    
    _history.snapImage = mado.capturedData;
    // History title and description are not yet used: perhaps later for user details?
    _history.snapHasVoted = [NSNumber numberWithBool:NO];
    _history.snapFavourite = [NSNumber numberWithBool:NO];
    // Set the response success and responseString (may be null if send attempted while offline).
    _history.snapRecognized = [NSNumber numberWithBool:wasSuccessful];
    _history.snapServerResponse = responseString;
    
    history = _history;
    // Sve the new or updated History.
    [persistenceManager saveAll];
}

-(IBAction)submitHandler:(id)sender
{
    if (![[AFS2LAppAPIClient sharedClient] isReachable]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You don´t have internet connection. The Snap will be saved on your device and you can send it when you´ll have internet connection again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    [nameBackground setBackgroundColor:[UIColor whiteColor]];
    [commentBackground setBackgroundColor:[UIColor whiteColor]];
    
    [nameText setText:[[nameText text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    if ([nameText.text isEqualToString:NSLocalizedString(@"put_key_label",nil)] || [nameText.text isEqualToString:@""]) {
        [nameBackground setBackgroundColor:[UIColor orangeColor]];
        return;
    }
    
    __block BOOL isSendable = YES;
    NSMutableArray *linksToSend = [NSMutableArray array];
    if (links.count > 0) {
        [links enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            S2LPutLinkView *tmp = (S2LPutLinkView*)obj;
            NSDictionary *dic = [tmp evaluate:links atIndex:idx];
            
            if (dic != nil) {
                [linksToSend addObject:dic];
            }else{
                if(idx < links.count-1){
                    isSendable = NO;
                    stop = YES;
                }
            }
        }];
    }
    
    if (!isSendable) {
        return;
    }
    
    BOOL mandatory = NO;
    if (linksToSend.count == 0) {
        mandatory = YES;
    }
    [commentText setText:[[commentText text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    if (mandatory && ([commentText.text isEqualToString:NSLocalizedString(@"put_comment_label",nil)] || [commentText.text isEqualToString:@""])) {
        [commentBackground setBackgroundColor:[UIColor orangeColor]];
        return;
    }else if([[commentText text] length] > 0){
        [commentText resignFirstResponder];
    }
    
    NSString *description = descriptionText.text;
    if([description isEqualToString:NSLocalizedString(@"put_description_label",nil)])description = @"";
    
    S2LIRRequestMaker *requestMaker = [S2LIRRequestMaker sharedClient];
    UIButton *btn = (UIButton*)sender;
    btn.enabled = NO;
    [requestMaker recordForMatch:background.image title:nameText.text comment:commentText.text description:description linksPath:linksToSend success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument) {
        
        NSLog(@"XML PUT OPTION: %@",XMLDocument);
        
        S2LSerializerAPI2 *serializer = [[S2LSerializerAPI2 alloc] init];
        NSObject *obj = [serializer deserializeObjectDef:XMLDocument];
        
        if (obj == nil) {
            obj = [serializer deserializeError:XMLDocument];
        }
        
        if ([obj isKindOfClass:[ObjectDef class]]) {
            if(![commentText.text isEqualToString:@""] && ![commentText.text isEqualToString:NSLocalizedString(@"put_comment_label",nil)]){
                [self submitComment:commentText.text withObject:(ObjectDef*)obj];
            }else{
                S2LNewResultViewController *resultVC = (S2LNewResultViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"result"];
                resultVC.object = (ObjectDef*)obj;
                SerializerAPI2 *serializer = [[SerializerAPI2 alloc] init];
                NSString *snapServerResponse = [serializer serializeObjDef:(ObjectDef*)obj];
                PersistenceManager *pm = [PersistenceManager sharedInstance];
                if([pm.settings.settingHistory boolValue])[pm removeHistoryItem:history];
                [self persistHistoryAsSuccess:obj forResponse:snapServerResponse];
                resultVC.history = history;
                resultVC.index = resultIndex;
                [self.navigationController pushViewController:resultVC animated:YES];
            }

        }
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument) {
        NSLog(@"** PUT Failure :%@",XMLDocument);
    }];
    

    
}

-(void)buildInterface
{
    AppDataObject *ado = [[S2LIRRequestMaker sharedClient] ado];
    NSData *capturedData = ado.capturedData;
	if (capturedData){
        UIImage *img = [[UIImage alloc] initWithData:capturedData];
        background.image = img;
	}
    
    NSString *errorTitle = NSLocalizedString(@"error",nil);
    titleLable.text = errorTitle;
   
    PersistenceManager *pm = [PersistenceManager sharedInstance];
    
    if([pm.settings.settingPutOption boolValue] && ![history.snapServerResponse isEqualToString:@""]){
        containerView.hidden = NO;
        [descriptionLabel setText:NSLocalizedString(@"put_intro_text",nil)];
        [descriptionLabel sizeToFit];
        
        [linkDescriptionLabel setText:NSLocalizedString(@"put_url_label",nil)];
        linkDescriptionLabel.backgroundColor = [UIColor clearColor];
        
        nameText.text = NSLocalizedString(@"put_key_label",nil);
        nameText.delegate = self;
        commentText.text = NSLocalizedString(@"put_comment_label",nil);
        commentText.delegate = self;
        
        descriptionText.text = NSLocalizedString(@"put_description_label",nil);
        descriptionText.delegate = self;
        
        links = [NSMutableArray array];
        [self buildLink:170];
    
    }else{
        int offset = 200;
        int width = self.view.frame.size.width;
        if(isIPad){
            offset = 10;
            width = 768;
        }
        containerView.hidden = YES;
        NSString* description = nil;
        for (Field* f in errorObject.fields.field) {
            if (f.msg != nil && f.msg.length > 0) {
                description = f.msg;
                break;
            }
            
            
            for (Action* a in f.actions.action){
                UIButton *_button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                _button.frame = CGRectMake((width-280)/2, offset, 280, 54.0);
                [_button setTitle:a.label forState:UIControlStateNormal];
                [_button addTarget:self action:@selector(buttonPressedAction:) forControlEvents:UIControlEventTouchUpInside];
                [_button setBackgroundImage:[UIImage imageNamed:@"buttonbg.png"] forState:UIControlStateNormal];
                [_button setTitleColor:UIColorFromRGB(SEC_COLOR_1, 1.0) forState:UIControlStateNormal];
                //_button.buttonUrl = a.url;
                [_button setStyle];
               [self.view addSubview:_button];
                offset += _button.bounds.size.height+10;
            }

        }
        
        descriptionLabel.text = description;
        
    offset = 300;
    
    submitAgain = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    submitAgain.frame = CGRectMake((width-280)/2, offset, 280, 54.0);
    [submitAgain setTitle:NSLocalizedString(@"error_submit_btn", nil) forState:UIControlStateNormal];
    [submitAgain addTarget:self action:@selector(submitAgainAction) forControlEvents:UIControlEventTouchUpInside];
    [submitAgain setBackgroundImage:[UIImage imageNamed:@"buttonbg.png"] forState:UIControlStateNormal];
    [submitAgain setTitleColor:UIColorFromRGB(SEC_COLOR_1, 1.0) forState:UIControlStateNormal];
    [submitAgain setStyle];
    [self.view addSubview:submitAgain];
    
    }
}
-(void)addLink:(CGFloat)offset
{
    [self buildLink:offset];
    [self scrollToPosition:offset-90];
}
-(void)buildLink:(CGFloat)offset
{
    if (links.count < HOWMANY_PUT_LINKS) {
        [links enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            S2LPutLinkView *tmp = (S2LPutLinkView*)obj;
            tmp.addButton.hidden = YES;
        }];
        
        S2LPutLinkView* tempView = [[S2LPutLinkView alloc] initWithFrame:CGRectMake(0, offset, self.view.frame.size.width, 94)];
        tempView.delegate = self;
        [links addObject:tempView];
        [containerView addSubview:tempView];
        submitButton.frame = CGRectMake((self.view.frame.size.width-submitButton.frame.size.width)/2, offset+100, submitButton.frame.size.width, submitButton.frame.size.height);
        int h = 220;
        if (isIPad) {
            h = 900;
        }
        scroll.contentSize = CGSizeMake(self.view.frame.size.width, containerView.frame.origin.y + offset + h);
        containerView.opaque = NO;
        if (HOWMANY_PUT_LINKS == 1) {
            tempView.addButton.hidden = YES;
        }
    }
}

-(void)scrollToPosition:(CGFloat)offset
{
    [scroll setContentOffset:CGPointMake(scroll.frame.origin.x, containerView.frame.origin.y + offset) animated:YES];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self buildInterface];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
