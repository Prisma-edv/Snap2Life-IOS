//
//  S2LNewResultViewController.m
//  snap2life suite
//
//  Created by Antonio_Stilo on 11/21/13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "S2LNewResultViewController.h"
#import "Featuregroup.h"
#import "Feature.h"
#import "AppDataObject.h"
#import "S2LIRRequestMaker.h"
#import "S2LRequestUtils.h"
#import "Extra.h"
#import "UIButton+UIButton_style.h"
#import "RequestUtils.h"
#import "S2LNavigationUtils.h"

@interface S2LNewResultViewController ()

@end

@implementation S2LNewResultViewController

@synthesize object;
@synthesize index;

#pragma mark Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return features.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the region at the section index.
    //return NSLocalizedString(@"contents", @"Contents of the Image");
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
    }
    
    NSInteger rowIndex = indexPath.row;
    
    Feature *f = [features objectAtIndex:rowIndex];
    
    // Disable the selectability of the text in the cell (only the buttons are of interest).
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    if (f.value != nil && [f.value hasPrefix:@"http"]) {
        // Set a button if the Feature has a non-null URL.
        [cell.textLabel setText:[(Feature*)f name]];
        [cell.textLabel setBackgroundColor:[UIColor whiteColor]];
        [cell.textLabel setTextColor:[UIColor blackColor]];
        cell.backgroundColor = [UIColor clearColor];
        [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"_arrow-green-history.png"]]];
    }
    else {
        NSDate* timestamp = [RequestUtils dateFromIsoString:f.name];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        // Set a two-line cell with the date in grey at the top and the comment below.
        [cell.textLabel setText:[dateFormatter stringFromDate:timestamp]];
        [cell.textLabel setBackgroundColor:[UIColor whiteColor]];
        [cell.textLabel setTextColor:[UIColor blackColor]];
        [cell.detailTextLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        [cell.detailTextLabel setText:f.value];
        [cell.detailTextLabel setBackgroundColor:[UIColor whiteColor]];
        [cell.detailTextLabel setTextColor:[UIColor blackColor]];
        cell.backgroundColor = [UIColor clearColor];
        [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"_ballon-big-reusult.png"]]];
    }
    
    UIView *bck = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    bck.backgroundColor = [UIColor whiteColor];
    [cell addSubview:bck];
    [cell sendSubviewToBack:bck];
    
    cell.textLabel.frame = CGRectMake(cell.textLabel.frame.origin.x, (44-cell.textLabel.frame.size.height)/2, cell.textLabel.frame.size.width, cell.textLabel.frame.size.height);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger rowIndex = indexPath.row;
    Feature *f = [features objectAtIndex:rowIndex];
    if ([[f value] length] > 0 && [f.value hasPrefix:@"http"]) {
        [self openWebUrlAndStore:f.value andTargetName:@""];
    }
}



#pragma mark view controller

-(void)openWebUrlAndStore:(NSString*)urlString andTargetName:(NSString*)name
{
    [S2LNavigationUtils openWebUrlAndStore:urlString andTargetName:name fromViewController:self];
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    /*self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back_btn", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(backBtnUserClicked)];
    */
     [self buildInterface];
}

-(void)backBtnUserClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isFirst = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back_btn", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(backBtnUserClicked)];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)parse:(NSArray*)comments
{
    NSMutableArray *featureList = [[NSMutableArray alloc] init];
    for (Featuregroup* fg in object.featuregroups.featuregroup){
        for (Feature* f in fg.feature){
            if ([[f value] length] > 0) {
                [featureList addObject:f];
            }
        }
        
        NSArray *list = [featureList sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            int order1 = [(Feature*) obj1 order];
            if ([[(Feature*) obj1 value] length] == 0) order1 += 10000;
            int order2 = [(Feature*) obj2 order];
            if ([[(Feature*) obj2 value] length] == 0) order2 += 10000;
            return (order1 < order2)? NSOrderedAscending: (order1 == order2)? NSOrderedSame: NSOrderedDescending;
        }];
        
        features = list;
        [table reloadData];
        
        // Show results screen if more than one result or if one result and it has an empty URL.
        if ([list count] == 1 && !isFirst){
            Feature *f = [list objectAtIndex:0];
            if (![f.value isEqualToString:@""]){
                [self performSelector:@selector(callExternalLink:) withObject:f.value afterDelay:1.0];
                isFirst = YES;
            }
        }
    }
}

-(void)callExternalLink:(NSString*)value
{
    [self openWebUrlAndStore:value andTargetName:@""];
}


- (void) buildInterface
{
    
    snapID = [object snapID];
    [self parse:nil];
    int height = 120;
    if(isIPad)height = 220;
    
    AppDataObject *ado = [[S2LIRRequestMaker sharedClient] ado];
    
    NSData *capturedData = ado.capturedData;
	if (capturedData){
        UIImage *img = [[UIImage alloc] initWithData:capturedData];
        background.image = img;
	}
    
    titleLabel.text = object.infos.title;
	descriptionLabel.text = object.infos.desc;
    
}


@end
