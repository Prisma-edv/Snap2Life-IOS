//
//  S2LPutLinkView.h
//  snap2life suite
//
//  Created by Antonio_Stilo on 11/21/13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface S2LPutLinkView : UIView <UITextFieldDelegate>
{
    UIView* titleBackground;
    UITextField* titleText;
    UIView* linkBackground;
    UITextField* linkText;
    
}

@property (nonatomic, unsafe_unretained)id delegate;
@property (nonatomic,strong) UIButton* addButton;

-(NSDictionary*)evaluate:(NSArray*)links atIndex:(NSInteger)index;

@end
