//
//  s2lInfoViewController.m
//  snap2life suite
//
//  Created by Antonio Stilo on 08.04.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "s2lFAQViewController.h"
#import "FAQCell.h"
#import "Constants.h" 
#import "PersistenceManager.h"

@interface s2lFAQViewController ()

@end

@implementation s2lFAQViewController
@synthesize data,mTableView,delegate,isOpens;

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
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*CGFloat posY = 44.0*indexPath.row;
     if(indexPath.row > 0){
     NSIndexPath *prevIndex = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:0];
     UITableViewCell *prev = [mTableView cellForRowAtIndexPath:prevIndex];
     //posY = prev.frame.origin.y+prev.frame.size.height;
     NSLog(@"** PosY-%i %1.2f - height: %1.2f",indexPath.row,posY,prev.frame.size.height);
     }
     
     CGPoint p = CGPointMake(0, posY);
     [(FAQCell*)cell setOrigin:p];
     */
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"FAQ";
    
    UIToolbar *toolbar = self.navigationController.toolbar;
    toolbar.tintColor = UIColorFromRGB(BACKGROUND, 1.0);
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.tintColor = UIColorFromRGB(BACKGROUND, 1.0);
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        navBar.translucent = NO;
    }
    
    self.view.backgroundColor = UIColorFromRGB(BACKGROUND, 1);
    
    NSString *name = @"prisma_faq_de";
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if(![language isEqualToString:@"de"])
        name = @"prisma_faq_en";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    data = [NSArray arrayWithContentsOfFile:path];
    isOpens = [NSMutableArray array];
    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [isOpens addObject:[NSNumber numberWithBool:NO]];
    }];
    
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mTableView.backgroundColor = UIColorFromRGB(BACKGROUND, 1);
    
    if (!isIPad) {
        if (!IS_WIDESCREEN) {
            mTableView.frame = CGRectMake(0, 0, 320, 380);
        }else{
            mTableView.frame = CGRectMake(0, 0, 320, 500);
        }
    }

    [mTableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"faqCell%u",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    // NSLog(@"** Cell %i - %@",indexPath.row,cell);
    if (cell == nil) {
        cell = [[FAQCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [(FAQCell*)cell setIsOpen:[[isOpens objectAtIndex:indexPath.row] boolValue]];
    [(FAQCell*)cell setData:[data objectAtIndex:indexPath.row]];
    [(FAQCell*)cell setIndex:indexPath.row];
    [(FAQCell*)cell setDelegate:self];
    [cell layoutSubviews];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FAQCell *cell =(FAQCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return ((CGSize)[cell sizeThatFits:self.view.frame.size]).height;
}

-(void)openCell:(int)index
{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    FAQCell *cell = (FAQCell*)[mTableView cellForRowAtIndexPath:indexPath];
    cell.isOpen = !cell.isOpen;
    [isOpens replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:cell.isOpen]];
    
    [mTableView beginUpdates];
    [mTableView endUpdates];
    float height = 0;
    for(int i=0; i< mTableView.visibleCells.count; i++){
        FAQCell *temp = (FAQCell*)[mTableView.visibleCells objectAtIndex:i];
        CGPoint p = CGPointMake(0, 0);
        
        if (i > 0) {
            UITableViewCell *prev = [mTableView.visibleCells objectAtIndex:i-1];
            p = CGPointMake(0, prev.frame.origin.y+prev.frame.size.height);
        }
        
        
        temp.origin = p;
        [temp layoutSubviews];
        height += temp.frame.size.height;
    }
    mTableView.contentSize = CGSizeMake(320.0, height+200);
}


- (void)viewDidUnload {
    self.mTableView = nil;
}


-(BOOL)shouldAutorotate
{
    return NO;
}

@end
