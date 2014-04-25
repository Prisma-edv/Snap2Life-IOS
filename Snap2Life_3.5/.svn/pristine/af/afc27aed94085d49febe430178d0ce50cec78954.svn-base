//
//  s2lInfoViewController.m
//  snap2life suite
//
//  Created by Antonio Stilo on 08.04.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "s2lInfoViewController.h"
#import "PersistenceManager.h"
#import "Constants.h"
#import "s2lSnapWebViewController.h"
#import "s2lAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "UIButton+UIButton_style.h"

@interface s2lInfoViewController ()

@end

@implementation s2lInfoViewController
@synthesize scrollView,container,impressumLinkBtn,contactBtn,introText,introText1,introText2,introText3,versionLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLayoutSubviews
{
    NSLog(@"** s2lInfoViewController viewDidLayoutSubviews");
    /*if(!isIPad){
        scrollView.frame = self.view.bounds;
        if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)){
//            scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 300);
//            container.frame = CGRectMake(0, 0, 320, 900);
            [container setFrame:CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height)];
        }else{
            scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 400);
            container.frame = CGRectMake((self.view.bounds.size.width-320)/2, 0, 320, 900);
        }
        
   }*/
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //s2lAppDelegate *appDelegate = (s2lAppDelegate*)[[UIApplication sharedApplication] delegate];
    //appDelegate.rotation = NO;
}
-(void)viewDidAppear:(BOOL)animated
{
  
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Info";
    
    self.view.backgroundColor = UIColorFromRGB(BACKGROUND, 1.0);
    
    UIToolbar *toolbar = self.navigationController.toolbar;
    toolbar.tintColor = UIColorFromRGB(BACKGROUND, 1.0);
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.tintColor = UIColorFromRGB(BACKGROUND, 1.0);
    
    [self.impressumLinkBtn setStyle];
    [self.contactBtn setStyle];
    
    /*
    UIToolbar *toolbar = self.navigationController.toolbar;
    //toolbar.tintColor = UIColorFromRGB(LANGE_DARK_GREY_9, 1.0);
    [toolbar setShadowImage:[[UIImage alloc]init] forToolbarPosition:UIToolbarPositionAny];
    [toolbar setBackgroundImage:[UIImage imageNamed:@"bottom_bar.PNG"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.tintColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    // Position each element by means of a variable offset.

    */
    
    self.navigationController.navigationBarHidden = NO;
    // The title.
    CGFloat offset = 10;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        offset = 44;
    }
    if (isIPad) {
        offset = 240;
    }
    
    CGRect frame;
    NSString *introLblTxt = NSLocalizedString(@"about_intro_text", nil);
    [introText setText:introLblTxt];
    //[introText setTextColor:UIColorFromRGB(LANGE_DARK_GREY_80, 1.0)];
    [introText setFont:[UIFont boldSystemFontOfSize:13]];
    [introText sizeToFit];
    frame = [introText frame];
    frame.origin.y = offset;
    [introText setFrame:frame];
    offset += frame.size.height + 5;
    
    // The first paragraph.
    NSString *intro1LblTxt = NSLocalizedString(@"about_intro_text_1", nil);
    [introText1 setText:intro1LblTxt];
    [introText1 setFont:[UIFont systemFontOfSize:12]];
    //[introText1 setTextColor:UIColorFromRGB(GREY, 1.0)];
    [introText1 setNumberOfLines:0];
    [introText1 sizeToFit];
    frame = [introText1 frame];
    frame.origin.y = offset;
    [introText1 setFrame:frame];
    offset += frame.size.height + 10;
    
    // Make the rendering of a second and third paragraph dependent on whether the localised text fields are filled.
    NSString *intro2LblTxt = NSLocalizedString(@"about_intro_text_2", nil);
    if (intro2LblTxt != nil && [intro2LblTxt length] > 0) {
        [introText2 setText:intro2LblTxt];
        [introText2 setFont:[UIFont systemFontOfSize:13]];
        //[introText2 setTextColor:UIColorFromRGB(GREY, 1.0)];
        [introText2 setNumberOfLines:0];
        [introText2 sizeToFit];
        frame = [introText2 frame];
        frame.origin.y = offset;
        [introText2 setFrame:frame];
        offset += frame.size.height + 10;
    }
    else {
        [introText2 setHidden:YES];
    }
    
    NSString *intro3LblTxt = NSLocalizedString(@"about_intro_text_3", nil);
    if (intro3LblTxt != nil && [intro3LblTxt length] > 0) {
        [introText3 setText:intro3LblTxt];
        [introText3 setFont:[UIFont systemFontOfSize:12]];
        //[introText3 setTextColor:UIColorFromRGB(GREY, 1.0)];
        [introText3 setNumberOfLines:0];
        [introText3 sizeToFit];
        frame = [introText3 frame];
        frame.origin.y = offset;
        [introText3 setFrame:frame];
        offset += frame.size.height + 10;
        [introText3 sizeToFit];
    }
    else {
        [introText3 setHidden:YES];
    }
    
    // Contact button.
    offset += 10;
    NSString *aboutContactLblTxt = NSLocalizedString(@"about_contact_btn", nil);
    [contactBtn setTitle:aboutContactLblTxt forState:UIControlStateNormal];
    [[contactBtn titleLabel] setFont:[UIFont systemFontOfSize:15]];
    //[[contactBtn titleLabel] setTextColor:UIColorFromRGB(GREY, 1.0)];
    frame = [contactBtn frame];
    frame.origin.y = offset;
    [contactBtn setFrame:frame];
    
    // Make the rendering of an Impressum button dependent on whether the localised text field is filled.
    NSString *aboutImpressumLblTxt = NSLocalizedString(@"about_impressum_btn", nil);
    if (aboutImpressumLblTxt != nil && [aboutImpressumLblTxt length] > 0) {
        [impressumLinkBtn setTitle:aboutImpressumLblTxt forState:UIControlStateNormal];
        [[impressumLinkBtn titleLabel] setFont:[UIFont systemFontOfSize:15]];
        //[[impressumLinkBtn titleLabel] setTextColor:UIColorFromRGB(GREY, 1.0)];
        frame = [impressumLinkBtn frame];
        frame.origin.y = offset;
        [impressumLinkBtn setFrame:frame];
    }
    else {
        // Hide the Impressum button and centre the Contact button.
        [impressumLinkBtn setHidden:YES];
        frame = [contactBtn frame];
        frame.origin.x = (contactBtn.superview.frame.size.width - contactBtn.frame.size.width) / 2;
        [contactBtn setFrame:frame];
    }
    offset += contactBtn.frame.size.height + 10;
    
    //Legacy
   // NSString *versionLblTxt = NSLocalizedString(@"about_version_text",@"about_version_text");
   //  [versionLabelText setText:versionLblTxt];
    
    // Get the version number from the project settings.
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [versionLabel setText:[NSString stringWithFormat:@"%@: %@",LABEL,version]];
    [versionLabel setFont:[UIFont systemFontOfSize:10]];
    [versionLabel setTextColor:[UIColor blackColor]];
    [versionLabel setTextAlignment:NSTextAlignmentRight];
    frame = [versionLabel frame];
    frame.origin.y = offset;
    [versionLabel setFrame:frame];
    offset += versionLabel.frame.size.height + 10;
    
    // Set scrollView size to span the whole dynamic height.
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width,offset)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)openWebUrl:(NSString *)urlString
{
    
    PersistenceManager *pm =[PersistenceManager sharedInstance];
    Settings *settings = [pm settings];
    
    if(![[settings settingBrowser] boolValue]){
        UIStoryboard *storyboard = self.storyboard;
        s2lSnapWebViewController *webViewController = [storyboard instantiateViewControllerWithIdentifier:@"web"];
        s2lAppDelegate *appDelegate = (s2lAppDelegate*)[UIApplication sharedApplication].delegate;
        appDelegate.urlToOpen = urlString;
        [self presentViewController:webViewController animated:YES completion:nil];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }

}

#pragma mark - IBActions

- (IBAction)impressumButtonPressed:(id)sender {
    NSString* impressumUrl = NSLocalizedString(@"url_impressum", nil);
    NSString* link =  (impressumUrl != nil && [impressumUrl length] > 0)? impressumUrl: IMPRESSUM_URL;
    [self openWebUrl:link];
}

- (IBAction)contactButtonPressed:(id)sender {
    // URLencode the "mailto:..." string because its Subject may contain blanks and other disallowed characters.
    NSString* encodedUrl = [CONTACT_URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* emailContact = NSLocalizedString(@"email_contact", nil);
    if (emailContact != nil && [emailContact length] > 0) {
        NSRange range = [emailContact rangeOfString:@"mailto:"];
        if (range.location != 0) emailContact = [NSString stringWithFormat:@"mailto:%@", emailContact];
        
        NSString* emailSubject = NSLocalizedString(@"email_subject", nil);
        emailSubject = [emailSubject stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        encodedUrl = [NSString stringWithFormat:@"%@?subject=%@", emailContact, emailSubject];
    }
    if (DEBUG_VERBOSE) NSLog(@"Opening mail client for encoded URL: %@", encodedUrl);
    
    NSURL *url = [NSURL URLWithString:encodedUrl];
    [[UIApplication sharedApplication] openURL:url];
}

-(BOOL)shouldAutorotate
{
    return NO;
}

@end
