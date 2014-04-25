//
//  S2LCommentPopoView.h
//  snap2life3.5
//
//  Created by iOS on 04.04.14.
//  Copyright (c) 2014 Prisma Gmbh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+UIButton_style.h"
#import "PersistenceManager.h"
#import "S2LCommunityManager.h"
#import "AFS2LAppAPIClient.h"
#import "S2LIRRequestMaker.h"
#import "SerializerAPI2.h"

typedef void (^commentSuccessBlock_t)();
typedef void (^commentAbortBlock_t)();

@interface S2LCommentPopoView : UIView <UITextFieldDelegate>
{
    UITextField *comment;
    UIButton *submit;
}

@property (nonatomic,weak) NSString *snapID;
@property (nonatomic,weak) UIView *parent;

@property (nonatomic,copy)commentSuccessBlock_t success;
@property (nonatomic,copy)commentAbortBlock_t abort;


@end
