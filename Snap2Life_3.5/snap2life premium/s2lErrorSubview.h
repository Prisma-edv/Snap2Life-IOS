//
//  s2lErrorSubview.h
//  snap2life suite
//
//  Created by Antonio Stilo on 11.02.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Field.h"
#import "ErrorDef.h"
#import "Button+properties.h"
#import "Constants.h"
#import "History.h"
#import "S2LProtocols.h"
#import "ASVoteView.h"

@interface s2lErrorSubview : UIView <UITextFieldDelegate>
{
    UIButton *button;
    CGRect descLblFrame;
    CGRect messageFrame;
    CGRect scrollFrame;
    ASVoteView *ratingView;
    UIButton *submitAgain;
    UIView *loading;
    NSMutableArray *putLinks;
    int putCount;
    CGFloat newOffset;
}

@property (nonatomic, unsafe_unretained) id <ResultViewControllerDelegate> delegate;
@property (nonatomic, unsafe_unretained) IBOutlet id <WebViewDelegate> webOpenDelegate;

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *messageView;
@property (nonatomic, strong) IBOutlet UILabel *errorTitleView;
@property (nonatomic, strong) IBOutlet UILabel *descLbl;

@property (nonatomic, strong) UITextField* putKey;
@property (nonatomic, strong) UITextField* putComment;
//@property (nonatomic, strong) UITextField* putUrl;
@property (nonatomic, strong) UILabel* validationError;
@property (nonatomic,strong)  History *history;

- (void)refreshUIWithError:(ErrorDef*)error;
- (void)buttonPressedAction:(id)sender;

// Method called when the Return key is pressed on the keyboard for a text field.
- (BOOL)textFieldShouldReturn:(UITextField*)textField;

-(void)buildToInterfaceOrientation:(UIInterfaceOrientation)orientation;

@end
