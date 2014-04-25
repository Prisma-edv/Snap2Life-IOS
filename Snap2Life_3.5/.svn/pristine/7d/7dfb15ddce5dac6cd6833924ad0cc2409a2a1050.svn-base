//
//  s2lHistoryListTableViewController.h
//  snap2life suite
//
//  Created by Volker Brendel on 22.01.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "s2lUploaderForPDF.h"

@interface s2lHistoryListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    BOOL _editing;
    NSMutableArray *_selectedImagesList;
    UIButton *sendPdfImmages;
    int index;
    BOOL isRec;
    BOOL isCapturedOn;
    IBOutlet UISegmentedControl *segmented;
    IBOutlet UIBarButtonItem *map;
    IBOutlet UIBarButtonItem *edit;
    UILabel *noRecords;
    
}

@property (nonatomic,strong)s2lUploaderForPDF *uploader;
@property (nonatomic,strong) UITableView* tableView;

- (IBAction)editButtonPressed:(id)sender;

- (IBAction)cancelButtonPressed:(id)sender;

- (IBAction)doneButtonPressed:(id)sender;

@end
