//
//  s2lUserPreferencesViewController.h
//  snap2life suite
//
//  Created by Antonio Stilo on 26.02.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface s2lUserPreferencesViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UIPopoverControllerDelegate>
{
    UIPopoverController *popover;
    UIButton* selectedImage;
    CGSize imageScaleSize;
    
    UIView *profileEmailBck;
    UIView *profileNameBck;
    
    UIButton *infoAvatarBtn;
    UIButton *infoSecretBtn;
}

@end
