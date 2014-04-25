//
//  s2lCatalogListViewController.m
//  snap2life suite
//
//  Created by Volker Brendel on 20.01.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "s2lCatalogListViewController.h"
#import "s2lcatalog.h"
#import "s2lAddCatalogViewController.h"
#import "s2lEditCatalogViewController.h"

@interface s2lCatalogListViewController ()

@end

@implementation s2lCatalogListViewController

@synthesize catalogs = _catalogs;

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
    // VBR
    self.catalogs = [[NSMutableArray alloc] init];
    
    // VBR
    s2lcatalog *catalogs = [[s2lcatalog alloc] initWithName:@"construction_all" date:@"01.01.2013" size:@"13 MByte" active:NO version:@"1.0" automatic:NO catalog:@"snap2life_construct" ];
        
    [self.catalogs addObject:catalogs];

    s2lcatalog *activecatalogs = [[s2lcatalog alloc] initWithName:@"demo" date:@"01.02.2013" size:@"14 MByte" active:YES version:@"1.0" automatic:NO catalog:@"demo"];
    
    [self.catalogs addObject:activecatalogs];
    
    
    [self.tableView reloadData];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

// VBR
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AddCatalogSegue"]) {
        UINavigationController *navCon = segue.destinationViewController;
        
        s2lAddCatalogViewController *addCatalogViewContoller = [navCon.viewControllers objectAtIndex:0];
        addCatalogViewContoller.s2lCatalogListViewController = self;        
    } else if ([segue.identifier isEqualToString:@"EditActiveCatalogSegue"] || [segue.identifier isEqualToString:@"EditInactiveCatalogSegue"]) {
        s2lEditCatalogViewController *editCatalogViewController = segue.destinationViewController;
        editCatalogViewController.catalogs = [self.catalogs objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    }
        
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    // VBR
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    // VBR
    return self.catalogs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath
{
    static NSString *InactiveCellIdentifier = @"cataloginactivecell";
    static NSString *ActiveCellIdentifier = @"catalogactivecell";
    
    
    s2lcatalog *currentCatalog = [self.catalogs objectAtIndex:indexPath.row];
    
    NSString *CellIdentifier = currentCatalog.active ? ActiveCellIdentifier : InactiveCellIdentifier;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    // Configure the cell...
    // VBR
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // VBR
    cell.textLabel.text = currentCatalog.name;
    
        
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


 
// VBR 
 
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.catalogs removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    s2lcatalog *movedCatalog = [self.catalogs objectAtIndex:fromIndexPath.row];
    [self.catalogs removeObjectAtIndex:fromIndexPath.row];
    [self.catalogs insertObject:movedCatalog atIndex:toIndexPath.row];
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
