//
//  s2lNewSettingsViewController.m
//  snap2life suite
//
//  Created by Antonio Stilo on 31.05.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "s2lNewSettingsViewController.h"
#import "s2lARSelectionViewController.h"
#import "s2lSnapWebViewController.h"
#import "s2lAppDelegate.h"
#import "Constants.h"

@interface s2lNewSettingsViewController ()

@end

@implementation s2lNewSettingsViewController

-(void) rateApp
{

    NSString *reviewURL = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",APP_ID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)getSliderValue:(id)sender
{
    UISlider *slider = (UISlider*)sender;
    historyTitle.text = [NSString stringWithFormat:@"%@ %u %@",NSLocalizedString(@"settings_history_exparing", nil),(NSInteger)slider.value,NSLocalizedString(@"settings_history_day", nil)];
    
    PersistenceManager *pm = [PersistenceManager sharedInstance];
    [pm.settings setHistoryExpiring:[NSNumber numberWithInteger:(NSInteger)slider.value]];
    [pm saveAll];
}

-(void)prepareTable
{
    
    // NSArray *group1 = [NSArray arrayWithObjects:@"Info",@"FAQ",[NSString stringWithFormat:@"%@",NSLocalizedString(@"settings_gallery", nil)], nil];
    NSArray *group2 = [NSArray arrayWithObjects:@"Augmented Reality",[NSString stringWithFormat:@"%@",NSLocalizedString(@"newsettings_settings", nil)], nil];
    NSArray *group3 = [NSArray arrayWithObjects:@"Facebook",@"Twitter", nil];
    NSArray *group4 = [NSArray arrayWithObjects:@"Rate Us",@"Follow Us",@"Like Us", nil];
    NSArray *group5 = [NSArray arrayWithObjects:@"Feedback", nil];
    // NSArray *group6 = [NSArray arrayWithObjects:@"History", nil];
    
    data = [NSMutableArray arrayWithObjects:group2,group3,group4,group5, nil];
    [tableView reloadData];
    
    historyTitle = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-280)/2, tableView.contentSize.height+20, 280, 40)];
    historyTitle.textAlignment = UITextAlignmentLeft;
    historyTitle.backgroundColor = [UIColor clearColor];
    [scroll addSubview:historyTitle];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake((self.view.frame.size.width-280)/2, tableView.contentSize.height+40, 280, 40)];
    slider.minimumValue = 15;
    slider.maximumValue = 45;
    PersistenceManager *pm = [PersistenceManager sharedInstance];
    slider.value = [pm.settings.historyExpiring integerValue];
    [slider setTintColor:UIColorFromRGB(GREEN, 1.0)];
    [slider addTarget:self action:@selector(getSliderValue:) forControlEvents:UIControlEventValueChanged];
    [scroll addSubview:slider];
    
    historyTitle.text = [NSString stringWithFormat:@"%@ %u %@",NSLocalizedString(@"settings_history_exparing", nil),(NSInteger)slider.value,NSLocalizedString(@"settings_history_day", nil)];
    
    UILabel *historyValue0 = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-280)/2, tableView.contentSize.height+60, 80, 40)];
    historyValue0.text = [NSString stringWithFormat:@"15 %@",NSLocalizedString(@"settings_history_day", nil)];
    historyValue0.backgroundColor = [UIColor clearColor];
    historyValue0.font = [UIFont systemFontOfSize:10];
    [scroll addSubview:historyValue0];
    
    UILabel *historyValue1 = [[UILabel alloc]initWithFrame:CGRectMake(((self.view.frame.size.width-280)/2)+120, tableView.contentSize.height+60, 80, 40)];
    historyValue1.text = [NSString stringWithFormat:@"30 %@",NSLocalizedString(@"settings_history_day", nil)];;
    historyValue1.backgroundColor = [UIColor clearColor];
    historyValue1.font = [UIFont systemFontOfSize:10];
    [scroll addSubview:historyValue1];
    
    UILabel *historyValue2 = [[UILabel alloc]initWithFrame:CGRectMake(((self.view.frame.size.width-280)/2)+240, tableView.contentSize.height+60, 80, 40)];
    historyValue2.text = [NSString stringWithFormat:@"45 %@",NSLocalizedString(@"settings_history_day", nil)];
    historyValue2.backgroundColor = [UIColor clearColor];
    historyValue2.font = [UIFont systemFontOfSize:10];
    [scroll addSubview:historyValue2];
    
    
    
    scroll.contentSize = CGSizeMake(320, 800);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return data.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[data objectAtIndex:section] count];
}

-(UITableViewCell*)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellMark = @"cellSettingsNew";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellMark];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellMark];
        cell.backgroundColor = UIColorFromRGB(FRONT_GREY, 1);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    cell.textLabel.text = [[data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)openARPreferences
{
    NSLog(@"** OPEN AR PREFERENCES **");
    s2lARSelectionViewController *selectionController = [[s2lARSelectionViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:selectionController animated:YES];
    self.navigationController.toolbarHidden = YES;
}

-(void)shearOnTweeter:(UIImage*)snap
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"I am using Snap2Life: "];
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

-(void)shearOnFacebook:(UIImage*)snap
{
    //if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) //check if Facebook Account is linked
    //{
    SLComposeViewController *mySLComposerSheet = [[SLComposeViewController alloc] init]; //initiate the Social Controller
    mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook]; //Tell him with what social plattform to use it, e.g. facebook or twitter
    [mySLComposerSheet setInitialText:[NSString stringWithFormat:@"I am using Snap2Life: "]]; //the message you want to post
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

- (void)sendEmail
{
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
    
    NSURL *url = [NSURL URLWithString:encodedUrl];
    [[UIApplication sharedApplication] openURL:url];
}

-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0: [self openARPreferences]; break;
                case 1: [self performSegueWithIdentifier:@"settingsSegue" sender:self]; break;
                default: break;
            }

        }else if (indexPath.section == 1) {
            switch (indexPath.row) {
                case 0: [self shearOnFacebook:[UIImage imageNamed:@"logo.png"]]; break;
                case 1: [self shearOnTweeter:[UIImage imageNamed:@"logo.png"]]; break;
                default: break;
            }
        }else if (indexPath.section == 2) {
            switch (indexPath.row) {
                case 0: [self rateApp]; break;
                case 1: [self openWebUrl:@"https://twitter.com/snap2lifeapp"]; break;
                case 2: [self openWebUrl:@"https://www.facebook.com/snap2lifeapp"]; break;
                default: break;
            }
        }else if (indexPath.section == 3) {
            switch (indexPath.row) {
                case 0: [self sendEmail]; break;
                default: break;
            }
        }
        else if (indexPath.section == 4) {
            switch (indexPath.row) {
                case 0: [self performSegueWithIdentifier:@"historySegue" sender:self]; break;
                default: break;
            }
        }
}


-(void)openWebUrl:(NSString *)urlString
{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"";
            break;
        case 1:
            sectionName = @"Features";
            break;
        case 2:
            sectionName = @"Social Connect";
            break;
        case 5:
            sectionName = @"History";
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"Settings";
    self.navigationController.navigationBarHidden = NO;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIToolbar *toolbar = self.navigationController.toolbar;
    toolbar.tintColor = UIColorFromRGB(BACKGROUND, 1.0);
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.tintColor = UIColorFromRGB(BACKGROUND, 1.0);
    
    scroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scroll.backgroundColor = UIColorFromRGB(BACKGROUND, 1);
    [self.view addSubview:scroll];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 220, 45)];
    title.backgroundColor = UIColorFromRGB(BACKGROUND, 1);
    title.textColor = UIColorFromRGB(TITLE, 1);
    title.text = NSLocalizedString(@"settings_title", nil);
    title.font = [UIFont boldSystemFontOfSize:14];
    [scroll addSubview:title];
    
    CGRect tableFrame = CGRectMake(0, 50, self.view.bounds.size.width, 800);
    tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped];
    tableView.backgroundColor = UIColorFromRGB(BACKGROUND, 1);
    tableView.backgroundView = nil;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = UIColorFromRGB(BACKGROUND, 1);
    [scroll addSubview:tableView];
    
    /*UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 220, 45)];
    title.backgroundColor = UIColorFromRGB(BACKGROUND, 1);
    title.textColor = UIColorFromRGB(TITLE, 1);
    title.text = @"snap2life - Einstellungen";
    title.font = [UIFont boldSystemFontOfSize:14];
    [scroll addSubview:title];
    */
    [self prepareTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
