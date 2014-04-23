//
//  S2LErrorViewController.h
//  snap2life suite
//
//  Created by Antonio_Stilo on 11/21/13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ErrorDef.h"

@interface S2LErrorViewController : UIViewController <UITextFieldDelegate,UIScrollViewDelegate>
{
    IBOutlet UIImageView *background;
    IBOutlet UIScrollView *scroll;
    IBOutlet UILabel *titleLable;
    IBOutlet UILabel *descriptionLabel;
    IBOutlet UILabel *linkDescriptionLabel;
    IBOutlet UITextField *nameText;
    IBOutlet UITextField *descriptionText;
    IBOutlet UITextField *commentText;
    IBOutlet UIButton *submitButton;
    IBOutlet UIView *containerView;
    IBOutlet UIView *nameBackground;
    IBOutlet UIView *commentBackground;
    UIButton *submitAgain;
    NSMutableArray *links;
    
    

}

@property (nonatomic) int resultIndex;
@property (nonatomic,strong) ErrorDef *errorObject;

-(void)buildInterface;
-(void)addLink:(CGFloat)offset;
-(void)scrollToPosition:(CGFloat)offset;

@end
