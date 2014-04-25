//
//  s2lARPreferencesViewController.m
//  snap2life suite
//
//  Created by Antonio Stilo on 21.02.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "s2lARPreferencesViewController.h"
#import "AppDataObject.h"
#import "PersistenceManager.h"
#import "s2lAppDelegate.h"
#import "GalleryItem.h"
#import "UIButton+UIButton_style.h"
#import "s2lSnapWebViewController.h"
#import "PurchaseAlert.h"
#import "AFS2LAppAPIClient.h"
#import "s2lGalleryViewController.h"

@interface s2lARPreferencesViewController ()

@property (nonatomic,strong) UIPopoverController *popover;

@end

@implementation s2lARPreferencesViewController
@synthesize popover;

-(NSArray *)getPossibledownloads
{
    /*NSDictionary *dict0 = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"http://www.snap2life.de/content/ar/snap2life/stock/arpackage.xml",@"url",
                            @"0: Default",@"name", nil];
    
    NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"http://www.snap2life.de/content/ar/snap2life_ads/stock/arpackage.xml",@"url",
                            @"1: Ads",@"name", nil];
    
    NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"http://www.snap2life.de/content/ar/snap2life_cards/stock/arpackage.xml",@"url",
                            @"2: Cards",@"name", nil];
    
    NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"http://www.snap2life.de/content/ar/snap2life_catalog/stock/arpackage.xml",@"url",
                            @"3: Catalog",@"name", nil];
    
    NSDictionary *dict4 = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"http://www.snap2life.de/content/ar/snap2life_construct/stock/arpackage.xml",@"url",
                           @"4: Construct",@"name", nil];
    
    NSDictionary *dict5 = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"http://www.snap2life.de/content/ar/snap2life_pilot/stock/arpackage.xml",@"url",
                           @"5: Pilot",@"name", nil];
    
    NSDictionary *dict6 = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"http://www.snap2life.de/content/ar/lange/stock/arpackage.xml",@"url",
                           @"6: Lange",@"name", nil];
    
    NSArray *list = [NSArray arrayWithObjects:dict0,dict1,dict2,dict3,dict4,dict5,dict6, nil];
    */
    
    PersistenceManager *persistenceManager = [PersistenceManager sharedInstance];
    return [persistenceManager allGalleryItems];

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _arPackages = [self getPossibledownloads];
        //self.view.backgroundColor = [UIColor blackColor];
        
        _container = [[UIView alloc] initWithFrame:self.view.bounds];
        _container.backgroundColor = UIColorFromRGB(BACKGROUND, 1);
        
        _scroll = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        _scroll.backgroundColor = UIColorFromRGB(BACKGROUND, 1);
        [self.view addSubview:_scroll];
        
        self.view.backgroundColor = [UIColor lightGrayColor];
        _arStatus = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 120, 30)];
        _arStatus.text = NSLocalizedString(@"ar_activate", nil);
        _arStatus.textColor = [UIColor blackColor];
        _arStatus.backgroundColor = UIColorFromRGB(BACKGROUND, 1);
        [_container addSubview:_arStatus];
        
        PersistenceManager *pm = [PersistenceManager sharedInstance];
        
        _switchController = [[UISwitch alloc] initWithFrame:CGRectMake(320-80, 20, 100, 30)];
        [_switchController setOn:[[[pm settings] settingAR] boolValue]];
        [_switchController addTarget:self action:@selector(switchHandler:) forControlEvents:UIControlEventValueChanged];
        [_container addSubview:_switchController];
        
        _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 60, [[UIScreen mainScreen] bounds].size.width, 200)];
        _picker.delegate = self;
        _picker.dataSource = self;
        _picker.showsSelectionIndicator = YES;
        [_container addSubview:_picker];
        
        _detailButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _detailButton.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width-300)/2, _picker.frame.origin.y+_picker.frame.size.height+10, 300, 40);
        [_detailButton setTitle:NSLocalizedString(@"ar_detail_label", nil) forState:UIControlStateNormal];
        [_detailButton addTarget:self action:@selector(detailHandler) forControlEvents:UIControlEventTouchUpInside];
        [_detailButton setStyle];
        [_container addSubview:_detailButton];
        
        _downloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _downloadButton.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width-300)/2, _detailButton.frame.origin.y+_detailButton.frame.size.height+10, 300, 40);
        [_downloadButton setTitle:NSLocalizedString(@"ar_package_update_select", nil) forState:UIControlStateNormal];
        [_downloadButton addTarget:self action:@selector(downloadHandler) forControlEvents:UIControlEventTouchUpInside];
        [_downloadButton setStyle];
        [_container addSubview:_downloadButton];
        
        _tutorialButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _tutorialButton.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width-300)/2, _downloadButton.frame.origin.y+_downloadButton.frame.size.height+10, 300, 40);
        [_tutorialButton setTitle:NSLocalizedString(@"ar_tutorial", nil) forState:UIControlStateNormal];
        [_tutorialButton addTarget:self action:@selector(tutorialHandler) forControlEvents:UIControlEventTouchUpInside];
        [_tutorialButton setStyle];
        [_container addSubview:_tutorialButton];
        
        [_scroll addSubview:_container];
        GalleryItem *item = [_arPackages objectAtIndex:0];
        _selectedDownloadURLString = item.packageHref;
        
    }
    return self;
}

-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    return NO;
}

-(void)viewWillLayoutSubviews
{
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        _scroll.contentSize = CGSizeMake(320, 400);
        _container.frame = CGRectMake(0,0,320,400);
    }else{
        _scroll.contentSize = CGSizeMake(320, 500);
        _container.frame = CGRectMake((480-320)/2,0,320,400);
    }
    if (isIPad) {
        _container.frame = CGRectMake(0, 0, 768, 1000);
        self.view.backgroundColor = [UIColor yellowColor];
    }
    _scroll.frame = self.view.bounds;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    isDownloadCompleated = NO;
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // TO DO STILO
    //s2lAppDelegate *appDelegate = (s2lAppDelegate*)[UIApplication sharedApplication].delegate;
    //if(isDownloadCompleated)appDelegate.ado.packageIndex = 0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(BACKGROUND, 1);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return _arPackages.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    GalleryItem *item = _arPackages[row];
    return item.label;
}

#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    _selectedDownloadURLString = nil;
    selected = row;
    GalleryItem *item = _arPackages[selected];
    _selectedDownloadURLString = [item.packageHref copy];
}

-(void)switchHandler:(id)sender
{
    UISwitch *button = (UISwitch*)sender;
    BOOL onChange = [button isOn];
    PersistenceManager *pm = [PersistenceManager sharedInstance];
    [[pm settings] setSettingAR:[NSNumber numberWithBool:onChange]];
    [pm saveAll];
}
-(void)downloadHandler
{
    if (![[AFS2LAppAPIClient sharedClient] isReachable]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert_warning", nil)
                                                        message:NSLocalizedString(@"transfer_error", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"alert_confirm", nil)
                                              otherButtonTitles: nil];
        [alert show];
        
        return;
    }
    
    if (!isIPad) {
        UIActivityIndicatorView *wheel = [[UIActivityIndicatorView alloc] init];
        wheel.center = CGPointMake(self.view.bounds.size.width*0.5, self.view.bounds.size.height*0.5);
        [wheel startAnimating];
        UIView *container = [[UIView alloc] initWithFrame:self.view.bounds];
        container.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        [container addSubview:wheel];
        [self.view addSubview:container];
        
        S2LDownloaderActionSheet *downloader = [[S2LDownloaderActionSheet alloc] initWithURLPath:_selectedDownloadURLString
                                                                                  automaticStart:YES
                                                                                         success:^{
                                                                                             [container removeFromSuperview];
                                                                                         }
                                                                                           abort:^{
                                                                                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert_warning", nil)
                                                                                                                                               message:NSLocalizedString(@"alert_already_downloaded", nil)
                                                                                                                                              delegate:nil
                                                                                                                                     cancelButtonTitle:NSLocalizedString(@"alert_confirm", nil)
                                                                                                                                     otherButtonTitles: nil];
                                                                                               [alert show];
                                                                                               [container removeFromSuperview];
                                                                                           } failure:^{[container removeFromSuperview];}];
    }else{
    
        S2LDownloadPopOverViewController* downloader = [[S2LDownloadPopOverViewController alloc]initWithURLPath:_selectedDownloadURLString automaticStart:YES success:^{[popover dismissPopoverAnimated:YES];} abort:^{
            [popover dismissPopoverAnimated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert_warning", nil)
                                                            message:NSLocalizedString(@"alert_already_downloaded", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"alert_confirm", nil)
                                                  otherButtonTitles: nil];
            [alert show];

        } failure:^{[popover dismissPopoverAnimated:YES];}];
        
        popover = [[UIPopoverController alloc] initWithContentViewController:downloader];
        [popover presentPopoverFromRect:_tutorialButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        popover.delegate = self;
    
    
    
    }

}

-(void)openWebUrl:(NSString *)urlString
{
    PersistenceManager * pm = [PersistenceManager sharedInstance];
    Settings *settings = [pm settings];
    
    if(![[settings settingBrowser] boolValue]){
        NSString *storyboardName;
        if (isIPad) {
            storyboardName = @"MainStoryboard_ok_iPad";
        } else {
            storyboardName = @"MainStoryboard_iPhone";
        }
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
        s2lSnapWebViewController *webViewController = [storyBoard instantiateViewControllerWithIdentifier:@"web"];
        s2lAppDelegate *appDelegate = (s2lAppDelegate*)[UIApplication sharedApplication].delegate;
        appDelegate.urlToOpen = urlString;
        [self presentViewController:webViewController animated:YES completion:nil];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
    
}

-(void)tutorialHandler
{
    NSLog(@"** OPEN TUTORIAL: %@",NSLocalizedString(@"ar_tutorial_link", nil));
    [self openWebUrl:NSLocalizedString(@"ar_tutorial_link", nil)];

}

-(void)detailHandler
{
    NSString *storyboardName;
    if (isIPad) {
        storyboardName = @"MainStoryboard_ok_iPad";
    } else {
        storyboardName = @"MainStoryboard_iPhone";
    }
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    s2lGalleryViewController *gallery = [storyBoard instantiateViewControllerWithIdentifier:@"gallery"];
    gallery.selectedPackage = _selectedDownloadURLString;
    //[self presentViewController:gallery animated:YES completion:NULL];
    [self.navigationController pushViewController:gallery animated:YES];
    
    
   /* PurchaseAlert *detailAlert = [[PurchaseAlert alloc] initWithTitle:item.label message:item.detailDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    detailAlert.item = item;
    if (item.detailPassword && ![item.detailPassword isEqualToString:@""]) {
        UILabel *lastLabel = (UILabel*)[detailAlert.subviews objectAtIndex:detailAlert.subviews.count-2];
        UITextField *passwordField = [[UITextField alloc] initWithFrame:CGRectMake(lastLabel.frame.origin.x, lastLabel.frame.origin.y+lastLabel.frame.size.height+5, lastLabel.frame.size.width, 35)];
        [detailAlert addSubview:passwordField];
    }
    [detailAlert show];
    */
}


@end
