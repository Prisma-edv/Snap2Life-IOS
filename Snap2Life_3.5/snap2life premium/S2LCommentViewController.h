//
//  S2LCommentViewController.h
//  snap2life suite
//
//  Created by iOS on 13.12.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "S2LCommunitySnapDef.h"

@interface S2LCommentViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UIImageView* backgroundImageView;
    IBOutlet UITextField* comment;
    IBOutlet UIButton* submit;
}

@property (nonatomic, strong) NSString* snapID;

@end
