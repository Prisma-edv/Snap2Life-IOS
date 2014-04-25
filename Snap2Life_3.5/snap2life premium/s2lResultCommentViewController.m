//
//  s2lResultCommentViewController.m
//  snap2life suite
//
//  Created by Antonio Stilo on 20.03.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "s2lResultCommentViewController.h"
#import "AppDataObject.h"
#import "s2lAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "Feature.h"

@interface s2lResultCommentViewController ()

@end

@implementation s2lResultCommentViewController

-(void)popModal
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)viewDidLayoutSubviews
{
    if(!isIPad){
        if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
            _textField.frame = CGRectMake(20, 20, 280, 40);
            btn.frame = CGRectMake(20, 65, 280, 40);
        }else{
            _textField.frame = CGRectMake((480-280)/2, 20, 280, 40);
            btn.frame = CGRectMake((480-280)/2, 65, 280, 40);
        }
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _textField.text = @"";
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        int width = 280;
        if(isIPad) width = 730;
        
        self.view.backgroundColor = [UIColor blackColor];
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, width, 40)];
        _textField.delegate = self;
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.layer.cornerRadius = 5;
        _textField.clipsToBounds = YES;
        _textField.keyboardType = UIKeyboardTypeEmailAddress;
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [self.view addSubview:_textField];
        
        btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(20, 65, width, 40);
        [btn setTitle:NSLocalizedString(@"comment_save", nil) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(commentHandler) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    return self;
}

-(void)commentHandler
{
   /* s2lAppDelegate *appDelegate = (s2lAppDelegate*)[[UIApplication sharedApplication] delegate];
    MyAppDataObject *ado = appDelegate.ado;
    
    Feature *f = [[Feature alloc] init];
    f.name = _textField.text;
    [ado.features addObject:f];
    */
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIToolbar *toolbar = self.navigationController.toolbar;
    toolbar.tintColor = UIColorFromRGB(BACKGROUND, 1.0);
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.tintColor = UIColorFromRGB(BACKGROUND, 1.0);
    
    if(!isIPad){
	UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(popModal)];
    self.navigationItem.leftBarButtonItem = button;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
