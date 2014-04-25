//
//  S2LProfileViewController.h
//  snap2life suite
//
//  Created by iOS on 25.11.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "s2lUploaderForPDF.h"

@interface S2LProfileViewController : UIViewController <UITableViewDelegate,UITableViewDataSource, UIAlertViewDelegate>
{
    IBOutlet UIImageView *avatar;
    IBOutlet UIButton *logOutBtn;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *emailLabel;
    IBOutlet UITextField *nameText;
    IBOutlet UITextField *emailText;
    IBOutlet UIView *historyView;
    //IBOutlet UIView *profileView;
    IBOutlet UISegmentedControl *segmented;
    
    BOOL isProfileOn;
    BOOL isCapturedOn;
    UILabel *noRecords;
    
    NSArray *data;
    UIButton *sendPdfImmages;
    s2lUploaderForPDF *uploader;
    BOOL isLoggin;

}

@property (nonatomic,strong) IBOutlet UITableView *table;

-(void)updateProfile;
-(IBAction)mapHandler:(id)sender;
-(IBAction)historySwitch:(id)sender;

@end
