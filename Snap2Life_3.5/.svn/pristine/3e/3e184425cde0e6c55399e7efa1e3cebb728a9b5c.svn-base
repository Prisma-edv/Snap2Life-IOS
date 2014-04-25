//
//  s2lHistoryListTableViewController.m
//  snap2life suite
//
//  Created by Volker Brendel on 22.01.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "s2lHistoryListViewController.h"
#import "s2lSnapListTableViewController.h"
#import "History.h"
#import "AppDataObject.h"
#import "s2lHistoryCell.h"
#import "s2lResultViewController.h"
#import "s2lAppDelegate.h"
#import "s2lUploaderForPDF.h"
#import "s2lSnapMapViewController.h"
#import "UIButton+UIButton_style.h"

@interface s2lHistoryListViewController ()

// The data source for the table view: a NSMutableArray of Histories returned from the database.
@property (nonatomic,strong) NSMutableArray* data;


@end

@implementation s2lHistoryListViewController
@synthesize uploader;
@synthesize data;
@synthesize tableView;

-(void)capturedHandler:(BOOL)isCaptured{
    
    isRec = isCaptured;
    
    s2lAppDelegate *appDelegate = (s2lAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.isCapturedOn = isCaptured;
    NSMutableArray *list = [NSMutableArray array];
    id<DBDelegate> dbDelegate = (id<DBDelegate>) [[UIApplication sharedApplication] delegate];
    for(History *history in [dbDelegate allHistories]){
        if ([history.snapRecognized boolValue] == isCaptured && ![history.snapFavourite boolValue]) {
            [list addObject:history];
        }
    }
    if (list.count == 0){
        noRecords = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 300, 44)];
        noRecords.text = NSLocalizedString(@"history_placeholder", nil);
        noRecords.backgroundColor = [UIColor clearColor];
        noRecords.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:noRecords];
    }else{
        [noRecords removeFromSuperview];
        noRecords = nil;
    }
    self.data = list;
    [self.tableView reloadData];
    
    if(isCaptured){
        sendPdfImmages = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        sendPdfImmages.frame = CGRectMake((self.tableView.frame.size.width-300)/2, 0, 300, 50);
        [sendPdfImmages setTitle:NSLocalizedString(@"history_send_for_pdf", nil) forState:UIControlStateNormal];
        [sendPdfImmages setStyle];
        [sendPdfImmages addTarget:self action:@selector(sendPDFImmagesHandler) forControlEvents:UIControlEventTouchUpInside];
        self.tableView.tableHeaderView = sendPdfImmages;
    }
}

-(IBAction)segmentedControllerChange:(id)sender
{
    int value = [(UISegmentedControl*)(sender) selectedSegmentIndex];
    
    if(!isIPad){
        switch (value) {
            case 0:
                sendPdfImmages.hidden = NO;
                isCapturedOn = YES;
                break;
            case 1:
                sendPdfImmages.hidden = YES;
                isCapturedOn = NO;
                break;
                
            default:
                break;
        }
        [self capturedHandler:isCapturedOn];
    }else{
        switch (value) {
            case 0:
                [self openMap:nil];
                break;
            case 1:
                sendPdfImmages.hidden = NO;
                isCapturedOn = YES;
                break;
            case 2:
                sendPdfImmages.hidden = YES;
                isCapturedOn = NO;
                break;
                
            default:
                break;
        }
        [self capturedHandler:isCapturedOn];
    }

}

-(IBAction)openMap:(id)sender
{
    UIStoryboard *storyboard = self.storyboard;
    s2lSnapMapViewController *webViewController = [storyboard instantiateViewControllerWithIdentifier:@"map"];
    [self presentViewController:webViewController animated:YES completion:nil];
}

-(void)prepareTable
{
    
    id<DBDelegate> dbDelegate = (id<DBDelegate>) [[UIApplication sharedApplication] delegate];
    self.data = [dbDelegate allHistories];
    _editing = NO;
    
    [self.tableView reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = @"History";
    s2lAppDelegate *appDelegate = (s2lAppDelegate*)[[UIApplication sharedApplication] delegate];
    isCapturedOn = appDelegate.isCapturedOn;
  
    if(isIPad){
        [segmented setTitle:NSLocalizedString(@"history_map", nil) forSegmentAtIndex:0];
        [segmented setTitle:NSLocalizedString(@"history_record", nil) forSegmentAtIndex:1];
        [segmented setTitle:NSLocalizedString(@"history_not_record", nil) forSegmentAtIndex:2];
        if(isCapturedOn)
            segmented.selectedSegmentIndex = 1;
        else
            segmented.selectedSegmentIndex = 2;
    }else{
        map.title = NSLocalizedString(@"history_map", nil);
        [segmented setTitle:NSLocalizedString(@"history_record", nil) forSegmentAtIndex:0];
        [segmented setTitle:NSLocalizedString(@"history_not_record", nil) forSegmentAtIndex:1];
        if(isCapturedOn)
            segmented.selectedSegmentIndex = 0;
        else
            segmented.selectedSegmentIndex = 1;
    }
    edit.title = NSLocalizedString(@"history_edit", nil);
    

    
    
    UIToolbar *toolbar = self.navigationController.toolbar;
    toolbar.tintColor = UIColorFromRGB(BACKGROUND, 1.0);
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.tintColor = UIColorFromRGB(BACKGROUND, 1.0);
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = UIColorFromRGB(BACKGROUND, 1);
    self.tableView.backgroundView = nil;
    self.tableView.separatorColor = UIColorFromRGB(BACKGROUND, 1);
    [self.view addSubview:self.tableView];
    
    [self capturedHandler:isCapturedOn];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)sendPDFImmagesHandler
{
    uploader = [[s2lUploaderForPDF alloc] init];
    uploader.delegate = self;
    
    NSMutableArray *sendableImages = [NSMutableArray array];
    [self.data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        History *history = (History*)obj;
        if ([history.snapToSendForPdf boolValue]) {
            [sendableImages addObject:history];
        }
    }];
    
    if(sendableImages.count > 0)[uploader startUploading:sendableImages];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Get the AppDelegate as a DBDelegate and retrieve the History objects from the database
    self.view.backgroundColor = UIColorFromRGB(BACKGROUND, 1); 
    self.tableView.backgroundColor = UIColorFromRGB(BACKGROUND, 1);
    self.tableView.backgroundView = nil;
    self.tableView.frame = CGRectMake(0, 0, 320, 372);

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setData:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// VBR
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
     if ([segue.identifier isEqualToString:@"historyDetailSegue"]) {
        s2lResultViewController *resultViewController = segue.destinationViewController;
         resultViewController.currentHistory = [self.data objectAtIndex:index];
     }
} 


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    index = indexPath.row;
    [self performSegueWithIdentifier:@"historyDetailSegue" sender:nil];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"CellHistory";//[NSString stringWithFormat:@"historyCell_%u",indexPath.row];
    
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // Setup the cell with its title, description, active-switch and background image.
        cell = [[s2lHistoryCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
    }
    [(s2lHistoryCell*)cell setDelegate:self];
    // Fill in the cell's image, title and description.
    History* history = [data objectAtIndex:[indexPath row]];
    [((s2lHistoryCell *)cell) setHistory:history];
    
    [((s2lHistoryCell *)cell) setIsSelectable:isRec];
   
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
    return 84;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        id<DBDelegate> dbDelegate = (id<DBDelegate>) [[UIApplication sharedApplication] delegate];
        [dbDelegate removeHistoryItem:[self.data objectAtIndex:indexPath.row]];
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
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


#pragma mark - Table view delegate

#pragma mark - IBActions
- (IBAction)editButtonPressed:(id)sender
{
    _editing = !_editing;
    [self.tableView setEditing:_editing animated: YES];
}

- (void)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)doneButtonPressed:(id)sender {
    // VBR ToDo
    [self dismissViewControllerAnimated:YES completion:NULL];
}



@end
