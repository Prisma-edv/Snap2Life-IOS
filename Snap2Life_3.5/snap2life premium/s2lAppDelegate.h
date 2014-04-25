//
//  s2lAppDelegate.h
//  snap2life premium
//
//  Created by Volker Brendel on 18.01.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "PersistenceManager.h"
#import "Settings.h"
#import "History.h"
#import "s2lTrackingUtils.h"
#import "GAI.h"
#import "S2LDownloadPopOverViewController.h"



@interface s2lAppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate,UIPopoverControllerDelegate>


@property (nonatomic,strong)  UIPopoverController *popover;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,assign) NSInteger packageIndex;
@property (nonatomic,assign) int usageStart;
@property (nonatomic,unsafe_unretained) id<GAITracker> tracker;
@property (nonatomic, strong) Settings *settings;
@property (nonatomic, copy) NSString *urlToOpen;
@property (nonatomic,strong) s2lTrackingUtils *sender;
@property (nonatomic, weak) id imagePicker;
@property BOOL wasInBackground;
@property BOOL isReady;
@property BOOL isCapturedOn;
@property BOOL isSavedHistory;

//Persistence
@property (nonatomic, strong) PersistenceManager* persistenceManager;


@end
