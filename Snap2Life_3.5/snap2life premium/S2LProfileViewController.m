//
//  S2LProfileViewController.m
//  snap2life suite
//
//  Created by iOS on 25.11.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "S2LProfileViewController.h"
#import "s2lAppDelegate.h"
#import "PersistenceManager.h"
#import "UIButton+UIButton_style.h"
#import "s2lSnapMapViewController.h"
#import "s2lHistoryCell.h"
#import "SerializerAPI2.h"
#import "S2LNewResultViewController.h"
#import "S2LErrorViewController.h"
#import "AppDataObject.h"
#import "S2LIRRequestMaker.h"

@interface S2LProfileViewController ()

@end

@implementation S2LProfileViewController
@synthesize table;

#pragma mark UITableView

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    History *history = [data objectAtIndex:indexPath.row];
    SerializerAPI2 *serializer = [[SerializerAPI2 alloc] init];
    UIViewController *vc;
    if ([history.snapRecognized boolValue]) {
        vc = [self.storyboard instantiateViewControllerWithIdentifier:@"result"];
        [(S2LNewResultViewController*)vc setHistory:history];
        [(S2LNewResultViewController*)vc setIndex:2];
        [(S2LNewResultViewController*)vc setObject:[serializer deserializeObjDef:history.snapServerResponse]];
    }else{
        vc = [self.storyboard instantiateViewControllerWithIdentifier:@"error"];
        [(S2LErrorViewController*)vc setHistory:history];
        [(S2LErrorViewController*)vc setResultIndex:2];
        [(S2LErrorViewController*)vc setErrorObject:[serializer deserializeError:history.snapServerResponse]];
    }
    
    AppDataObject *ado = [[S2LIRRequestMaker sharedClient] ado];
    ado.capturedData = history.snapImage;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"CellHistory";//[NSString stringWithFormat:@"historyCell_%u",indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // Setup the cell with its title, description, active-switch and background image.
        cell = [[s2lHistoryCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    [(s2lHistoryCell*)cell setDelegate:self];
    // Fill in the cell's image, title and description.
    History* history = [data objectAtIndex:[indexPath row]];
    [((s2lHistoryCell *)cell) setHistory:history];
    
    [((s2lHistoryCell *)cell) setIsSelectable:YES];
    
    UIImageView *imgV;
    if ([history.snapToSendForPdf boolValue]) {
        imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"_check.png"]];
        //cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"_check_unselected.png"]];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.accessoryView = imgV;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PersistenceManager *pm = [PersistenceManager sharedInstance];
        [pm removeHistoryItem:[data objectAtIndex:indexPath.row]];
        [self capturedHandler:isCapturedOn];
        //[self.data removeObjectAtIndex:indexPath.row];
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


// Override to support rearranging the table view.
/*
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 History *movedHistory = [self.data objectAtIndex:fromIndexPath.row];
 [self.data removeObjectAtIndex:fromIndexPath.row];
 [self.data insertObject:movedHistory atIndex:toIndexPath.row];
 
 }
 */


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark Profile

#pragma mark History

-(IBAction)mapHandler:(id)sender
{
    UIStoryboard *storyboard = self.storyboard;
    s2lSnapMapViewController *webViewController = [storyboard instantiateViewControllerWithIdentifier:@"map"];
    [self.navigationController pushViewController:webViewController animated:YES];

}

-(IBAction)historySwitch:(id)sender
{
    int value = [(UISegmentedControl*)(sender) selectedSegmentIndex];
    
   // if(!isIPad){
        switch (value) {
            case 0:
                isCapturedOn = YES;
                break;
            case 1:
                isCapturedOn = NO;
                break;
                
            default:
                break;
        }
        [self capturedHandler:isCapturedOn];
    //}
}

#pragma mark UIViewController

-(void)sendPDFImmagesHandler
{
    sendPdfImmages.enabled = NO;
    uploader = [[s2lUploaderForPDF alloc] init];
    uploader.delegate = self;
    
    NSMutableArray *sendableImages = [NSMutableArray array];
    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        History *history = (History*)obj;
        if ([history.snapToSendForPdf boolValue]) {
            [sendableImages addObject:history];
        }
    }];
    
    if(sendableImages.count > 0)[uploader startUploading:sendableImages];
}

-(void)eraseHandler
{
    NSMutableArray *eraseImages = [NSMutableArray array];
    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        History *history = (History*)obj;
        if ([history.snapToSendForPdf boolValue]) {
            [eraseImages addObject:history];
        }
    }];
    
    PersistenceManager *pm = [PersistenceManager sharedInstance];
    [eraseImages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [pm deleteHistory:(History *)obj];
    }];
    
    [self capturedHandler:isCapturedOn];

}
-(void)alertErase
{
    isLoggin = NO;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert_erase_confirm_title", nil) message:NSLocalizedString(@"alert_erase_confirm_message", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"alert_confirm", nil), nil];
    [alert show];
}

-(void)capturedHandler:(BOOL)isCaptured
{
    
    s2lAppDelegate *appDelegate = (s2lAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.isCapturedOn = isCaptured;
    NSMutableArray *list = [NSMutableArray array];
    PersistenceManager *pm = [PersistenceManager sharedInstance];
    for(History *history in [pm allHistories]){
        if ([history.snapRecognized boolValue] == isCapturedOn && ![history.snapFavourite boolValue]) {
            [list addObject:history];
        }
    }
    if (list.count == 0){
        noRecords = [[UILabel alloc] initWithFrame:CGRectMake(historyView.frame.origin.x, historyView.frame.origin.y + segmented.frame.size.height + 50, historyView.frame.size.width, 44)];
        
        noRecords.numberOfLines = 2;
        noRecords.text = NSLocalizedString(@"history_placeholder", nil);
        noRecords.backgroundColor = [UIColor clearColor];
        noRecords.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:noRecords];
        table.tableFooterView = nil;
    }else{
        [noRecords removeFromSuperview];
        noRecords = nil;
        
        UIView *container = [[UIView alloc] init];
        container.backgroundColor = [UIColor clearColor];
        container.frame = CGRectMake(0, 0, table.frame.size.width, 90);
        
        UIButton *eraseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        eraseBtn.frame = CGRectMake(0, 0, table.frame.size.width, 44);
        [eraseBtn setBackgroundImage:[UIImage imageNamed:@"buttonbg.png"] forState:UIControlStateNormal];
        [eraseBtn setTitle:NSLocalizedString(@"erase_selected", nil) forState:UIControlStateNormal];
        [eraseBtn addTarget:self action:@selector(alertErase) forControlEvents:UIControlEventTouchUpInside];
        [eraseBtn setStyle];
        [container addSubview:eraseBtn];
        
        sendPdfImmages = [UIButton buttonWithType:UIButtonTypeCustom];
        sendPdfImmages.frame = CGRectMake(0, 46, table.frame.size.width, 44);
        [sendPdfImmages setBackgroundImage:[UIImage imageNamed:@"buttonbg.png"] forState:UIControlStateNormal];
        [sendPdfImmages setTitle:NSLocalizedString(@"history_snap_report", nil) forState:UIControlStateNormal];
        [sendPdfImmages addTarget:self action:@selector(sendPDFImmagesHandler) forControlEvents:UIControlEventTouchUpInside];
        [sendPdfImmages setStyle];
        sendPdfImmages.enabled = YES;
        [container addSubview:sendPdfImmages];
        if(!isCaptured){
            sendPdfImmages.hidden = YES;
        }
        
        table.tableFooterView = container;
    }
    data = list;
    [table reloadData];
}

-(void)logOutHandler
{
    isLoggin = YES;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logout" message:NSLocalizedString(@"profile_logout", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"alert_confirm", nil), nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (isLoggin) {
            [self logOut];
        }else{
            [self eraseHandler];
        }
    }
}

-(void)logOut
{
    PersistenceManager *pm = [PersistenceManager sharedInstance];
    
    UIImage* profileImage = [UIImage imageNamed:@"defaultProfile.png"];
    [pm.profile setAvatar:UIImagePNGRepresentation(profileImage)];
    [pm.profile setSecretImage:UIImagePNGRepresentation(profileImage)];
    pm.profile.skip = [NSNumber numberWithBool:YES];
    pm.profile.name = @"";
    pm.profile.email = @"";
    
    [pm saveAll];
    
    [self updateProfile];
    
    [logOutBtn setTitle:@"Register" forState:UIControlStateNormal];
    [logOutBtn removeTarget:self action:@selector(logOutHandler) forControlEvents:UIControlEventTouchUpInside];
    [logOutBtn addTarget:self action:@selector(registerHandler) forControlEvents:UIControlEventTouchUpInside];
    
    if (sendPdfImmages != nil) {
        sendPdfImmages.hidden = YES;
    }

}

-(void)registerHandler
{
    PersistenceManager *pm = [PersistenceManager sharedInstance];
    pm.profile.skip = [NSNumber numberWithBool:NO];
    [pm saveAll];
    //UIViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.toolbarHidden = YES;
    [self capturedHandler:isCapturedOn];
}

-(void)updateProfile
{
    PersistenceManager *persistentManager = [PersistenceManager sharedInstance];
    NSString* profileEmail = persistentManager.profile.email;
    NSString* profileName = persistentManager.profile.name;
    UIImage* profileImage = [UIImage imageWithData:persistentManager.profile.avatar];
    
    nameLabel.text = profileName;
    emailLabel.text = profileEmail;
    avatar.image = profileImage;
    
    avatar.layer.cornerRadius = 20;
    [avatar.layer masksToBounds];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIToolbar *toolbar = self.navigationController.toolbar;
    toolbar.tintColor = UIColorFromRGB(BACKGROUND, 1.0);
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.tintColor = UIColorFromRGB(BACKGROUND, 1.0);
    
    if (SYSTEM_VERSION_GREATER_THAN(@"7.0")) {
        navBar.translucent = NO;
    }
    
    isProfileOn = NO;
    
    s2lAppDelegate *appDelegate = (s2lAppDelegate*)[[UIApplication sharedApplication] delegate];
    isCapturedOn = appDelegate.isCapturedOn;
    
    [segmented setTitle:NSLocalizedString(@"history_record", nil) forSegmentAtIndex:0];
    [segmented setTitle:NSLocalizedString(@"history_not_record", nil) forSegmentAtIndex:1];
    if(isCapturedOn)
        segmented.selectedSegmentIndex = 0;
    else
        segmented.selectedSegmentIndex = 1;
    
    self.navigationController.navigationBarHidden = NO;
    
    table.dataSource = self;
    table.delegate = self;
    table.separatorColor = UIColorFromRGB(PROFILEBCKCOLOR, 1);
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    table.rowHeight = 46;
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        table.separatorInset = UIEdgeInsetsZero;
    }

    
    [self updateProfile];


    PersistenceManager *persistentManager = [PersistenceManager sharedInstance];
    if([persistentManager.profile.skip boolValue] == YES)
    {
        [logOutBtn setTitle:@"Register" forState:UIControlStateNormal];
        [logOutBtn addTarget:self action:@selector(registerHandler) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [logOutBtn setTitle:@"Log out" forState:UIControlStateNormal];
        [logOutBtn addTarget:self action:@selector(logOutHandler) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
