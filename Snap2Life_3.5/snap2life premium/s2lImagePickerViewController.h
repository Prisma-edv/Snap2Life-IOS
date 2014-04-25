//
//  s2lImagePickerViewController.h
//  snap2life suite
//
//  Created by Volker Brendel on 24.01.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>
#import "AppDataObject.h"
#import "MyOverlayView.h"
#import "s2lResultView.h"
#import "s2lErrorSubview.h"
#import "ARViewController.h"
#import "S2LARDelegate.h"
#import "History.h"
#import "S2LMenuView.h"
#import "S2LCoreLocationController.h"
#import "Constants.h"

@interface s2lImagePickerViewController : UIViewController <MyOverlayViewDelegate,S2LARDelegate,ResultViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UINavigationBarDelegate, WebViewDelegate,UIPopoverControllerDelegate, S2LCoreLocationControllerDelegate> {
    
    IBOutlet UISegmentedControl *sc;
    IBOutlet UIImageView *s2limageview;
    IBOutlet UIView *arView;
    IBOutlet S2LMenuView *menuView;
    IBOutlet UIView *sideMenuView;
    IBOutlet UIButton *snapButton;
    IBOutlet UIButton *flashBtn;
    IBOutlet UIBarButtonItem *libraryButton;
    IBOutlet UIView *bottomBar;
    IBOutlet UIButton *gpsBtn;
    UIImagePickerController *s2limagepicker;
    SLComposeViewController *mySLComposerSheet;
    UIActivityIndicatorView *preloader;
    NSMutableArray *oldTrackableNames;
    NSString *oldPackageURL;
    
    BOOL isFlashOn;
    BOOL isARCamera;
    BOOL isGPS;
    BOOL isPicker;
    CGFloat headingX;
    UIView *gpsContainer;
    
    float head;
    CLLocation *location;

}

@property (nonatomic, unsafe_unretained) AppDataObject *ado;
@property (nonatomic,strong) AVAudioPlayer *shutter;
@property (nonatomic,retain) UIView *arView;
@property (nonatomic,strong) UIPopoverController *popover;
@property (nonatomic, strong) MyOverlayView *overlayView;
@property (nonatomic, strong) IBOutlet UIImageView *scannerView;
@property (nonatomic, strong) IBOutlet UIButton *takePictureButton;
@property (nonatomic,strong) ARViewController *arViewController;
@property (nonatomic,strong) History *currentHistory;
@property BOOL isARCameraBuilded;



- (void)takePicture:(BOOL)is2FS;

- (void) changeToLoadingScreen:(UIImage*)image;
- (void) changeToSnapScreen;
- (void) changeToResultScreen:(ObjectDef*)obj;
- (void) changeToErrorScreen:(ErrorDef*)error;
-(void)shearOnFaceBook:(UIImage*)snap;
-(void)shearOnTweeter:(UIImage*)snap;
-(void)resetFlash;

-(IBAction)openPicker:(id)sender;
-(IBAction)camera:(id)sender;
-(IBAction)openARPreferences;
-(IBAction)setFlash:(id)sender;


// MENU SEGUE

-(IBAction)settingsHandler:(id)sender;
-(IBAction)aboutHandler:(id)sender;
-(IBAction)profileHandler:(id)sender;
-(IBAction)communityHandler:(id)sender;
-(IBAction)gpsHandler:(id)sender;

@end
