//
//  S2LPutLinkView.m
//  snap2life suite
//
//  Created by Antonio_Stilo on 11/21/13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "S2LPutLinkView.h"
#import "S2LErrorViewController.h"

@implementation S2LPutLinkView

@synthesize delegate,addButton;

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.text = @"";
    [(S2LErrorViewController*)delegate scrollToPosition:self.frame.origin.y];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        int width = 320;
        if (isIPad) {
            width = 768;
        }
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        titleBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
        titleBackground.backgroundColor = [UIColor whiteColor];
        [self addSubview:titleBackground];
        
        titleText = [[UITextField alloc] initWithFrame:CGRectMake(20, 4, width-40, 44)];
        titleText.backgroundColor = [UIColor clearColor];
        titleText.text = NSLocalizedString(@"ups_title", nil);
        [titleBackground addSubview:titleText];
        titleText.delegate = self;
        
        linkBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 50, width, 44)];
        linkBackground.backgroundColor = [UIColor whiteColor];
        [self addSubview:linkBackground];
        
        linkText = [[UITextField alloc] initWithFrame:CGRectMake(20, 4, width-40, 44)];
        linkText.backgroundColor = [UIColor clearColor];
        linkText.text = @"http://";
        linkText.keyboardType = UIKeyboardTypeURL;
        linkText.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [linkBackground addSubview:linkText];
        linkText.delegate = self;
        
        addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addButton.frame = CGRectMake(width - 44, 0, 44, 44);
        [addButton setImage:[UIImage imageNamed:@"_ups-addlink-btn.png"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addHandler) forControlEvents:UIControlEventTouchUpInside];
        [linkBackground addSubview:addButton];
        // Initialization code
    }
    return self;
}

-(NSDictionary*)evaluate:(NSArray*)links atIndex:(NSInteger)index
{
    [linkBackground setBackgroundColor:[UIColor whiteColor]];
    [titleBackground setBackgroundColor:[UIColor whiteColor]];
    
    if ((links.count-1 == index) && [[titleText text] isEqualToString:NSLocalizedString(@"ups_title", nil)] && [[linkText text] isEqualToString:@"http://"]) {
        return nil;
    }
    
    
    if ([[titleText text] isEqualToString:NSLocalizedString(@"ups_title", nil)] || [[titleText text] length] == 0){
            [titleBackground setBackgroundColor:[UIColor orangeColor]];
            return nil;
    }
    
    if(![[linkText text] isEqualToString:@"http://"]){
        if ([[titleText text] isEqualToString:NSLocalizedString(@"ups_title", nil)]) {
            [titleBackground setBackgroundColor:[UIColor orangeColor]];
            return nil;
        }
    }else{
        [linkBackground setBackgroundColor:[UIColor orangeColor]];
        return nil;
    }
    
    
    [linkText setText:[[linkText text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];

    NSURL* url = [NSURL URLWithString:[[linkText text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if (url != nil && [url scheme] == nil) {
        [linkText setText:[NSString stringWithFormat:@"http://%@", [linkText text]]];
        url = [NSURL URLWithString:[[linkText text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
    }
    if (url == nil) {
        [linkBackground setBackgroundColor:[UIColor orangeColor]];
        return nil;
    }
    [linkText setText:[url absoluteString]];
    
    
    return [NSDictionary dictionaryWithObjectsAndKeys:titleText.text,@"title",linkText.text,@"link", nil];

}


-(void)addHandler
{
    [(S2LErrorViewController*)delegate addLink:self.frame.origin.y+self.frame.size.height + 6];
}

@end
