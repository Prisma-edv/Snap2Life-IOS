//
//  s2lEditCatalogViewController.h
//  snap2life suite
//
//  Created by Volker Brendel on 21.01.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class s2lcatalog;

@interface s2lEditCatalogViewController : UITableViewController

@property (nonatomic, strong) IBOutlet UITextField *nameField;
@property (nonatomic, assign) IBOutlet UISwitch *activeField;
@property (nonatomic, assign) IBOutlet UITextField *sizeField;
@property (nonatomic, assign) IBOutlet UITextField *dateField;
@property (nonatomic, assign) IBOutlet UITextField *versionField;
@property (nonatomic, assign) IBOutlet UISwitch *automaticField;
@property (nonatomic, assign) IBOutlet UITextField *catalogField;

@property (nonatomic, assign) s2lcatalog *catalogs;


- (IBAction)catalogDataChanged:(id)sender;

@end
