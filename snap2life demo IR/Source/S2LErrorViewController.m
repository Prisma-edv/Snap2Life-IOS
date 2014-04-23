//
//  S2LErrorViewController.m
//  snap2life suite
//
//  Created by Antonio_Stilo on 11/21/13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "S2LErrorViewController.h"
#import "AppDataObject.h"
#import "S2LIRRequestMaker.h"
#import "S2LPutLinkView.h"
#import "S2LSerializerAPI2.h"
#import "AFS2LAppAPIClient.h"
#import "S2LNewResultViewController.h"
#import "UIButton+UIButton_style.h"
#import "Extra.h"
#import "Constants.h"

@interface S2LErrorViewController ()

@end

@implementation S2LErrorViewController
@synthesize errorObject,resultIndex;

#pragma mark UITextField Delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if([textField.text isEqualToString:NSLocalizedString(@"put_comment_label",nil)] ||
       [textField.text isEqualToString:NSLocalizedString(@"put_key_label",nil)] ||
       [textField.text isEqualToString:NSLocalizedString(@"put_description_label",nil)])
        textField.text = @"";
    
    [self scrollToPosition:textField.frame.origin.y-30];
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark UIViewController


-(IBAction)submitHandler:(id)sender
{
    if (![[AFS2LAppAPIClient sharedClient] isReachable]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You don´t have internet connection. The Snap will be saved on your device and you can send it when you´ll have internet connection again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    [nameBackground setBackgroundColor:[UIColor whiteColor]];
    [commentBackground setBackgroundColor:[UIColor whiteColor]];
    
    [nameText setText:[[nameText text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    if ([nameText.text isEqualToString:NSLocalizedString(@"put_key_label",nil)] || [nameText.text isEqualToString:@""]) {
        [nameBackground setBackgroundColor:[UIColor orangeColor]];
        return;
    }
    
    __block BOOL isSendable = YES;
    NSMutableArray *linksToSend = [NSMutableArray array];
    if (links.count > 0) {
        [links enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            S2LPutLinkView *tmp = (S2LPutLinkView*)obj;
            NSDictionary *dic = [tmp evaluate:links atIndex:idx];
            
            if (dic != nil) {
                [linksToSend addObject:dic];
            }else{
                if(idx < links.count-1){
                    isSendable = NO;
                    stop = YES;
                }
            }
        }];
    }
    
    if (!isSendable) {
        return;
    }
    
    BOOL mandatory = NO;
    if (linksToSend.count == 0) {
        mandatory = YES;
    }
    [commentText setText:[[commentText text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    if (mandatory && ([commentText.text isEqualToString:NSLocalizedString(@"put_comment_label",nil)] || [commentText.text isEqualToString:@""])) {
        [commentBackground setBackgroundColor:[UIColor orangeColor]];
        return;
    }else if([[commentText text] length] > 0){
        [commentText resignFirstResponder];
    }
    
    NSString *description = descriptionText.text;
    if([description isEqualToString:NSLocalizedString(@"put_description_label",nil)])description = @"";
    
    S2LIRRequestMaker *requestMaker = [S2LIRRequestMaker sharedClient];
    UIButton *btn = (UIButton*)sender;
    btn.enabled = NO;
    [requestMaker recordForMatch:background.image title:nameText.text comment:commentText.text description:description linksPath:linksToSend success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument) {
        
        NSLog(@"XML PUT OPTION: %@",XMLDocument);
        
        S2LSerializerAPI2 *serializer = [[S2LSerializerAPI2 alloc] init];
        NSObject *obj = [serializer deserializeObjectDef:XMLDocument];
        
        if (obj == nil) {
            obj = [serializer deserializeError:XMLDocument];
        }
        
        if ([obj isKindOfClass:[ObjectDef class]]) {
            S2LNewResultViewController *resultVC = (S2LNewResultViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"result"];
            resultVC.object = (ObjectDef*)obj;
            resultVC.index = 1;
            [self.navigationController pushViewController:resultVC animated:YES];

        }
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument) {
        NSLog(@"** PUT Failure :%@",XMLDocument);
    }];
    

    
}

-(void)buildInterface
{
    AppDataObject *ado = [[S2LIRRequestMaker sharedClient] ado];
    NSData *capturedData = ado.capturedData;
	if (capturedData){
        UIImage *img = [[UIImage alloc] initWithData:capturedData];
        background.image = img;
	}
    
    NSString *errorTitle = NSLocalizedString(@"error",nil);
    titleLable.text = errorTitle;
   

        int offset = 200;
        int width = self.view.frame.size.width;
        if(isIPad){
            offset = 10;
            width = 768;
        }
        containerView.hidden = YES;
        NSString* description = nil;
        for (Field* f in errorObject.fields.field) {
            if (f.msg != nil && f.msg.length > 0) {
                description = f.msg;
                break;
            }
            
            
            for (Action* a in f.actions.action){
                UIButton *_button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                _button.frame = CGRectMake((width-280)/2, offset, 280, 54.0);
                [_button setTitle:a.label forState:UIControlStateNormal];
                [_button addTarget:self action:@selector(buttonPressedAction:) forControlEvents:UIControlEventTouchUpInside];
                [_button setBackgroundImage:[UIImage imageNamed:@"buttonbg.png"] forState:UIControlStateNormal];
                [_button setTitleColor:UIColorFromRGB(SEC_COLOR_1, 1.0) forState:UIControlStateNormal];
                //_button.buttonUrl = a.url;
                [_button setStyle];
               [self.view addSubview:_button];
                offset += _button.bounds.size.height+10;
            }

        }
        
        descriptionLabel.text = description;
        
    offset = 300;
    
}
-(void)addLink:(CGFloat)offset
{
    [self buildLink:offset];
    [self scrollToPosition:offset-90];
}
-(void)buildLink:(CGFloat)offset
{
    if (links.count < HOWMANY_PUT_LINKS) {
        [links enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            S2LPutLinkView *tmp = (S2LPutLinkView*)obj;
            tmp.addButton.hidden = YES;
        }];
        
        S2LPutLinkView* tempView = [[S2LPutLinkView alloc] initWithFrame:CGRectMake(0, offset, self.view.frame.size.width, 94)];
        tempView.delegate = self;
        [links addObject:tempView];
        [containerView addSubview:tempView];
        submitButton.frame = CGRectMake((self.view.frame.size.width-submitButton.frame.size.width)/2, offset+100, submitButton.frame.size.width, submitButton.frame.size.height);
        int h = 220;
        if (isIPad) {
            h = 900;
        }
        scroll.contentSize = CGSizeMake(self.view.frame.size.width, containerView.frame.origin.y + offset + h);
        containerView.opaque = NO;
        if (HOWMANY_PUT_LINKS == 1) {
            tempView.addButton.hidden = YES;
        }
    }
}

-(void)scrollToPosition:(CGFloat)offset
{
    [scroll setContentOffset:CGPointMake(scroll.frame.origin.x, containerView.frame.origin.y + offset) animated:YES];
    
}


-(void)backBtnUserClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self buildInterface];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back_btn", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(backBtnUserClicked)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
