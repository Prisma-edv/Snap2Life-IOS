//
//  s2lSnapListTableViewController.m
//  snap2life suite
//
//  Created by Volker Brendel on 22.01.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "s2lSnapListTableViewController.h"
#import "s2lsnaps.h"

@interface s2lSnapListTableViewController ()

@end

@implementation s2lSnapListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}



- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.snaps = [[NSMutableArray alloc] init];
    
    // VBR
    s2lsnaps *snapswithresult = [[s2lsnaps alloc] initWithNumber:@123 snapname:@"my Snap with result" snapdate:@"01.01.2014"  snapper:@"brendelv" snappercomment:@"cooler snap" snappervote:@2 snaplatitude:@"52.3100" snaplongitude:@"13.2400" snapresult:@1];
                                    
    [self.snaps addObject:snapswithresult];
    
    // VBR
    s2lsnaps *snapswithnoresult = [[s2lsnaps alloc] initWithNumber:@1234 snapname:@"my Snap without result" snapdate:@"01.01.2014" snapper:@"brendelv" snappercomment:@"cooler snap" snappervote:@3 snaplatitude:@"52.3500" snaplongitude:@"13.3300" snapresult:@2];
    
    [self.snaps addObject:snapswithnoresult];
 
    // VBR
    s2lsnaps *snapswithnorequest = [[s2lsnaps alloc] initWithNumber:@12345 snapname:@"my Snap without request" snapdate:@"01.01.2014" snapper:@"brendelv" snappercomment:@"leer" snappervote:@3 snaplatitude:@"52.4500" snaplongitude:@"13.6600" snapresult:@3];
    
    [self.snaps addObject:snapswithnorequest];
                                     
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* VBR
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"manageSnapSegue"]) {
        s2lSnapListTableViewController *snapListViewController = segue.destinationViewController;
        snapListViewController.snaps = [self.snaps objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    }
    
} */

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
     return self.snaps.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *resultCellIdentifier = @"snapwithresultcell";
    static NSString *noresultCellIdentifier = @"snapwithnoresultcell";
    static NSString *requestCellIdentifier = @"snapwithrequestcell";
    static NSString *norequestCellIdentifier = @"snapwithnorequestcell";
    
    s2lsnaps *currentSnapList = [self.snaps objectAtIndex:indexPath.row];
    
    NSString *CellResultIdentifier = norequestCellIdentifier;

    switch (currentSnapList.snapresult.integerValue) {
        case 1:
        {
            CellResultIdentifier = resultCellIdentifier;
            break;
        }
        case 2:
        {
            CellResultIdentifier = noresultCellIdentifier;
            break;
        }
        case 3:
        {
            CellResultIdentifier = norequestCellIdentifier;
            break;
        }
        default:
        {
            CellResultIdentifier = requestCellIdentifier;
            break;
        }
    }

    //    NSString *CellResultIdentifier = currentSnapList.snapresult ? resultCellIdentifier : noresultCellIdentifier;
    
    UITableViewCell *resultcell = [tableView dequeueReusableCellWithIdentifier:CellResultIdentifier];
    
    
    // Configure the cell...
    
    if (resultcell == nil) {
        resultcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellResultIdentifier];
    }
    
    // VBR
    resultcell.textLabel.text = currentSnapList.snapname;
    
    return resultcell;
    }


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.snaps removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    s2lsnaps *movedSnap = [self.snaps objectAtIndex:fromIndexPath.row];
    [self.snaps removeObjectAtIndex:fromIndexPath.row];
    [self.snaps insertObject:movedSnap atIndex:toIndexPath.row];
    
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - IBActions

- (void)editingButtonPressed:(id)sender {
    self.editing = !self.editing;
}

- (void)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)doneButtonPressed:(id)sender {
    // VBR ToDo
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
