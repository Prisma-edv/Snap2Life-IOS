//
//  s2lSettingsTableViewViewController.m
//  snap2life suite
//
//  Created by Antonio Stilo on 26.02.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "s2lSettingsTableViewViewController.h"
#import "S2LIRRequestMaker.h"
#import "AppDataObject.h"
#import "s2lAppDelegate.h"
#import "s2lARSelectionViewController.h"
#import "s2lUserPreferencesViewController.h"

#define ID_2FS @"ID_2FS"
#define ID_GPS @"ID_GPS"
#define ID_SOUND @"ID_SOUND"
#define ID_AR @"ID_AR"
#define ID_HISTORY @"ID_HISTORY"
#define ID_PUT_OPTION @"ID_PUT_OPTION"
#define ID_CIRCLE_CONNECT @"ID_CIRCLE_CONNECT"
#define ID_USER @"ID_USER"
#define ID_DEVICE_ID @"ID_DEVICE_ID"
#define ID_DOWNLOAD_URL @"ID_DOWNLOAD_URL"
#define ID_BROWSER @"ID_BROWSER"

#define CONTENT_VIEW_WIDTH 231.0  // These values used for absolute positioning of the download button.
#define CONTENT_VIEW_HEIGHT 108.0
#define DOWNLOAD_BUTTON_WIDTH 82.0
#define DOWNLOAD_BUTTON_HEIGHT 27.0

@interface s2lSettingsTableViewViewController ()
#pragma mark - Private properties and methods

// The data source for the table view: a list of NSMutableDictionaries, each
// containing an ID, title, description and a Boolean indicating whether set or not.
@property (nonatomic,strong) NSArray* data;

// A download button and an activity indicator used to hide it while checking for downloads.
@property (nonatomic,strong) UIButton* arDownloadButton;
@property (nonatomic,strong) UIActivityIndicatorView* activityIndicator;

// A weak reference to the AR cell so as to change the cell text.
@property (nonatomic,unsafe_unretained) UITableViewCell* arCell;

// Returns a data source for the table view by reading the app setting from the user db:
// a list of NSMutableDictionaries, each
// containing an ID, title, description and a Boolean indicating whether set or not.
- (NSArray*)createDataSource;

// Responder to the change of a settings UISwitch.
- (void)onChangeSetting:(id)sender;

// Responder to the pressing of the AR download button.
- (void)onClickDownload:(id)sender;
@end

@implementation s2lSettingsTableViewViewController

@synthesize dbDelegate;
@synthesize settingsDelegate;
@synthesize data;
@synthesize arDownloadButton;
@synthesize activityIndicator;
@synthesize arCell;

- (id)initWithStyle:(UITableViewStyle)style
{
    if (DEBUG_VERBOSE) NSLog(@"[SettingsTableViewController initWithStyle:%d]", style);
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    if (DEBUG_VERBOSE) NSLog(@"[SettingsTableViewController didReceiveMemoryWarning]");
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(void)backButtonHandler
{
    if(!isIPad){
        [self dismissViewControllerAnimated:YES completion:NULL];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(BACKGROUND, 1);
    self.tableView.backgroundColor = UIColorFromRGB(BACKGROUND, 1);
    self.tableView.backgroundView = nil;
    self.tableView.separatorColor = UIColorFromRGB(BACKGROUND, 1);
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))self.tableView.separatorInset = UIEdgeInsetsZero;
    
    UIToolbar *toolbar = self.navigationController.toolbar;
    toolbar.tintColor = UIColorFromRGB(BACKGROUND, 1.0);
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.tintColor = UIColorFromRGB(BACKGROUND, 1.0);
    
}

- (void)viewDidUnload
{
    if (DEBUG_VERBOSE) NSLog(@"[SettingsTableViewController viewDidUnLoad]");
    [super viewDidUnload];
    [self setData:nil];
    [self setArDownloadButton:nil];
    [self setActivityIndicator:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (DEBUG_VERBOSE) NSLog(@"[SettingsTableViewController viewWillAppear]");
    [super viewWillAppear:animated];

    //PersistenceManager *pm = [PersistenceManager sharedInstance];
    
    // Customize the underlying TableView for our own cell buttons.
    //[[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [[self tableView] setRowHeight:CONTENT_VIEW_HEIGHT];
    
    // Make a table header view.
    // Put the header in a container so that it can be indented.
    UIView* containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    UILabel* tableHeader = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 40)];
    [tableHeader setText:NSLocalizedString(@"settings_title_common",nil)];
    [tableHeader setBackgroundColor:[UIColor clearColor]];
    [tableHeader setTextColor:UIColorFromRGB(SEC_COLOR_1, 1.0)];
    [tableHeader setFont:[UIFont boldSystemFontOfSize:18.0]];
    [containerView addSubview:tableHeader];
    [[self tableView] setTableHeaderView:containerView];
    
    // Setup the AR download button, but hide until viewDidAppear: runs.
    [self setArDownloadButton:[UIButton buttonWithType:UIButtonTypeRoundedRect]];
    [[arDownloadButton titleLabel] setFont:[UIFont boldSystemFontOfSize:14.0]];
    [arDownloadButton setTitle:NSLocalizedString(@"button_update", nil) forState:UIControlStateNormal];
    [arDownloadButton addTarget:self
                         action:@selector(onClickDownload:)
               forControlEvents:UIControlEventTouchUpInside];
    [arDownloadButton setFrame:CGRectMake(0, 0, DOWNLOAD_BUTTON_WIDTH, DOWNLOAD_BUTTON_HEIGHT)];
    [arDownloadButton setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin];
    [arDownloadButton setHidden:YES];
    
    // Lazily setup the TableView's data source just before it appears.
    [self setData:[self createDataSource]];
    
    // Setup the activity indicator to run while checking if a download is necessary.
    [self setActivityIndicator:[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]];
    //    [activityIndicator setHidesWhenStopped:YES];

    [self.tableView reloadData];
}

// Checks the ARPackages in the stock and a remote directory looking for a difference in version number.
- (BOOL)dowloadPossible {

}

// Just before the view is displayed for the first time or refreshed, a check is
// made, whether a download is necessary. This requires an HTTP query, so the check
// is limited to 2 seconds. As a result, the download button is enabled or
// disabled accordingly. While the check is taking place, the download button is
// hidden by an activity indicator.
- (void)viewDidAppear:(BOOL)animated
{
    if (DEBUG_VERBOSE) NSLog(@"[SettingsTableViewController viewDidAppear]");
    [super viewDidAppear:animated];
    
    [arDownloadButton setHidden:YES];
    [activityIndicator setHidden:NO];
    [activityIndicator startAnimating];
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        BOOL downloadPossible = [self dowloadPossible];
        
        // Update UI widgets on the main thread, reactivating the download button as appropriate.
        dispatch_sync( dispatch_get_main_queue(), ^{
            [activityIndicator stopAnimating];
            [activityIndicator setHidden:YES];
            [arDownloadButton setEnabled:downloadPossible];
            [arDownloadButton setAlpha:downloadPossible? 1.0: 0.5];
            [arDownloadButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
            [arDownloadButton setHidden:NO];
            if (downloadPossible) [[arCell detailTextLabel] setText:NSLocalizedString(@"ar_download_text", nil)];
        });
    });
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (DEBUG_VERBOSE) NSLog(@"[SettingsTableViewController viewWillDisappear]");
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (DEBUG_VERBOSE) NSLog(@"[SettingsTableViewController viewDidDisappear]");
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



-(void)openUserPreferences
{
    s2lUserPreferencesViewController *userPreferences = [[s2lUserPreferencesViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:userPreferences animated:YES];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section - note only one section.
    return (section == 0)? [data count]: 0;
}

// Asks the data source for a cell to insert in a particular location of the table view.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell_%u",indexPath.row];
    // Fill in the cell's title, description and active-switch value.
    NSDictionary* dict = [data objectAtIndex:[indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // Setup the cell with its title, description, active-switch and background image.
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [[cell textLabel] setBackgroundColor:[UIColor clearColor]];
        [[cell textLabel] setTextColor:UIColorFromRGB(SEC_COLOR_1, 1.0)];
        [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15.0]];
        
        // The following code makes the description multiline. 
        [[cell detailTextLabel] setNumberOfLines:0];
        [[cell detailTextLabel] setBackgroundColor:[UIColor clearColor]];
        [[cell detailTextLabel] setTextColor:UIColorFromRGB(SEC_COLOR_3, 1.0)];
        [[cell detailTextLabel] setFont:[UIFont systemFontOfSize:14.0]];
        // Define the switch. The frame size is ignored by iOS.
        // Define a callback for the switch. Put it in the cell accessory space.
        if ([ID_AR isEqualToString:[dict objectForKey:@"id"]] || [ID_USER isEqualToString:[dict objectForKey:@"id"]]){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }else{
            UISwitch* onOffSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            [onOffSwitch addTarget:self
                            action:@selector(onChangeSetting:)
                  forControlEvents:UIControlEventValueChanged | UIControlEventTouchDragInside];
            [cell setAccessoryView:onOffSwitch];
        }
        
        // Disable the selectability of the text in the cell (only the buttons are of interest).
        //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        //[cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settingslistbg.png"]]];
        
        cell.backgroundColor = UIColorFromRGB(GREY, 1);
    }
    
    [[cell textLabel] setText:[dict objectForKey:@"title"]];
    [[cell detailTextLabel] setText:[dict objectForKey:@"desc"]];
    
    if ([ID_DEVICE_ID isEqualToString:[dict objectForKey:@"id"]] ||
        [ID_DOWNLOAD_URL isEqualToString:[dict objectForKey:@"id"]] || [ID_AR isEqualToString:[dict objectForKey:@"id"]]) {
        // TODO. No on-off switch for text fields. These should be entry fields.
        UISwitch* onOffSwitch = (UISwitch*) [cell accessoryView];
        [onOffSwitch setHidden:YES];
        //[cell.accessoryView removeFromSuperview];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        // Set the switch from the data source.
        // Add a reference to the current row in the switch's tag (this will be read in the switch's callback).
        UISwitch* onOffSwitch = (UISwitch*) [cell accessoryView];
        [onOffSwitch setOn:[[dict objectForKey:@"active"] boolValue]];
        [onOffSwitch setTag:[indexPath row]];
        [onOffSwitch setHidden:NO];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [data objectAtIndex:indexPath.row];
    if([ID_USER isEqualToString:[dict objectForKey:@"id"]]){
        [self openUserPreferences];
    }
    
}


// Responder callback to the change of a settings UISwitch.
- (void)onChangeSetting:(id)sender {
    UISwitch* onOffSwitch = (UISwitch*) sender;
    
    // Find the data source array index stored in the UISwitch's tag and persist its change.
    NSMutableDictionary* dict = [data objectAtIndex:[onOffSwitch tag]];
    
    // First modify the data source.
    NSNumber* onChange = [NSNumber numberWithBool:[onOffSwitch isOn]];
    [dict setObject:onChange forKey:@"active"];
    
    PersistenceManager *pm = [PersistenceManager sharedInstance];
    Settings *setting = [pm settings];
    
    // Then persist dependent on which db field it is.
    id settingsId = [dict objectForKey:@"id"];
    if ([ID_2FS isEqualToString:settingsId]) {
        [setting setSetting2FS:onChange];
    }
    else if ([ID_GPS isEqualToString:settingsId]) {
        AppDataObject *ado = [[S2LIRRequestMaker sharedClient] ado];
        if ([onChange boolValue]) {
            [ado locationStart];
        }else{
            [ado locationStop];
        }
        [setting setSettingGPS:onChange];
    }
    else if ([ID_SOUND isEqualToString:settingsId]) {
        [setting setSettingSound:onChange];
    }
    else if ([ID_HISTORY isEqualToString:settingsId]) {
        [setting setSettingHistory:onChange];
    }
    else if ([ID_PUT_OPTION isEqualToString:settingsId]) {
        [setting setSettingPutOption:onChange];
    }
    else if ([ID_CIRCLE_CONNECT isEqualToString:settingsId]) {
        [setting setSettingCircleConnect:onChange];
    }
    else if ([ID_BROWSER isEqualToString:settingsId]) {
        [setting setSettingBrowser:onChange];
    }
    
    
    [pm saveAll];
}

// Responder to the pressing of the AR download button.
- (void)onClickDownload:(id)sender {
    if (DEBUG_VERBOSE) NSLog(@"SettingsTableViewController download button pressed");
}

// Returns a data source for the table view by reading the app setting from the user db:
// a list of NSMutableDictionaries, each
// containing an ID, title, description and a Boolean indicating whether set or not.
- (NSArray*)createDataSource {
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:5];
    
    // The order of the following setup determines the order in the Settings screen.
    NSMutableDictionary *dict;
    
    PersistenceManager *pm = [PersistenceManager sharedInstance];
    
    // 2FS - presence dependent on compile switch.
    if (ACT_TWOFINGERSSNAP) {
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                ID_2FS, @"id",
                NSLocalizedString(@"settings_2fs_title",nil), @"title",
                NSLocalizedString(@"settings_2fs_desc",nil), @"desc",
                [NSNumber numberWithBool:[[[pm settings] setting2FS] boolValue]], @"active",
                nil];
        [arr addObject:dict];
    }
    
    // AR - presence dependent on compile switch.
   /*if (ACT_AR_MODE) {
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                ID_AR, @"id",
                NSLocalizedString(@"settings_ar_title",nil), @"title",
                NSLocalizedString(@"settings_ar_desc",nil), @"desc",
                [NSNumber numberWithBool:[pm.settings.settingAR boolValue]], @"active",
                nil];
        [arr addObject:dict];
    }*/
    
    // PUT option - presence dependent on compile switch.
    if (ACT_PUT_OPTION) {
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                ID_PUT_OPTION, @"id",
                NSLocalizedString(@"settings_put_title",nil), @"title",
                NSLocalizedString(@"settings_put_desc",nil), @"desc",
                [NSNumber numberWithBool:[[[pm settings] settingPutOption] boolValue]], @"active",
                nil];
        [arr addObject:dict];
    }
    
    // History - presence dependent on compile switch.
    if (ACT_HISTORY) {
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                ID_HISTORY, @"id",
                NSLocalizedString(@"settings_historic_title",nil), @"title",
                NSLocalizedString(@"settings_historic_desc",nil), @"desc",
                [NSNumber numberWithBool:[[[pm settings] settingHistory] boolValue]], @"active",
                nil];
        [arr addObject:dict];
    }
    
    
    // GPS - presence of the setting dependent on whether the user allowed the GPS capability at app start.
    //if (ado.deviceInfo.latitude != nil && ado.deviceInfo.longitude != nil) {
        //NSLog(@"Lat. %@, Long. %@", [[[self ado] deviceInfo] latitude], [[[self ado] deviceInfo] longitude]);
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                ID_GPS, @"id",
                NSLocalizedString(@"settings_gps_title",nil), @"title",
                NSLocalizedString(@"settings_gps_desc",nil), @"desc",
                [NSNumber numberWithBool:[[[pm settings] settingGPS] boolValue]], @"active",
                nil];
        [arr addObject:dict];
    //}
    
    // Sound.
    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
            ID_SOUND, @"id",
            NSLocalizedString(@"settings_sound_title",nil), @"title",
            NSLocalizedString(@"settings_sound_desc",nil), @"desc",
            [NSNumber numberWithBool:[[[pm settings] settingSound] boolValue]], @"active",
            nil];
    [arr addObject:dict];
    
    // Circle Connect - presence dependent on compile switch.
    if (ACT_CIRCLE_CONNECT) {
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                ID_CIRCLE_CONNECT, @"id",
                NSLocalizedString(@"settings_circle_connect_title",nil), @"title",
                NSLocalizedString(@"settings_circle_connect_desc",nil), @"desc",
                [NSNumber numberWithBool:[[[pm settings] settingCircleConnect] boolValue]], @"active",
                nil];
        [arr addObject:dict];
    }
    
    // Circle Connect - presence dependent on compile switch.
    if (ACT_BROWSER) {
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                ID_BROWSER, @"id",
                NSLocalizedString(@"settings_browser_title",nil), @"title",
                NSLocalizedString(@"settings_browser_desc",nil), @"desc",
                [NSNumber numberWithBool:[[[pm settings] settingBrowser] boolValue]], @"active",
                nil];
        [arr addObject:dict];
    }
    
    /*
    if(pm.profile.email == nil) pm.profile.email = @"";
    if(pm.profile.name == nil) pm.profile.name = @"";
    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
            ID_USER, @"id",
            NSLocalizedString(@"settings_profile_title",nil), @"title",
            [NSString stringWithFormat:@"%@: %@",pm.profile.name,pm.profile.email], @"desc",
            nil];
    [arr addObject:dict];
    */
    
    // DeviceID.
    /*dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
            ID_DEVICE_ID, @"id",
            NSLocalizedString(@"settings_deviceID_title",nil), @"title",
            [[pm settings] settingDeviceID], @"desc",
            nil];
    [arr addObject:dict];
     */
    /*
    // DownloadURL.
    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
            ID_DOWNLOAD_URL, @"id",
            NSLocalizedString(@"settings_downloadURL_title",nil), @"title",
            [[dbDelegate getAppSettings] packageDownloadURL], @"desc",
            nil];
    [arr addObject:dict];
    */
    // Return an immutable copy of the array.
    return [NSArray arrayWithArray:arr];
}


@end
