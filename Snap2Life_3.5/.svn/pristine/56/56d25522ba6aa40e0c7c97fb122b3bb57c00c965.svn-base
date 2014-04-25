//
//  s2lHistoryListTableViewController.m
//  snap2life suite
//
//  Created by Volker Brendel on 22.01.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "s2lBookmarksViewController.h"
#import "s2lSnapListTableViewController.h"
#import "History.h"
#import "AppDataObject.h"
#import "s2lHistoryCell.h"
#import "s2lResultViewController.h"
#import "s2lAppDelegate.h"
#import "s2lUploaderForPDF.h"
#import "s2lSnapMapViewController.h"

@interface s2lBookmarksViewController ()

// The data source for the table view: a NSMutableArray of Histories returned from the database.
@property (nonatomic,strong) NSMutableArray* data;

@end

@implementation s2lBookmarksViewController
@synthesize data;

-(void)populateHandler
{
    
    NSMutableArray *list = [NSMutableArray array];
    id<DBDelegate> dbDelegate = (id<DBDelegate>) [[UIApplication sharedApplication] delegate];
    for(History *history in [dbDelegate allHistories]){
        if ([history.snapFavourite boolValue] == YES) {
            [list addObject:history];
        }
    }
    
    if (list.count == 0){
        UILabel *noRecords = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 44)];
        noRecords.text = NSLocalizedString(@"bookmark_placeholder", nil);
        noRecords.backgroundColor = [UIColor clearColor];
        noRecords.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:noRecords];
    }
    self.data = list;
    [self.tableView reloadData];
}

-(IBAction)openMap:(id)sender
{
    UIStoryboard *storyboard = self.storyboard;
    s2lSnapMapViewController *webViewController = [storyboard instantiateViewControllerWithIdentifier:@"map"];
    [self presentViewController:webViewController animated:YES completion:nil];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)prepareTable{
    id<DBDelegate> dbDelegate = (id<DBDelegate>) [[UIApplication sharedApplication] delegate];
    self.data = [dbDelegate allHistories];
    _editing = NO;
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
    [self populateHandler];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Bookmarks";
    
    UIToolbar *toolbar = self.navigationController.toolbar;
    toolbar.tintColor = UIColorFromRGB(GREY, 1.0);
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.tintColor = UIColorFromRGB(GREY, 1.0);
    self.tableView.backgroundColor = UIColorFromRGB(BACKGROUND, 1);
    self.tableView.backgroundView = nil;
    self.tableView.separatorColor = UIColorFromRGB(BACKGROUND, 1);
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
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {

    UIStoryboard *storyboard = self.storyboard;
    s2lResultViewController *resultViewController = [storyboard instantiateViewControllerWithIdentifier:@"ResultPage"];
    resultViewController.currentHistory = [data objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:resultViewController animated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"historyCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // Setup the cell with its title, description, active-switch and background image.
        cell = [[s2lHistoryCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
    }
    [(s2lHistoryCell*)cell setDelegate:self];
    // Fill in the cell's image, title and description.
    History* history = [data objectAtIndex:[indexPath row]];
    [((s2lHistoryCell *)cell) setHistory:history];
    [((s2lHistoryCell *)cell) setIsSelectable:NO];
    
    if ([history.snapToSendForPdf boolValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        id<DBDelegate> dbDelegate = (id<DBDelegate>) [[UIApplication sharedApplication] delegate];
        [dbDelegate removeHistoryItem:indexPath.row];
        [self.data removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


#pragma mark - Table view delegate

#pragma mark - IBActions
- (IBAction)editButtonPressed:(id)sender
{
    _editing = !_editing;
    [self.tableView setEditing:_editing animated: YES];
}

@end
