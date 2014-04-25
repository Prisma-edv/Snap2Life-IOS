//
//  s2lAddCatalogViewController.h
//  snap2life suite
//
//  Created by Volker Brendel on 20.01.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class s2lCatalogListViewController;

@interface s2lAddCatalogViewController : UITableViewController

- (IBAction)cancelButtonPressed:(id)sender;

- (IBAction)doneButtonPressed:(id)sender;

@property (nonatomic, strong) IBOutlet UITextField *nameField;
@property (nonatomic, strong) IBOutlet UISwitch *activeField;
@property (nonatomic, strong) IBOutlet UITextField *sizeField;
@property (nonatomic, strong) IBOutlet UITextField *dateField;
@property (nonatomic, strong) IBOutlet UITextField *versionField;
@property (nonatomic, strong) IBOutlet UISwitch *automaticField;
@property (nonatomic, strong) IBOutlet UITextField *catalogField;

@property (nonatomic, strong) s2lCatalogListViewController *s2lCatalogListViewController;

@end
