//
//  s2lARSelectionViewController.m
//  snap2life suite
//
//  Created by Antonio Stilo on 26.02.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "s2lARSelectionViewController.h"
#import "s2lARPreferencesViewController.h"
#import "PersistenceManager.h"
#import "ARpackage.h"
#import "s2lARDownloadCell.h"
#import "s2lAppDelegate.h"
#import "UIButton+UIButton_style.h"

@interface s2lARSelectionViewController ()

@end

@implementation s2lARSelectionViewController
@synthesize data = _data;
@synthesize isModal;

#pragma mark DATASOURCE

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

#pragma mark DELEGATE

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"selectionCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // Setup the cell with its title, description, active-switch and background image.
        cell = [[s2lARDownloadCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    // Fill in the cell's image, title and description.
    ARpackage* package = [self.data objectAtIndex:indexPath.row];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];

    [[(s2lARDownloadCell*)cell dateLabel] setText:[dateFormatter stringFromDate:[package downloadDate]]];
    
    CGRect frame = cell.textLabel.frame;
    cell.textLabel.frame = CGRectMake(frame.origin.x, frame.origin.y+4, frame.size.width, frame.size.height);
    
    cell.textLabel.text = package.key;
    cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"ar_package_size_format", nil), [package.memoryFootprint floatValue]/(1024*1024)];
    
    if (_selected == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(void)updateSelection:(NSInteger)selectedIndex
{

    [[NSUserDefaults standardUserDefaults] setInteger:selectedIndex forKey:@"arSelectionIndex"];
    
}


-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selected = indexPath.row;
    [self updateSelection:_selected];
    [self reloadTable];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PersistenceManager *persistentManager = [PersistenceManager sharedInstance];
        [persistentManager deletePackage:[self.data objectAtIndex:indexPath.row]];
        [self.data removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self performSelector:@selector(reloadTable) withObject:nil afterDelay:0.5];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

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


#pragma mark - IBActions

-(void)backButtonPressed:(id)sender
{
    NSLog(@"** DISMISS AR Selection");
        if(!isModal){
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
}

- (void)editButtonPressed:(id)sender
{
    _editing = !_editing;
    [self.tableView setEditing:_editing animated: YES];
}

-(void)openDownloadPanel
{
    s2lARPreferencesViewController *preferences = [[s2lARPreferencesViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:preferences animated:YES];

}

-(void)reloadTable
{
    PersistenceManager *persistentManager = [PersistenceManager sharedInstance];
    self.data = [[persistentManager allARpackages] mutableCopy];
    
    if (self.data.count==1) {
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"arSelectionIndex"];
        _selected = 0;
    }
    
    if (self.data.count == 0){
        noRecords = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 300, 44)];
        noRecords.text = NSLocalizedString(@"ar_package_placeholder", nil);
        noRecords.backgroundColor = [UIColor clearColor];
        noRecords.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:noRecords];
        [[persistentManager settings] setSettingAR:[NSNumber numberWithBool:NO]];
        [[persistentManager settings] setPackageDownloadURL:@""];
        [persistentManager saveAll];
    }else{
        if(noRecords){
            [noRecords removeFromSuperview];
            noRecords = nil;
        }
        ARpackage *package = [self.data objectAtIndex:_selected];
        [[persistentManager settings] setPackageDownloadURL:package.downloadURL];
        [persistentManager saveAll];
    }
    
    [self.tableView reloadData];
}
-(void)viewDidAppear:(BOOL)animated
{
        [self reloadTable];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _selected = [[NSUserDefaults standardUserDefaults] integerForKey:@"arSelectionIndex"];
    
    UIToolbar *toolbar = self.navigationController.toolbar;
    toolbar.tintColor = UIColorFromRGB(BACKGROUND, 1.0);
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.tintColor = UIColorFromRGB(BACKGROUND, 1.0);

    if(isModal){
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
        //backBtn.tintColor = [UIColor darkGrayColor];
        self.navigationItem.leftBarButtonItem = backBtn;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"edit_btn", nil) style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPressed:)];
   // editButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = editButton;
    /*
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back_btn", nil) style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
    self.navigationItem.leftBarButtonItem = backButton;
    */
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn addTarget:self action:@selector(openDownloadPanel) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:NSLocalizedString(@"ar_package_update_btn", nil) forState:UIControlStateNormal];
    [btn setStyle];
    btn.frame = CGRectMake(0, 0, 320, 50);
    
    self.tableView.tableHeaderView = btn;
    self.tableView.backgroundColor = UIColorFromRGB(BACKGROUND, 1);
    self.tableView.backgroundView = nil;
    self.tableView.separatorColor = UIColorFromRGB(BACKGROUND, 1);
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
