//
//  s2lErrorSubview.m
//  snap2life suite
//
//  Created by Antonio Stilo on 11.02.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "s2lErrorSubview.h"
#import "s2lSnapWebViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ASVoteView.h"
#import "UIButton+UIButton_style.h"
#import "S2LIRRequestMaker.h"
#import "AFS2LAppAPIClient.h"
#import "PersistenceManager.h"
#import "S2LIRRequestMaker.h"
#import "S2LSerializerAPI2.h"

@implementation s2lErrorSubview
@synthesize delegate;
@synthesize imageView;
@synthesize scrollView;
@synthesize messageView;
@synthesize errorTitleView;
@synthesize descLbl;
@synthesize putKey;
@synthesize putComment;
@synthesize validationError;
@synthesize webOpenDelegate;
@synthesize history;

-(void)buildToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    
    /*
    if (!isIPad) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;

        if (UIInterfaceOrientationIsPortrait(orientation)) {
            NSLog(@"** ErrorView buildToInterfaceOrientation %f - %f",screenSize.width,screenSize.height);
            descLbl.frame = CGRectMake(108, 46, 199, 75);
            messageView.frame = messageFrame;
            scrollView.frame = scrollFrame;
            
            CGRect putKeyFrame = self.putKey.frame;
            self.putKey.frame = CGRectMake(putKeyFrame.origin.x, putKeyFrame.origin.y, 280, putKeyFrame.size.height);
            
            CGRect putCommentFrame = self.putComment.frame;
            self.putComment.frame = CGRectMake(putCommentFrame.origin.x, putCommentFrame.origin.y, 280, putCommentFrame.size.height);
            
            CGRect putUrlFrame = self.putUrl.frame;
            self.putUrl.frame = CGRectMake(putUrlFrame.origin.x, putUrlFrame.origin.y, 280, putUrlFrame.size.height);
            
            CGRect buttonFrame = button.frame;
            button.frame = CGRectMake(buttonFrame.origin.x, buttonFrame.origin.y, 280, buttonFrame.size.height);
            
            self.frame = CGRectMake(0, 0, 320, 480);
        
        }else{
            
            scrollView.frame = CGRectMake(scrollFrame.origin.x, scrollFrame.origin.y, screenSize.height, scrollFrame.size.height);
            descLbl.frame = CGRectMake(108, 30, 340, 75);
            messageView.frame = CGRectMake((scrollFrame.size.width-messageFrame.size.width)/2, 140, messageFrame.size.width, messageFrame.size.height);
            
            CGRect putKeyFrame = self.putKey.frame;
            self.putKey.frame = CGRectMake(putKeyFrame.origin.x, putKeyFrame.origin.y, 420, putKeyFrame.size.height);
            
            CGRect putCommentFrame = self.putComment.frame;
            self.putComment.frame = CGRectMake(putCommentFrame.origin.x, putCommentFrame.origin.y, 420, putCommentFrame.size.height);
            
            CGRect putUrlFrame = self.putUrl.frame;
            self.putUrl.frame = CGRectMake(putUrlFrame.origin.x, putUrlFrame.origin.y, 420, putUrlFrame.size.height);
            
            CGRect buttonFrame = button.frame;
            button.frame = CGRectMake(buttonFrame.origin.x, buttonFrame.origin.y, 420, buttonFrame.size.height);
        }
        [scrollView setContentSize:CGSizeMake(screenSize.width, 600)];
        ratingView.frame = CGRectMake((button.frame.size.width-230)/2, button.frame.origin.y+button.frame.size.height+10, 320, 55);
    }else{
    
    }
    */
}

-(void)buildNewLink:(int)offset andWidth:(int)width andHeight:(int)height
{
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0.0,0+offset, 50, 20.0)];
    title.text = @"Title:";
    title.backgroundColor = [UIColor clearColor];
    title.textColor = UIColorFromRGB(SEC_COLOR_3,1.0);
    [title setFont:[UIFont fontWithName:@"Helvetica" size:11]];
    [messageView addSubview:title];
    
    UITextField *titleInput = [[UITextField alloc] initWithFrame:CGRectMake(60,0+offset, width-60, height)];
    [titleInput setBorderStyle:UITextBorderStyleRoundedRect];
    [titleInput setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    [titleInput setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [titleInput setKeyboardType:UIKeyboardTypeURL];
    [titleInput setReturnKeyType:UIReturnKeyDone];
    [titleInput setPlaceholder:@""];
    titleInput.tag = 1001;
    [titleInput setDelegate:(id<UITextFieldDelegate>)self];
    [messageView addSubview:titleInput];
    offset += height+2;
    
    UITextField *_putUrl = [[UITextField alloc] initWithFrame:CGRectMake(0,0+offset, width, height)];
    [_putUrl setBorderStyle:UITextBorderStyleRoundedRect];
    [_putUrl setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    [_putUrl setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_putUrl setKeyboardType:UIKeyboardTypeURL];
    [_putUrl setReturnKeyType:UIReturnKeyDone];
    [_putUrl setPlaceholder:NSLocalizedString(@"put_url_placeholder",nil)];
    [_putUrl setDelegate:(id<UITextFieldDelegate>)self];
    [messageView addSubview:_putUrl];
    offset += height+2;
    
    [putLinks addObject:[NSDictionary dictionaryWithObjectsAndKeys:titleInput,@"title",_putUrl,@"link", nil]];
    newOffset = offset;
    self.validationError.frame = CGRectMake(0.0,0+offset, width, 40.0);
    button.frame = CGRectMake(0, 0+offset+35, width, 54.0);
    int oo = 560;
    if (isIPad) {
        oo = 1140;
    }
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    messageView.frame = CGRectMake(messageFrame.origin.x, messageFrame.origin.y, messageFrame.size.width, oo+(putCount*height*2.5));
    [scrollView setContentSize:CGSizeMake(screenSize.width, oo+(putCount*height*2.5))];
    self.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
}

- (void)refreshUIWithError:(ErrorDef*)error
{
    
    
    NSLog(@"********** refreshUIWithError %@",error.fields);
    
    if(submitAgain != nil){
        [submitAgain removeFromSuperview];
        submitAgain = nil;
        [loading removeFromSuperview];
        loading = nil;
    }
    
    int offset = -10;
    self.backgroundColor = UIColorFromRGB(BACKGROUND, 1);
    
    CALayer *imageLayer = self.imageView.layer;
    imageLayer.masksToBounds = YES;
    imageLayer.cornerRadius = 12;
    if(isIPad) imageLayer.cornerRadius = 32;
    
    // Display the snapped image.
    AppDataObject *ado = [[S2LIRRequestMaker sharedClient] ado];
    NSData *capturedData = ado.capturedData;
    
	if (capturedData){
        //NSLog(@"********** refreshUIWithError %@",capturedData);
        UIImage* img = [[UIImage alloc] initWithData:capturedData];
        if (DEBUG_VERBOSE) NSLog(@"ErrorSubview captured image dimensions: %f x %f", img.size.width, img.size.height);
		[imageView setImage:img];
	}
    
    // Display the Oops! title.
    NSString *errorTitle = NSLocalizedString(@"error",nil);
    [errorTitleView setText:errorTitle];
    errorTitleView.textColor = UIColorFromRGB(SEC_COLOR_1, 1.0);
    [errorTitleView setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    errorTitleView.frame = CGRectMake(105, imageView.frame.origin.y, 300, 44);
    [errorTitleView sizeToFit];

    
    //remove all subViews
    for (UIView *view in self.messageView.subviews) {
        [view removeFromSuperview];
    }
    
    messageFrame = messageView.frame;
    
    // Find out if there is a description which is the first of any Field.message texts.
    NSString* description = nil;
    for (Field* f in error.fields.field) {
        if (f.msg != nil && f.msg.length > 0) {
            description = f.msg;
            break;
        }
    }
    
    // If network error or if legacy behaviour (no PUT option), display the Fields from the server.
    PersistenceManager *pm = [PersistenceManager sharedInstance];
    if ([description isEqualToString:NSLocalizedString(@"transfer_error", nil)] || ![pm.settings.settingPutOption boolValue]) {
    
        // Display a description which is the first of any Field.message texts.
        __block BOOL descFound = NO;
        if (description != nil) {
            NSLog(@"******* descLbl %@",descLbl);
            dispatch_async(dispatch_get_main_queue(), ^{
                descLbl.text = description;
                descLbl.textColor = UIColorFromRGB(SEC_COLOR_3, 1.0);
                [descLbl setFont:[UIFont fontWithName:@"Helvetica" size:11]];
                int x = 108;
                if(isIPad) x = 210;
                descLbl.frame = CGRectMake(x, 48, 220, 75);
                descFound = YES;
                [descLbl sizeToFit];
            });
        }
        
        int width = 320;
        if (isIPad) {
            width = 768;
        }

        for (Field* f in error.fields.field) {
            // Field.msg text.
            if (f.msg != nil && f.msg.length > 0) {
                if (descFound) descFound = NO;
                else {
                   /* UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0,0+offset, 280.0, 25.0)];
                    lbl.backgroundColor = [UIColor clearColor];
                    lbl.textColor = UIColorFromRGB(SEC_COLOR_3,1.0);
                    lbl.numberOfLines = 0;
                    [lbl setFont:[UIFont fontWithName:@"Helvetica" size:11]];
                    [lbl setText:f.msg];
                    
                    CGSize maximumLabelSize = CGSizeMake(280.0, 9999);
                    CGSize expectedLabelSize = [f.msg sizeWithFont:lbl.font
                                                 constrainedToSize:maximumLabelSize
                                                     lineBreakMode:lbl.lineBreakMode];
                    // Adjust the label to the new height.
                    CGRect newFrame = lbl.frame;
                    newFrame.size.height = expectedLabelSize.height;
                    lbl.frame = newFrame;
                    
                    [messageView addSubview:lbl];
                    offset += expectedLabelSize.height+20;
                    */
                }
            }
            messageView.frame = messageFrame;
            //now the buttons
            offset = 200;
            int width = self.frame.size.width;
            if(isIPad){
                offset = 10;
                width = 694;
            } 
            for (Action* a in f.actions.action){
                UIButton *_button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                _button.frame = CGRectMake((width-280)/2, offset, 280, 54.0);
                [_button setTitle:a.label forState:UIControlStateNormal];
                [_button addTarget:self action:@selector(buttonPressedAction:) forControlEvents:UIControlEventTouchUpInside];
                [_button setBackgroundImage:[UIImage imageNamed:@"buttonbg.png"] forState:UIControlStateNormal];
                [_button setTitleColor:UIColorFromRGB(SEC_COLOR_1, 1.0) forState:UIControlStateNormal];
                _button.buttonUrl = a.url;
                [_button setStyle];
                if(isIPad)[messageView addSubview:_button];
                else [self addSubview:_button];
                offset += _button.bounds.size.height+10;
            }
        }

        offset = 300;
        
        submitAgain = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        submitAgain.frame = CGRectMake((width-280)/2, offset, 280, 54.0);
        [submitAgain setTitle:NSLocalizedString(@"error_submit_btn", nil) forState:UIControlStateNormal];
        [submitAgain addTarget:self action:@selector(submitAgainAction) forControlEvents:UIControlEventTouchUpInside];
        [submitAgain setBackgroundImage:[UIImage imageNamed:@"buttonbg.png"] forState:UIControlStateNormal];
        [submitAgain setTitleColor:UIColorFromRGB(SEC_COLOR_1, 1.0) forState:UIControlStateNormal];
        [submitAgain setStyle];
        [self addSubview:submitAgain];
        
        [self bringSubviewToFront:messageView];
    }
    else {
        
        
        NSLog(@"** MessageFrame %f",messageFrame.size.width);
        scrollFrame = scrollView.frame;
        NSLog(@"** scrollFrame %f",scrollFrame.size.width);
        // This is the PUT option. Display prompt texts and data entry fields;
        // Display a description telling the user he may PUT a new snap.
        descLblFrame = descLbl.frame;
        descLblFrame.origin.y = errorTitleView.frame.origin.y+errorTitleView.frame.size.height;
        [descLbl setText:NSLocalizedString(@"put_intro_text",nil)];
        descLbl.textColor = UIColorFromRGB(SEC_COLOR_3, 1.0);
        [descLbl setFont:[UIFont fontWithName:@"Helvetica" size:11]];
        descLbl.frame = descLblFrame;
        // Add a prompt and entry field for the key.
        int width = 280;
        int height = 20;
        if (isIPad) {
            height = 50;
            width = 694;
        }
        
        UILabel* putKeyLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0,0+offset, width, 20.0)];
        putKeyLbl.backgroundColor = [UIColor clearColor];
        putKeyLbl.textColor = UIColorFromRGB(SEC_COLOR_3,1.0);
        putKeyLbl.numberOfLines = 1;
        [putKeyLbl setFont:[UIFont fontWithName:@"Helvetica" size:11]];
        [putKeyLbl setText:NSLocalizedString(@"put_key_label",nil)];
        [messageView addSubview:putKeyLbl];
        offset += 16;
        
        self.putKey = [[UITextField alloc] initWithFrame:CGRectMake(0,0+offset, width, height)];
        [putKey setBorderStyle:UITextBorderStyleRoundedRect];
        [putKey setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        [putKey setAutocapitalizationType:UITextAutocapitalizationTypeWords];
        [putKey setKeyboardType:UIKeyboardTypeDefault];
        [putKey setReturnKeyType:UIReturnKeyDone];
        [putKey setPlaceholder:NSLocalizedString(@"put_key_placeholder",nil)];
        [putKey setDelegate:(id<UITextFieldDelegate>)self];
        [messageView addSubview:putKey];
        offset += 24;
        if(isIPad)offset+=30;
        // Add a prompt and entry field for the comment.
        UILabel* putCommentLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0,0+offset, width, 20.0)];
        putCommentLbl.backgroundColor = [UIColor clearColor];
        putCommentLbl.textColor = UIColorFromRGB(SEC_COLOR_3,1.0);
        putCommentLbl.numberOfLines = 1;
        [putCommentLbl setFont:[UIFont fontWithName:@"Helvetica" size:11]];
        [putCommentLbl setText:NSLocalizedString(@"put_comment_label",nil)];
        [messageView addSubview:putCommentLbl];
        offset += 16;
        
        self.putComment = [[UITextField alloc] initWithFrame:CGRectMake(0,0+offset, width, height)];
        [putComment setBorderStyle:UITextBorderStyleRoundedRect];
        [putComment setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        [putComment setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
        [putComment setKeyboardType:UIKeyboardTypeDefault];
        [putComment setReturnKeyType:UIReturnKeyDone];
        [putComment setPlaceholder:NSLocalizedString(@"put_comment_placeholder",nil)];
        [putComment setDelegate:(id<UITextFieldDelegate>)self];
        [messageView addSubview:putComment];
        offset += 24;
        if(isIPad)offset+=30;
        
        
        putLinks = [NSMutableArray array];
        
        UILabel* putUrlLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0,0+offset, width, 20.0)];
        putUrlLbl.backgroundColor = [UIColor clearColor];
        putUrlLbl.textColor = UIColorFromRGB(SEC_COLOR_3,1.0);
        putUrlLbl.numberOfLines = 1;
        [putUrlLbl setFont:[UIFont fontWithName:@"Helvetica" size:11]];
        [putUrlLbl setText:NSLocalizedString(@"put_url_label",nil)];
        [messageView addSubview:putUrlLbl];
        offset += 20;
        
        [self buildNewLink:offset andWidth:width andHeight:height];
        
        offset = newOffset;
        
        // Add an empty validation error field in red.
        self.validationError = [[UILabel alloc] initWithFrame:CGRectMake(0.0,0+offset, width, 40.0)];
        validationError.backgroundColor = [UIColor clearColor];
        validationError.textColor = UIColorFromRGB(0xFF0000,1);
        validationError.numberOfLines = 3;
        [validationError setFont:[UIFont fontWithName:@"Helvetica" size:11]];
        [messageView addSubview:validationError];
        offset += 30;
        
        // Add a submit button.
        button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(0, 0+offset+20, width, 54.0);
        [button setTitle:NSLocalizedString(@"put_submit_button_text",nil) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPressedSubmit:) forControlEvents:UIControlEventTouchUpInside];
        [button setStyle];
        
        [messageView addSubview:button];
        offset += button.bounds.size.height+10;
    }
    putCount = 1;
    // set content size for scrolling
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
   // messageView.frame = CGRectMake(messageFrame.origin.x, messageFrame.origin.y, messageFrame.size.width, 300+(putCount*60));
   // [scrollView setContentSize:CGSizeMake(screenSize.width, 300+(putCount*60))];
    //if(isIPad)self.frame = CGRectMake(0, 0, 768, 1024);

}

-(void)removeLoading
{
    [loading removeFromSuperview];
    loading = nil;
}

-(void)submitAgainAction
{
    if(loading == nil && [[AFS2LAppAPIClient sharedClient] isReachable]){
        loading = [[UIView alloc]initWithFrame:CGRectMake((self.frame.size.width-220)/2, (self.frame.size.height-220)/2, 220, 220)];
        loading.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        loading.layer.cornerRadius = 22;
        loading.layer.masksToBounds = YES;
        UIActivityIndicatorView *preloader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        preloader.frame = CGRectMake((220-30)/2, (220-30)/2, 30, 30);
        [loading addSubview:preloader];
        [preloader startAnimating];
        [self addSubview:loading];
    }
    
    S2LIRRequestMaker *requestMaker = [S2LIRRequestMaker sharedClient];
    [requestMaker evaluateBestMatch:imageView.image success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument) {
        [loading removeFromSuperview];
        loading = nil;
        
        S2LSerializerAPI2 *serializer = [[S2LSerializerAPI2 alloc] init];
        NSObject *obj = [serializer deserializeObjectDef:XMLDocument];
        
        if (obj == nil) {
            obj = [serializer deserializeError:XMLDocument];
        }
        [delegate setCurrentHistory:history];
        [delegate changeScreen:obj];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument) {
        
    }];

}

/*
 * Method called when an Action Button is pressed.
 */
- (void)buttonPressedAction:(id)sender
{
    UIButton *theButton = (UIButton*) sender;
    [webOpenDelegate setCurrentHistory:history];
    [webOpenDelegate openWebUrlAndStore:(NSString*)theButton.buttonUrl andTargetName:[history.snapID stringValue]];

}

// Method called when the Submit button is pressed in PUT mode.
- (void)buttonPressedSubmit:(id)sender {
    
    if (![[AFS2LAppAPIClient sharedClient] isReachable]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You don´t have internet connection. The Snap will be saved on your device and you can send it when you´ll have internet connection again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        return;
    }

    
    // Reset any previous validation errors.
    [putKey setBackgroundColor:[UIColor whiteColor]];
    [putComment setBackgroundColor:[UIColor whiteColor]];
   
    [validationError setText:@""];
    
    // Trim any whitespace from the strings to be submitted.
    [putKey setText:[[putKey text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    if ([[putKey text] length] == 0) {
        [validationError setText:NSLocalizedString(@"put_vali_empty_key",nil)];
        [putKey setBackgroundColor:UIColorFromRGB(0xFF0000,1)];
        return;
    }

    __block BOOL isSendable = YES;
    NSMutableArray *links = [NSMutableArray array];
    if (putLinks.count > 0) {
        [putLinks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            NSDictionary *dic = (NSDictionary*)obj;
            UITextField *putUrl = [dic objectForKey:@"link"];
            UITextField *putTitle = [dic objectForKey:@"title"];
        
            if ([[putTitle text] length] > 0){
                if ([[putUrl text] length] == 0) {
                    [validationError setText:NSLocalizedString(@"put_vali_empty_comment",nil)];
                    [putUrl setBackgroundColor:UIColorFromRGB(0xFF0000,1)];
                    isSendable = NO;
                }
            }else if([[putUrl text] length] > 0){
                if ([[putTitle text] length] == 0) {
                    [validationError setText:NSLocalizedString(@"put_vali_empty_comment",nil)];
                    [putTitle setBackgroundColor:UIColorFromRGB(0xFF0000,1)];
                    isSendable = NO;
                }
            }
            
            [putUrl setBackgroundColor:[UIColor whiteColor]];
            [putUrl setText:[[putUrl text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            
            // Put "http://" in front of the URL if it is not there and is not some other protocol such as mailto:
            if ([[putUrl text] length] > 0) {
                NSURL* url = [NSURL URLWithString:[[putUrl text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                if (url != nil && [url scheme] == nil) {
                    [putUrl setText:[NSString stringWithFormat:@"http://%@", [putUrl text]]];
                    url = [NSURL URLWithString:[[putUrl text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    
                }
                if (url == nil) {
                    [validationError setText:NSLocalizedString(@"put_vali_malformed_url",nil)];
                    [putUrl setBackgroundColor:UIColorFromRGB(0xFF0000,1)];
                    return;
                }
                if (DEBUG_VERBOSE) NSLog(@"ErrorSubview url:%@, scheme:%@", url.absoluteString, url.scheme);
                [putUrl setText:[url absoluteString]];
                [links addObject:[NSDictionary dictionaryWithObjectsAndKeys:putUrl.text,@"link",putTitle.text,@"title", nil]];
            }
            
        }];
    }
    
    if (!isSendable) {
        return;
    }
    
    BOOL mandatory = NO;
    if (links.count == 0) {
        mandatory = YES;
    }
        [putComment setText:[[putComment text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        if (mandatory && [[putComment text] length] == 0) {
            [validationError setText:NSLocalizedString(@"put_vali_empty_comment",nil)];
            [putComment setBackgroundColor:UIColorFromRGB(0xFF0000,1)];
            return;
        }else if([[putComment text] length] > 0){
            [putComment resignFirstResponder];
            [links addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"link",putComment.text,@"title", nil]];
        }
    

    NSLog(@"**ERROR SUBVIEW DELEGATE %@",delegate);
    S2LIRRequestMaker *requestMaker = [S2LIRRequestMaker sharedClient];
    UIButton *btn = (UIButton*)sender;
    btn.enabled = NO;
    [requestMaker recordForMatch:imageView.image title:putKey.text comment:putComment.text linksPath:links success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument) {
        
        NSLog(@"XML PUT OPTION: %@",XMLDocument);
        
        S2LSerializerAPI2 *serializer = [[S2LSerializerAPI2 alloc] init];
        NSObject *obj = [serializer deserializeObjectDef:XMLDocument];
        
        if (obj == nil) {
            obj = [serializer deserializeError:XMLDocument];
        }
        [delegate setCurrentHistory:history];
        [delegate changeScreen:obj];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument) {
        NSLog(@"** PUT Failure :%@",XMLDocument);
    }];

}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 1001) {
        if (putCount < HOWMANY_PUT_LINKS) {
            putCount++;
            
            int width = 280;
            int height = 20;
            if (isIPad) {
                height = 50;
                width = 694;
            }
            
            [self buildNewLink:newOffset andWidth:width andHeight:height];
        }
       
    }
    return YES;
}


// Method called when the Return key is pressed on the keyboard for a text field.
- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    if (DEBUG_VERBOSE) NSLog(@"ErrorSubview.textFieldShouldReturn:");
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidUnload {
    
    self.imageView = nil;
    self.messageView = nil;
    self.scrollView = nil;
    self.errorTitleView = nil;
    self.descLbl = nil;
    self.putKey = nil;
    self.putComment = nil;
    self.validationError = nil;
}

@end

