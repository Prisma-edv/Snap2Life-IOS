//
//  s2lEditCatalogViewController.m
//  snap2life suite
//
//  Created by Volker Brendel on 21.01.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "s2lEditCatalogViewController.h"

#import "s2lcatalog.h"

@implementation s2lEditCatalogViewController

@synthesize nameField;
@synthesize dateField;
@synthesize sizeField;
@synthesize activeField;
@synthesize versionField;
@synthesize automaticField;
@synthesize catalogField;

@synthesize catalogs = _catalogs;

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
    // VBR
    
    self.nameField.text = self.catalogs.name;
    self.sizeField.text = self.catalogs.size;
    self.dateField.text = self.catalogs.date;
    [self.activeField setOn:self.catalogs.active];
    self.versionField.text = self.catalogs.version;
    [self.automaticField setOn:self.catalogs.automatic];
    self.catalogField.text = self.catalogs.catalog;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

// VBR
#pragma mark - IBAction

- (void)catalogDataChanged:(id)sender {
    self.catalogs.name = self.nameField.text;
    self.catalogs.size = self.sizeField.text;
    self.catalogs.date = self.dateField.text;
    self.catalogs.active = self.activeField.isOn;
    self.catalogs.version = self.versionField.text;
    self.catalogs.automatic = self.automaticField.isOn;
    self.catalogs.catalog = self.catalogField.text;

}

@end
