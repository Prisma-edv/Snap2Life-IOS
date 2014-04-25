//
//  s2lImagePickerViewController.m
//  snap2life suite
//
//  Created by Volker Brendel on 24.01.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "s2lImagePickerViewController.h"
#import "s2lAppDelegate.h"
#import "s2lSnapWebViewController.h"
#import "s2lSettingsTableViewViewController.h"
#import "s2lARSelectionViewController.h"
#import "ASVirtualButton.h"
#import "s2lResultCommentViewController.h"
#import "PersistenceManager.h"
#import "Settings.h"
#import "S2LIRRequestMaker.h"
#import "UIImage-Extensions.h"
#import "S2LSerializerAPI2.h"
#import "Extra.h"
#import "QCARVirtualButtonDef.h"
#import "SerializerAPI2.h"
#import "UIImage-Extensions.h"
#import "S2LErrorViewController.h"
#import "S2LNewResultViewController.h"
#import "S2LNavigationUtils.h"
#import "History.h"
#import "S2LGPSHistoryView.h"
#import "AFS2LAppAPIClient.h"
#import "ErrorDef.h"

@interface s2lImagePickerViewController ()

@end

@implementation s2lImagePickerViewController
@synthesize ado;
@synthesize overlayView;

#pragma mark - SYNTHETISE Loading
@synthesize scannerView;
@synthesize shutter;
@synthesize takePictureButton;
@synthesize arView;
@synthesize isARCameraBuilded;
@synthesize popover;
@synthesize arViewController;
@synthesize currentHistory;

#define degreesToRadians(x) (M_PI * x / 180.0)
#define radiandsToDegrees(x) (x * 180.0 / M_PI)

#define ARC4RANDOM_MAX      0x100000000

#define randomS(x) (((double)arc4random() / ARC4RANDOM_MAX) * x)

- (float)getHeadingForDirectionFromCoordinate:(CLLocationCoordinate2D)fromLoc toCoordinate:(CLLocationCoordinate2D)toLoc
{
    float fLat = degreesToRadians(fromLoc.latitude);
    float fLng = degreesToRadians(fromLoc.longitude);
    float tLat = degreesToRadians(toLoc.latitude);
    float tLng = degreesToRadians(toLoc.longitude);
    
    float degree = radiandsToDegrees(atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng)))-270;
    //float degree = radiandsToDegrees(atan2(tLng-fLng, tLat-fLat)) - 90;
    
    if (degree >= 0) {
        return degree;
    } else {
        return 360+degree;
    }
}


#pragma mark Menu Segue

-(IBAction)settingsHandler:(id)sender
{
    [self performSegueWithIdentifier:@"newsettingsSegue" sender:nil];
}

-(IBAction)aboutHandler:(id)sender
{
    [self performSegueWithIdentifier:@"aboutSegue" sender:nil];
}

-(IBAction)profileHandler:(id)sender
{
    [self performSegueWithIdentifier:@"profileSegue" sender:nil];
}

-(IBAction)communityHandler:(id)sender
{
    [self performSegueWithIdentifier:@"communitySegue" sender:nil];
}

-(IBAction)gpsHandler:(id)sender
{
    AppDataObject *_ado = [[S2LIRRequestMaker sharedClient] ado];
    if (!isGPS) {
        gpsContainer =  [[UIView alloc] initWithFrame:self.view.bounds];
        gpsContainer.backgroundColor = [UIColor clearColor];
        [self.view addSubview:gpsContainer];
        [self.view bringSubviewToFront:menuView];
        [self.view bringSubviewToFront:sideMenuView];
        PersistenceManager *pm = [PersistenceManager sharedInstance];
        NSArray *histories = [pm allHistories];
        [histories enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            History *history = (History*)obj;
            S2LGPSHistoryView *snap = [[S2LGPSHistoryView alloc] initWithFrame:CGRectMake(-300, -300, 60, 60)];
            [snap build:history];
            snap.y = ((self.view.frame.size.height - 100) * (randomS(10.0)/10.0));
            [gpsContainer addSubview:snap];
        }];

        
        _ado.gpsController.headDelegate = self;
        //[_ado.gpsController.locManager startUpdatingHeading];
    }else{
        [gpsContainer removeFromSuperview];
        gpsContainer = nil;
        //[_ado.gpsController.locManager stopUpdatingHeading];
    }
    
    isGPS = !isGPS;
}

-(void)locationHead:(CLHeading*)_head onLocation:(CLLocation *)_location
{

    head -= (head-_head.magneticHeading)/36;
    float y = _head.y;
    location = _location;
    float degreesAngle = -head-45;
    float angle = degreesToRadians(degreesAngle);
    gpsBtn.transform = CGAffineTransformMakeRotation(angle);
    
    float w = self.view.frame.size.width / 2;
    //float h = self.view.frame.size.height / 2;
    if (isGPS) {
        
        [gpsContainer.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            S2LGPSHistoryView *snap = (S2LGPSHistoryView*)obj;
            History *history = snap.history;
            CLLocationCoordinate2D snapLocation = CLLocationCoordinate2DMake([history.snapLatitude floatValue], [history.snapLongitude floatValue]);
            snap.bearing = [self getHeadingForDirectionFromCoordinate:snapLocation toCoordinate:location.coordinate];
            float degreesBearing =  -head + snap.bearing;
            float bearing = degreesToRadians(degreesBearing);
            NSLog(@"IDX:%f :: %f    %i = %f | %f ",head,y,idx,snap.bearing,degreesBearing);
            float x = w + ((w) * bearing);
            float yy = snap.y + ((-y/360.0)*(self.view.frame.size.height));
            [snap move:CGPointMake(x, yy)];
        }];
    }
}

-(void)gpsUpdate
{

}

#pragma mark S2LARDelegate

-(void)initARView
{
    [preloader removeFromSuperview];
    preloader = nil;
    
    PersistenceManager *pm = [PersistenceManager sharedInstance];
    if (![pm.settings.settingAR boolValue]) {
        isARCameraBuilded = YES;
        if(isIPad)self.navigationController.toolbar.userInteractionEnabled = YES;
    }

}

-(void)finishARView{}

-(void)finishLoadDataSet
{
    [preloader removeFromSuperview];
    preloader = nil;
    isARCameraBuilded = YES;
    if(isIPad)self.navigationController.toolbar.userInteractionEnabled = YES;
    [self.view bringSubviewToFront:menuView];
    [self.view bringSubviewToFront:sideMenuView];
}

-(void)renderARFrame:(NSString *)trackableName andIndex:(NSInteger)index
{
    NSLog(@"Render renderARFrame");
    if(!overlayView.isSwipe){
        overlayView.isSwipe = TRUE;
        [overlayView resetFinderView];
    }

    if (![oldTrackableNames containsObject:trackableName]) {
        PersistenceManager *persistentManager = [PersistenceManager sharedInstance];
        [persistentManager interactionLogItemWithLink:@"AR" withTargetName:trackableName andType:@"TRACKED"];
        [oldTrackableNames addObject:trackableName];
        
        if (PLAY_JINGLE) {
            [shutter stop];
            NSURL* musicFile = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"jingle_bells" ofType:@"mp3"]];
            NSError *error;
            shutter = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFile error:&error];
            [shutter play];
        }
    }
    

}

-(void)renderNotFound
{

    NSLog(@"Render NOT FOUND");
    if (overlayView.isSwipe) {
        [overlayView resetFinderView];
    }
    overlayView.isSwipe = FALSE;

    
    if(PLAY_JINGLE){
        [shutter stop];
    }
}

-(void)virtualButtonIsPressed:(QCARVirtualButtonDef *)button
{
 
    NSLog(@"V BUTTON %@",button.link);
    //[self performSelectorOnMainThread:@selector(openWebUrlAndStore:) withObject:button.link waitUntilDone:NO];
    [self openWebUrlAndStore:button.link andTargetName:button.name];

}

#pragma mark ------------

- (void) setTorchOn:(BOOL)isOn
{
    [arViewController setFalsh:isOn];
}

-(IBAction)setFlash:(id)sender
{
    isFlashOn = !isFlashOn;
    [self setTorchOn:isFlashOn];
    flashBtn.selected = isFlashOn;
}

-(void)resetFlash
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    BOOL hasFlash = [device hasFlash];
    if(hasFlash){
        isFlashOn = NO;
        flashBtn.selected = isFlashOn;
        flashBtn.hidden = NO;
        [self.view bringSubviewToFront:flashBtn];
    }else{
        flashBtn.hidden = YES;
    }
}

-(void)commentHandler
{
    
    s2lResultCommentViewController *commentViewController = [[s2lResultCommentViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:commentViewController];
    nc.navigationBar.tintColor = [UIColor blackColor];
    
    [self presentViewController:nc animated:YES completion:^{}];
    
}

-(void)shearOnTweeter:(UIImage*)snap
{
    [S2LNavigationUtils shearOnTweeter:snap fromViewController:self];
}

-(void)shearOnFaceBook:(UIImage*)snap
{
    [S2LNavigationUtils shearOnFaceBook:snap fromViewController:self];
}

-(void)openWebUrlAndStore:(NSString*)urlString andTargetName:(NSString*)name
{
    [S2LNavigationUtils openWebUrlAndStore:urlString andTargetName:name fromViewController:self];
    
}


-(void)closeCamera
{

    [overlayView removeFromSuperview];
    [arViewController.view removeFromSuperview];
    arViewController = nil;
    isARCamera = NO;
    
}


- (void)handleTwoFingersSnap
{
        [self takePicture:YES];
}

- (void) animateScannerBar{
    BOOL rubberBand = RUBBER_BAND_ANIMATION; // If true, applies "viscosity" to the animation.
    CGRect loadingImageRect = CGRectMake(0, 0, self.view.bounds.size.width, 30);
    scannerView.hidden = NO;
    [scannerView setFrame:loadingImageRect];
    [[self view] addSubview:scannerView];
    
	CABasicAnimation *theAnimation;
	theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    if (rubberBand) {
        theAnimation.duration=1.5;
        [theAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:@"easeInEaseOut"]]; // linear, easeIn
    }
    else {
        theAnimation.duration=2;
    }
    int startValue = 0;
    int value = self.view.frame.size.height;
	theAnimation.repeatCount=100;
	theAnimation.autoreverses=YES;
	theAnimation.fromValue=[NSNumber numberWithFloat:startValue];
	theAnimation.toValue=[NSNumber numberWithFloat:value];
	[scannerView.layer addAnimation:theAnimation forKey:@"animateLayer"];
}


/**
 Plays a sound when the picture is taken
 */
-(void)playShutterSound{
    
    //if sound is disabled on the settings, than be quiet.
    PersistenceManager *pm = [PersistenceManager sharedInstance];
    NSLog(@"** SOUND IS %d",[pm.settings.settingSound boolValue]);

    if (![pm.settings.settingSound boolValue]) return;
    
	NSURL* musicFile = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"shutter" ofType:@"wav"]];
    NSError *error;
    shutter = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFile error:&error];
    [shutter play];
}

-(void)changeScreen:(NSObject *)obj
{

    if ([obj isKindOfClass:[ObjectDef class]]) {
        SerializerAPI2 *serializer = [[SerializerAPI2 alloc] init];
        NSString *snapServerResponse = [serializer serializeObjDef:(ObjectDef*)obj];
        PersistenceManager *pm = [PersistenceManager sharedInstance];
        if([pm.settings.settingHistory boolValue])[pm removeHistoryItem:currentHistory];
        [self persistHistoryAsSuccess:obj forResponse:snapServerResponse];
        [self changeToResultScreen:(ObjectDef*)obj];
    }else{
        [self changeToErrorScreen:(ErrorDef*)obj];
    }
    
    snapButton.enabled = YES;
}

-(void)evaluateBestMatch:(UIImage*)snap
{
    
    AFS2LAppAPIClient *client = [AFS2LAppAPIClient sharedClient];
    S2LIRRequestMaker *requestMaker = [S2LIRRequestMaker sharedClient];
    if ([client isReachable]) {
        [requestMaker evaluateBestMatch:snap success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument) {
            S2LSerializerAPI2 *serializer = [[S2LSerializerAPI2 alloc] init];
            NSLog(@"XML: %@",XMLDocument);
            NSObject *obj = [serializer deserializeObjectDef:XMLDocument];
            if (obj == nil) {
                obj = [serializer deserializeError:XMLDocument];
            }
            [self persistHistoryAsSuccess:obj forResponse:[NSString stringWithFormat:@"%@",XMLDocument]];
            [self changeScreen:obj];
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument) {
            
        }];
        
        [self animateScannerBar];
        [self playShutterSound];
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert_connection_bestmatch_title", nil) message:NSLocalizedString(@"alert_connection_bestmatch_message", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"alert_confirm", nil) otherButtonTitles: nil];
        [alert show];
        requestMaker.ado.capturedData = UIImagePNGRepresentation(snap);
        ErrorDef *errorDef = [[ErrorDef alloc] init];
        [self persistHistoryAsSuccess:errorDef forResponse:@""];
        [self changeScreen:errorDef];
    
    }
}

- (void)takePicture:(BOOL)is2FS
{
    
    s2limageview.hidden = NO;
    arView.hidden = YES;
    
    if (!is2FS) {
        s2limageview.image = [[arViewController getSnap] imageRotatedByDegrees:90];
    }else{
        s2limageview.image = [[arViewController getSnap] imageRotateCropAndScale:YES withFinger1:overlayView.finger1 withFinger2:overlayView.finger2 withOrientation:self.interfaceOrientation];
    }
    [self evaluateBestMatch:s2limageview.image];
}

- (void) changeToErrorScreen:(ErrorDef*)error
{
    
    [preloader removeFromSuperview];
    preloader = nil;
    scannerView.hidden = YES;

    AppDataObject *_ado = [[S2LIRRequestMaker sharedClient] ado];
    _ado.capturedData = UIImagePNGRepresentation(s2limageview.image);
    
    S2LErrorViewController *errorVC = (S2LErrorViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"error"];
    errorVC.history = currentHistory;
    errorVC.errorObject = error;
    errorVC.resultIndex = 1;
    [self.navigationController pushViewController:errorVC animated:YES];
    
}


- (void) changeToSnapScreen
{
    if(!isPicker)arView.hidden = NO;
    
    snapButton.enabled = YES;
    
    arView.userInteractionEnabled = YES;
    isPicker = NO;
    BOOL firstRun = NO;
//    [self.view bringSubviewToFront:arView];

    if (overlayView==nil){
        overlayView = [[MyOverlayView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
        firstRun = YES;
    }
    
    overlayView.autoresizingMask = UIViewContentModeScaleAspectFill;
    [overlayView setDelegate:self];
    overlayView.touchDelegate = arViewController.arView;
    [overlayView setUserInteractionEnabled:YES];
    [overlayView setMultipleTouchEnabled:YES];
    [self.view addSubview:overlayView];
    [overlayView resetFinderView];
    [self resetFlash];
    
    [self.view bringSubviewToFront:sideMenuView];
    [self.view bringSubviewToFront:menuView];
    
}

- (void) changeToResultScreen:(ObjectDef*)obj
{
    [preloader removeFromSuperview];
    preloader = nil;
    scannerView.hidden = YES;
    
    SerializerAPI2 *serializer = [[SerializerAPI2 alloc] init];
    NSString *snapServerResponse = [serializer serializeObjDef:(ObjectDef*)obj];
    PersistenceManager *pm = [PersistenceManager sharedInstance];
    if([pm.settings.settingHistory boolValue])[pm removeHistoryItem:currentHistory];
    [self persistHistoryAsSuccess:obj forResponse:snapServerResponse];
    
    S2LNewResultViewController *resultVC = (S2LNewResultViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"result"];
    resultVC.history = currentHistory;
    resultVC.object = obj;
    resultVC.index = 1;
    [self.navigationController pushViewController:resultVC animated:YES];

}

- (void) changeToLoadingScreen:(UIImage*)image
{
    [takePictureButton setHidden:YES];
    
    s2limageview.hidden = NO;
    s2limageview.image = image;
    [arViewController.view removeFromSuperview];
    arView.hidden = YES;
    [self animateScannerBar];
    [takePictureButton setImage:[UIImage imageNamed:@"cancel_button.png"] forState:UIControlStateNormal];
    
}

-(void)resendImageForRecognition:(History*)history
{

    if (![[AFS2LAppAPIClient sharedClient] isReachable]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You don´t have internet connection. The Snap will be saved on your device and you can send it when you´ll have internet connection again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }else{
        UIImage *snap =  [UIImage imageWithData:history.snapImage];
        [self evaluateBestMatch:snap];
    }
}

#pragma mark Controller

-(void)updateAR
{
   
    PersistenceManager *pm = [PersistenceManager sharedInstance];
    arViewController.isAR = [pm.settings.settingAR boolValue];
    if ([pm.settings.settingAR boolValue]) {
        if (![oldPackageURL isEqualToString:pm.settings.packageDownloadURL]) {
            oldPackageURL = pm.settings.packageDownloadURL;
            ARpackage *package = [pm arPackageForURL:pm.settings.packageDownloadURL];
            if(package){
                [preloader removeFromSuperview];
                preloader = nil;
                preloader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                preloader.frame = CGRectMake(self.view.frame.size.width-preloader.frame.size.width-6, 24, preloader.frame.size.width, preloader.frame.size.height);
                [preloader startAnimating];
                [self.view addSubview:preloader];
                
                NSLog(@"Selected Package %@",pm.settings.packageDownloadURL);
                arViewController.isAR = [pm.settings.settingAR boolValue];
                
                [arViewController loadPackage:package];
            }else{
                isARCameraBuilded = YES;
                if(isIPad)self.navigationController.toolbar.userInteractionEnabled = YES;
            }
        }
    }
}

-(void)openARCamera
{

    NSLog(@"isARCamera %d",isARCamera);
    if (!isARCamera) {

        if (arViewController == nil) {
            CGRect screenBounds = [[UIScreen mainScreen] bounds];
            arViewController = [[ARViewController alloc] initWithSize:screenBounds.size];
            arViewController.arDelegate = self;
            [arView addSubview:arViewController.view];
            oldPackageURL = @"";
            [self performSelector:@selector(updateAR) withObject:nil afterDelay:2.5];
            isARCameraBuilded = NO;
            if(isIPad)self.navigationController.toolbar.userInteractionEnabled = NO;
            oldTrackableNames = [NSMutableArray array];
            
        }else{
            arViewController.arDelegate = self;
            isARCameraBuilded = YES;
            if(isIPad)self.navigationController.toolbar.userInteractionEnabled = YES;
        }
        

        isARCamera = YES;
        [self changeToSnapScreen];
      
    }else{
        snapButton.enabled = NO;
        [self takePicture:NO];
    }
}

-(IBAction)openPicker:(id)sender
{
    isARCameraBuilded = YES;
    isARCamera = NO;
    takePictureButton.hidden = YES;
    s2limagepicker = [[UIImagePickerController alloc] init];
    s2limagepicker.delegate = self;
    [s2limagepicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    if(!isIPad){
        [self presentViewController:s2limagepicker animated:YES completion:NULL];
    }else{
        popover = [[UIPopoverController alloc] initWithContentViewController:s2limagepicker];
        popover.delegate = self;
        [popover presentPopoverFromRect:[(UIButton*)sender frame]
                                 inView:self.view
               permittedArrowDirections:UIPopoverArrowDirectionAny
                               animated:YES];
    }

}

- (IBAction)camera:(id)sender {
    
   [self performSelector:@selector(openARCamera) withObject:nil afterDelay:0.1];
}

-(IBAction)openARPreferences
{
    
    if(isARCameraBuilded){
        s2lARSelectionViewController *selectionController = [[s2lARSelectionViewController alloc] initWithNibName:nil bundle:nil];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectionController];
        navController.navigationBar.tintColor = [UIColor blackColor];
        
        selectionController.isModal = YES;
        [self presentViewController:navController animated:YES completion:^{}];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self dismissViewControllerAnimated:YES completion:^{}];
    isPicker = YES;
    UIImage *_s2limage = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *s2limage =  [_s2limage imageByScalingToSize:self.view.bounds.size];
    s2limageview.image = s2limage;
    s2limageview.hidden = NO;
    arView.hidden = YES;
    if(isIPad)[popover dismissPopoverAnimated:YES];
    [self evaluateBestMatch:s2limage];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    arView.hidden = NO;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    
    return isARCameraBuilded;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"settings"])
    {
        //[self closeCamera];
    }
}

-(void)viewWillLayoutSubviews
{
    
    [arViewController handleARViewRotation:self.interfaceOrientation];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [arViewController pauseCamera];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    NSLog(@"VIEW DID LOAD");
    [super viewDidLoad];
     isPicker = NO;
    takePictureButton.hidden = YES;
    scannerView.hidden = YES;
    arView.hidden = NO;
    head = 0.0;
    isGPS = NO;
    
    UIToolbar *toolbar = self.navigationController.toolbar;
    toolbar.tintColor = UIColorFromRGB(BACKGROUND, 1.0);
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.tintColor = UIColorFromRGB(BACKGROUND, 1.0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"*********MEMORYWARNING****************");
    //[[[S2LIRRequestMaker sharedClient] ado] setCapturedData:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [menuView setParentFrame:self.view.bounds];
     arView.hidden = NO;
    if(arViewController == nil){
        preloader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        preloader.center = self.view.center;
        [preloader startAnimating];
        [self.view addSubview:preloader];
        isARCamera = NO;
        [self performSelector:@selector(openARCamera) withObject:nil afterDelay:0.6];
    }else{
        isARCameraBuilded = YES;
        [arViewController performSelector:@selector(resumeCamera) withObject:nil afterDelay:0.6];
        //[arViewController resumeCamera];
        [self changeToSnapScreen];
        [self updateAR];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    currentHistory = nil;
    s2limageview.hidden = YES;
    scannerView.hidden = YES;
    
    s2lAppDelegate *appDelegate = (s2lAppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.imagePicker = self;

    //[sc setTitle:NSLocalizedString(@"ar_segmented_first", nil) forSegmentAtIndex:0];
    //[sc setTitle:NSLocalizedString(@"ar_segmented_second", nil) forSegmentAtIndex:1];
    
    libraryButton.title = NSLocalizedString(@"ar_ipad_library", nil);
}

- (void)persistHistoryAsSuccess:(NSObject*)obj forResponse:(NSString*)responseString{
   
    
    // Check if the History setting is set.
    PersistenceManager* persistenceManager = [PersistenceManager sharedInstance];
    if (![persistenceManager.settings.settingHistory boolValue]) return;
    
    BOOL wasSuccessful = NO;
    if ([obj isKindOfClass:[ObjectDef class]]) {
        wasSuccessful = YES;
    }
    
    History *history = [persistenceManager createHistory];
    
    // Set the History to the captured image and a current timestamp
    history.snapDate = [NSDate date];
    
    AppDataObject *mado = [[S2LIRRequestMaker sharedClient] ado];
    
    // Set the location info of the snap if the device has GPS activated and user has allowed it.
    history.snapLatitude = (mado.deviceInfo.latitude != nil)? [NSNumber numberWithFloat:[mado.deviceInfo.latitude floatValue]]: nil;
    history.snapLongitude = (mado.deviceInfo.longitude != nil)? [NSNumber numberWithFloat:[mado.deviceInfo.longitude floatValue]]: nil;
    history.snapHorizAcc = (mado.deviceInfo.hAcc != nil)? [NSNumber numberWithFloat:[mado.deviceInfo.hAcc floatValue]]: nil;
    
    if(wasSuccessful){
        history.snapTitle = [[(ObjectDef*)obj infos] title];
        history.snapDesc = [[(ObjectDef*)obj infos] desc];
        Extra *extra = (Extra*)[[[(ObjectDef*)obj extras] extra] objectAtIndex:0];
        history.snapID = [NSNumber numberWithInt:[extra.value integerValue]];
    }

    history.snapImage = mado.capturedData;
    // History title and description are not yet used: perhaps later for user details?
    history.snapHasVoted = [NSNumber numberWithBool:NO];
    history.snapFavourite = [NSNumber numberWithBool:NO];
    // Set the response success and responseString (may be null if send attempted while offline).
    history.snapRecognized = [NSNumber numberWithBool:wasSuccessful];
    history.snapServerResponse = responseString;
    
    currentHistory = history;
    // Sve the new or updated History.
    [persistenceManager saveAll];
}

-(void)dealloc
{
   if(!isIPad)[self closeCamera];
}

@end

