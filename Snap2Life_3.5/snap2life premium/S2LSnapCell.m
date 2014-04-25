//
//  S2LSnapCell.m
//  snap2life suite
//
//  Created by iOS on 12.12.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "S2LSnapCell.h"
#import "S2LCommunityManager.h"
#import "S2LNavigationUtils.h"
#import "RequestUtils.h"
#import "ObjectDef.h"
#import "S2LSerializerAPI2.h"
#import "ADPopupView.h"
#import "S2LShearPopView.h"
#import "S2LCommentPopoView.h"
#import "PersistenceManager.h"


@implementation S2LSnapCell
@synthesize snapDef,parent,commentBtn,shearBtn;
@synthesize table,avatarImageView,snapImageView;

-(void)setSnapDef:(S2LCommunitySnapDef *)_snapDef
{
    if (snapDef != _snapDef) {
        isChanging = YES;
    }
    
    snapDef = _snapDef;
    [shearPopUP hide:YES];
    [commentPopUP hide:YES];
    
    table.backgroundColor = [UIColor clearColor];
    table.backgroundView = nil;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    PersistenceManager* pm = [PersistenceManager sharedInstance];
    if([pm.profile.name isEqualToString:@""]){
        commentBtn.hidden = YES;
    }

}


#pragma mark UITABLEVIEW

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return oldComments.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"commentCell";
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"_baloon-community.png"]];
        cell.backgroundColor = UIColorFromRGB(PROFILEBCKCOLOR, 0.5);
    }
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSDictionary *dic = [oldComments objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"comment"];
    cell.detailTextLabel.text = [dateFormatter stringFromDate:[RequestUtils dateFromIsoString:[dic objectForKey:@"date"]]];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

#pragma mark UIVIEWCONTROLLER

-(void)ADPopupViewDidTap:(ADPopupView *)popup
{


}

-(IBAction)shearHandler
{
    if (shearPopUP.superview == nil) {
        [commentPopUP hide:YES];
        S2LShearPopView *view = [[S2LShearPopView alloc] initWithFrame:CGRectMake(0, 0, 272, 108)];
        view.parent = parent;
        view.image = snapImageView.image;
        
        shearPopUP = [[ADPopupView alloc] initAtPoint:CGPointMake(shearBtn.center.x, shearBtn.center.y+24) delegate:self withContentView:view];
        shearPopUP.popupColor = [UIColor whiteColor];
        [shearPopUP showInView:self animated:YES];
        
    }else{
        [shearPopUP hide:YES];
    }

}

-(IBAction)commentHandler
{
    if (commentPopUP.superview == nil) {
        [shearPopUP hide:YES];
        
        S2LCommentPopoView *view = [[S2LCommentPopoView alloc] initWithFrame:CGRectMake(0, 0, 230, 108)];
        view.parent = self;
        view.snapID = snapDef.snapId;
        [view setSuccess:^(){
            [commentPopUP hide:YES];
            [self setNeedsLayout];
            [self layoutIfNeeded];
        }];
        
        commentPopUP = [[ADPopupView alloc] initAtPoint:CGPointMake(commentBtn.center.x, commentBtn.center.y+24) delegate:self withContentView:view];
        commentPopUP.popupColor = [UIColor whiteColor];
        [commentPopUP showInView:self animated:YES];
    }else{
        [commentPopUP hide:YES];
    }
}

/*
-(void)shearFBHandler
{
    
}

-(void)shearTwitterHandler
{
    [S2LNavigationUtils shearOnTweeter:snapImageView.image fromViewController:parent];
}
*/


-(void)layoutSubviews
{
    preloader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    preloader.center = self.center;
    [self addSubview:preloader];
    
    if(isChanging){
        self.title.alpha = 0.0;
        S2LSerializerAPI2 *serializer = [[S2LSerializerAPI2 alloc] init];
        ObjectDef *obj = [serializer deserializeObjectDefWithString:snapDef.value];
        self.title.text = obj.infos.title;
        snapImageView.alpha = 0.0;
        table.alpha = 0.0;
        oldComments = nil;
    }

    S2LCommunityManager *cm = [S2LCommunityManager sharedInstance];

    [cm loadSnap:snapDef.snapId withCompletition:^(UIImage *snap) {
        self.snapImageView.image = snap;
    }];
    
    
    [cm loadAvatar:snapDef.snapperId withCompletition:^(UIImage *avatar) {
        self.avatarImageView.image = avatar;
    }];
    

    [cm loadComments:snapDef.snapId withCompletition:^(NSArray *comments) {
        oldComments = comments;
        if(isChanging){
            [UIView animateWithDuration:0.7 animations:^{
                self.title.alpha = 1.0;
                table.alpha = 1.0;
                snapImageView.alpha = 1.0;
                isChanging = NO;
            }];
        }
        [self.table reloadData];
        [preloader removeFromSuperview];
        preloader = nil;
    }];

}

@end
