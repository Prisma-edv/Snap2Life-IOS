//
//  s2lResultViewController.m
//  snap2life suite
//
//  Created by Antonio Stilo on 18.02.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "s2lResultViewController.h"
#import "s2lAppDelegate.h"
#import "SerializerAPI2.h"
#import "S2LSerializerAPI2.h"
#import "s2lSnapWebViewController.h"
#import "s2lResultCommentViewController.h"
#import "Extra.h"

@interface s2lResultViewController ()

@end

@implementation s2lResultViewController
@synthesize currentHistory;

-(void)commentHandler
{
    
    s2lResultCommentViewController *commentViewController = [[s2lResultCommentViewController alloc] initWithNibName:nil bundle:nil];
    
    if(!isIPad){
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:commentViewController];
        nc.navigationBar.tintColor = [UIColor blackColor];
        
        [self presentViewController:nc animated:YES completion:^{}];
    }else{
        commentViewController.view.frame = CGRectMake(0, 100, commentViewController.view.frame.size.width, commentViewController.view.frame.size.height);
        [self.navigationController pushViewController:commentViewController animated:YES];
    }
    
}

-(void)shearOnTweeter:(UIImage*)snap
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"Snap2Life: "];
        [tweetSheet addImage:snap];
        [self presentViewController:tweetSheet animated:YES completion:nil];
        [tweetSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            NSString *output;
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    output = @"Action Cancelled";
                    break;
                case SLComposeViewControllerResultDone:
                    output = @"Post Successfull";
                    break;
                default:
                    break;
            } //check if everythink worked properly. Give out a message on the state.
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tweeter" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }];

    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tweeter" message:@"You don´t have a Tweeter account installed." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
    

}

-(void)shearOnFaceBook:(UIImage*)snap
{
    //if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) //check if Facebook Account is linked
    //{
        mySLComposerSheet = [[SLComposeViewController alloc] init]; //initiate the Social Controller
        mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook]; //Tell him with what social plattform to use it, e.g. facebook or twitter
        [mySLComposerSheet setInitialText:[NSString stringWithFormat:@"Snap2Life: "]]; //the message you want to post
        [mySLComposerSheet addImage:snap]; //an image you could post
        //for more instance methodes, go here:https://developer.apple.com/library/ios/#documentation/NetworkingInternet/Reference/SLComposeViewController_Class/Reference/Reference.html#//apple_ref/doc/uid/TP40012205
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            NSString *output;
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    output = @"Action Cancelled";
                    break;
                case SLComposeViewControllerResultDone:
                    output = @"Post Successfull";
                    break;
                default:
                    break;
            } //check if everythink worked properly. Give out a message on the state.
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }];
    /*}else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:@"You don´t have a Facebook account installed." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }*/
}

-(IBAction)doneButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - RequestMakerDelegate methods


- (void) stopLoadingView
{
}

- (void) increaseRequestCounter{
}


-(void)resendImageForRecognition:(History*)history
{
    /*
    if (![[RKClient sharedClient] isNetworkReachable]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You don´t have internet connection. The Snap will be saved on your device and you can send it when you´ll have internet connection again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
    }else{
        int initMilis = [[NSDate date] timeIntervalSince1970];
        long requestGroupId = (long) initMilis*1000;
        requestMaker = [[RequestMaker alloc] init];
        [requestMaker setDelegate:self];
        s2lAppDelegate *appDelegate = (s2lAppDelegate*)[UIApplication sharedApplication].delegate;
        appDelegate.isSavedHistory = YES;
            MyAppDataObject *ado = [appDelegate ado];
        [requestMaker setAdo:ado];
        ado.selectedHistory = history;
        requestMaker.alreadyAlerted = FALSE;
        //[requestMaker cancelRequestQueue];
        [requestMaker getBestMatchAPI2:[UIImage imageWithData:history.snapImage] withRequestGroupId:[NSString stringWithFormat:@"%ld",requestGroupId]];
    }*/
}

-(void)openWebUrlAndStore:(NSString *)urlString andTargetName:(NSString *)name{
    PersistenceManager *pm = [PersistenceManager sharedInstance];
    NSLog(@"** ResultViewController %@ - %d",urlString,[pm.settings.settingBrowser boolValue]);
    [pm interactionLogItemWithLink:urlString withTargetName:name andType:@"LINKED"];
    [self openWebUrl:urlString];
}

-(void)openWebUrl:(NSString *)urlString
{
   PersistenceManager *pm = [PersistenceManager sharedInstance];
    if(![pm.settings.settingBrowser boolValue]){
        UIStoryboard *storyboard = self.storyboard;
        webViewController = [storyboard instantiateViewControllerWithIdentifier:@"web"];
        s2lAppDelegate *appDelegate = (s2lAppDelegate*)[UIApplication sharedApplication].delegate;
        appDelegate.urlToOpen = urlString;
        [self presentViewController:webViewController animated:YES completion:nil];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
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
    
    currentHistory = _history;
    // Sve the new or updated History.
    [persistenceManager saveAll];
}

-(void)changeScreen:(NSObject *)obj
{
    if ([obj isKindOfClass:[ObjectDef class]]) {
        currentHistory.snapRecognized = [NSNumber numberWithBool:YES];
        currentHistory.snapTitle = [[(ObjectDef*)obj infos] title];
        currentHistory.snapDesc = [[(ObjectDef*)obj infos] desc];
        _resultView.hidden = NO;
        _errorView.hidden = YES;
        _resultView.delegate = self;
        _resultView.history = self.currentHistory;
        [_resultView refreshUI:(ObjectDef*)obj];

        SerializerAPI2 *serializer = [[SerializerAPI2 alloc] init];
        currentHistory.snapServerResponse = [serializer serializeObjDef:(ObjectDef*)obj];
        [[PersistenceManager sharedInstance] saveAll];
    }else{
        _resultView.hidden = YES;
        _errorView.hidden = NO;
        _errorView.history = self.currentHistory;
        _errorView.delegate = self;
        [_errorView refreshUIWithError:(ErrorDef*)obj];
    }

}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"** HISTORY RESULT PAGE %@",self.currentHistory);

   
}

/*
- (void)showErrorScreen:(ErrorDef*)error{
    
    NSLog(@"** s2lResult SHOW ERROR SCREEN **");
    _resultView.hidden = YES;
    _errorView.hidden = NO;
   // MyAppDataObject *ado = [(s2lAppDelegate*)([[UIApplication sharedApplication] delegate]) ado];
   // _errorView.history = ado.selectedHistory;
    [_errorView refreshUIWithError:error];

}

- (void)showResultScreen{
    
    NSLog(@"** s2lResult SHOW Result SCREEN **");
    _resultView.hidden = NO;
    _errorView.hidden = YES;
    //MyAppDataObject *ado = [(s2lAppDelegate*)([[UIApplication sharedApplication] delegate]) ado];
    //[self parseToTheADO:ado.selectedHistory.snapServerResponse];
    //_resultView.history = ado.selectedHistory;
    //[_resultView refreshUI];
}
 
 */

/**
 Opens a browser window to load the url passed as parameter
 */
- (void)launchWebsite:(NSString*)url{
    UIStoryboard *storyboard = self.storyboard;
    webViewController = [storyboard instantiateViewControllerWithIdentifier:@"web"];
    webViewController.urlString = url;
    [self presentViewController:webViewController animated:YES completion:nil];
}

-(void)viewWillLayoutSubviews
{
    if (_errorView.hidden == NO) {
        [_errorView buildToInterfaceOrientation:self.interfaceOrientation];
    }
    if (_resultView.hidden == NO) {
        [_resultView buildToInterfaceOrientation:self.interfaceOrientation];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(BACKGROUND, 1);
    isFirst = YES;
    
    self.view.backgroundColor = UIColorFromRGB(BACKGROUND, 1);
    AppDataObject *ado = [[S2LIRRequestMaker sharedClient] ado];;
    ado.capturedData = currentHistory.snapImage;
    if ([self.currentHistory.snapRecognized boolValue]) {
        _errorView.hidden = YES;
        _resultView.delegate = self;
        _resultView.history = self.currentHistory;
        SerializerAPI2 *serializer = [[SerializerAPI2 alloc] init];
        ObjectDef *obj = [serializer deserializeObjDef:self.currentHistory.snapServerResponse];
        [_resultView refreshUI:obj];
        _resultView.hidden = NO;
    }else{
        
        _resultView.hidden = YES;
        _errorView.hidden = NO;
        _errorView.history = self.currentHistory;
        _errorView.delegate = self;
        SerializerAPI2 *serializer = [[SerializerAPI2 alloc] init];
        ErrorDef *error;
        
        NSLog(@"SERVER RESPONSE ERROR %@",self.currentHistory.snapServerResponse);
        if(self.currentHistory.snapServerResponse != nil)error = [serializer deserializeError:self.currentHistory.snapServerResponse];
        [_errorView refreshUIWithError:error];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
