//
//  s2lAddCatalogViewController.m
//  snap2life suite
//
//  Created by Volker Brendel on 20.01.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "s2lAddCatalogViewController.h"
#import "s2lCatalogListViewController.h"
#import "s2lcatalog.h"

@interface s2lAddCatalogViewController ()

@end

@implementation s2lAddCatalogViewController

@synthesize nameField;
@synthesize dateField;
@synthesize sizeField;
@synthesize activeField;
@synthesize versionField;
@synthesize automaticField;
@synthesize catalogField;

@synthesize s2lCatalogListViewController = _s2lCatalogListViewController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (void)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)doneButtonPressed:(id)sender {
  // VBR
    
    s2lcatalog *newCatalog = [[s2lcatalog alloc] initWithName:self.nameField.text date:self.dateField.text size:self.sizeField.text active:self.activeField.isOn version:self.versionField.text automatic:self.automaticField.isOn catalog:self.catalogField.text];
        
    [self.s2lCatalogListViewController.catalogs addObject:newCatalog];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end


