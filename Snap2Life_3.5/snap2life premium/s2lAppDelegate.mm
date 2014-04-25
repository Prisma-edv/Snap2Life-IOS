//
//  s2lAppDelegate.m
//  snap2life premium
//
//  Created by Volker Brendel on 18.01.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "s2lAppDelegate.h"
#import "s2lImagePickerViewController.h"
#import "AFNetworking.h"
#import "S2LIRRequestMaker.h"
#import "S2LDownloaderActionSheet.h"
#import "PushNotificationManager.h"



#define kGOOGLE_ID @"77319931"

@implementation s2lAppDelegate

@synthesize window,popover,
wasInBackground,
persistenceManager,
urlToOpen,isReady,sender,isCapturedOn,isSavedHistory,imagePicker,tracker,usageStart,packageIndex;



- (void) onPushAccepted:(PushNotificationManager *)pushManager withNotification:(NSDictionary *)pushNotification {
    NSLog(@"Push notification received");

}

#pragma mark DBDelegate Protocol

- (NSMutableArray*)allHistories {
    return [self.persistenceManager allHistories];
}

- (History*)createHistory {
    return [self.persistenceManager createHistory];
}

// Deletes a specific History from the ordered list of Histories.
- (BOOL)removeHistoryItem:(History*)toDelete {
    return [self.persistenceManager removeHistoryItem:toDelete];
}

-(void)cleanHistory
{
    [self.persistenceManager deleteAllHistoriesOlderThenDays:[self.persistenceManager.settings.historyExpiring integerValue]];
}

#pragma mark DB Access methods

-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    return NO;
}

-(void)update
{

        if (!isIPad) {
            S2LDownloaderActionSheet *downloader = [[S2LDownloaderActionSheet alloc] initWithURLPath:GALLERY_PACKAGE_URL automaticStart:YES success:^{
                [self checkARPackage];
            } abort:^{
                [[[S2LIRRequestMaker sharedClient] ado] locationStart];
                [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
                 (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
            } failure:^{
                [[[S2LIRRequestMaker sharedClient] ado] locationStart];
                [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
                 (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
            }];
        }else{
            
            S2LDownloadPopOverViewController* downloader = [[S2LDownloadPopOverViewController alloc] initWithURLPath:GALLERY_PACKAGE_URL automaticStart:YES success:^{
                [self checkARPackage];
            } abort:^{
                [popover dismissPopoverAnimated:YES];
                [[[S2LIRRequestMaker sharedClient] ado] locationStart];
                [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
                 (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
            } failure:^{
                [popover dismissPopoverAnimated:YES];
                [[[S2LIRRequestMaker sharedClient] ado] locationStart];
                [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
                 (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
            }];
            
            popover = [[UIPopoverController alloc] initWithContentViewController:downloader];
            [popover presentPopoverFromRect:CGRectMake(335, 980, 100, 1) inView:window permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            popover.delegate = self;
            
        }

}

-(void)checkARPackage
{
    
    if (!isIPad) {
        S2LDownloaderActionSheet *downloader = [[S2LDownloaderActionSheet alloc] initWithURLPath:AR_STOCK_PACKAGE_URL automaticStart:YES success:^{
            PersistenceManager *pm = [PersistenceManager sharedInstance];
            [pm.settings setSettingAR:[NSNumber numberWithBool:YES]];
            [pm saveAll];
            [[[S2LIRRequestMaker sharedClient] ado] locationStart];
        } abort:NULL failure:NULL];
    }else{
        S2LDownloadPopOverViewController* downloader = [[S2LDownloadPopOverViewController alloc]initWithURLPath:AR_STOCK_PACKAGE_URL automaticStart:YES success:^{[popover dismissPopoverAnimated:YES];PersistenceManager *pm = [PersistenceManager sharedInstance];
            [pm.settings setSettingAR:[NSNumber numberWithBool:YES]];
            [pm saveAll];[[[S2LIRRequestMaker sharedClient] ado] locationStart];} abort:^{[popover dismissPopoverAnimated:YES];} failure:^{[popover dismissPopoverAnimated:YES];}];
        
        popover.delegate = self;
        popover.contentViewController = downloader;
    }
    
}

#pragma APP DELEGATE


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    isReady = NO;
    isCapturedOn = YES;
    
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = NO;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    // Optional: set debug to YES for extra debugging information.
    //[GAI sharedInstance].debug = YES;
    // Create tracker instance.
    
    usageStart = [NSDate timeIntervalSinceReferenceDate];
    tracker = [[GAI sharedInstance] trackerWithTrackingId:kGOOGLE_ID];
    
    
    [AFS2LAppAPIClient sharedClient];
    [S2LIRRequestMaker sharedClient];

    self.persistenceManager = [PersistenceManager sharedInstance];
    Settings* settings = [persistenceManager settings];
    if (settings == nil) {
        // If settings could be neither retrieved nor a new one inserted, raise an alert.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"db_error_title", nil)
                                                        message:NSLocalizedString(@"db_error_desc", nil)
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        return YES;
    }
    
    [persistenceManager galleryPackage];
    [self cleanHistory];
    
    AppDataObject *ado = [[S2LIRRequestMaker sharedClient] ado];
    ado.deviceInfo.deviceId = settings.settingDeviceID;
    if([persistenceManager.settings.settingGPS boolValue])[ado locationStart];
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", @"error MSG")
														message:NSLocalizedString(@"no_camera", @"no_camera MSG")
													   delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
		[alert show];
    }
    if (DEBUG_VERBOSE) NSLog(@"applicationDidFinishLaunching completed");


    
    [[UITabBar appearance] setTintColor:UIColorFromRGB(BACKGROUND, 1)];
    //if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
   // {
        
        NSDictionary *textTitleOptions = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor], UITextAttributeTextColor, [UIColor clearColor], UITextAttributeTextShadowColor, nil];
        [[UINavigationBar appearance] setTitleTextAttributes:textTitleOptions];
        [[UIBarButtonItem appearance] setTitleTextAttributes:textTitleOptions forState:UIControlStateNormal];
        [[UIBarButtonItem appearance] setTitleTextAttributes:textTitleOptions forState:UIControlStateHighlighted];
    //}
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	if (DEBUG_VERBOSE) NSLog(@"applicationWillResignActive");

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	if (DEBUG_VERBOSE) NSLog(@"applicationDidEnterBackground");
    
    // TO DO STILO
    //if (CLController.locMgr!=nil) [CLController.locMgr stopUpdatingLocation];

    
    int usageEnd = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval usage = usageEnd-usageStart;
    
    [tracker sendTimingWithCategory:@"Snap2Life" withValue:usage withName:@"Usage time" withLabel:@""];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	if (DEBUG_VERBOSE) NSLog(@"applicationWillEnterForeground");
    sender = [[s2lTrackingUtils alloc] init];
    [sender sendInteractionLog];
    [(s2lImagePickerViewController*)imagePicker resetFlash];
    
}

// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
- (void)applicationDidBecomeActive:(UIApplication *)application
{
	if (DEBUG_VERBOSE) NSLog(@"applicationDidBecomeActive");
    if(!isReady)[self update];
    isReady = YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	if (DEBUG_VERBOSE) NSLog(@"applicationWillTerminate");
    [[[S2LIRRequestMaker sharedClient] ado] locationStop];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    abort();
}

@end
