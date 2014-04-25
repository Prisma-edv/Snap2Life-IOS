//
//  s2lResultView.h
//  snap2life suite
//
//  Created by Antonio Stilo on 11.02.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDataObject.h"
#import "History.h"
#import "ASVoteView.h"
#import "S2LProtocols.h"
#import "ObjectDef.h"


@interface s2lResultView : UIView <UITableViewDelegate,UITableViewDataSource>
{
    ASVoteView *ratingView;
    UIButton *commentBtn;
    BOOL isFavourite;
    NSArray *features;
}

/*
 Constants for the diferent element types that the server
 can return in response to a request.
 */
#define FIELD_TYPE_ERROR -1;
#define FIELD_TYPE_STRING 0;
#define FIELD_TYPE_INT 1;
#define FIELD_TYPE_DOUBLE 2;
#define FIELD_TYPE_DATUM 3;
#define FIELD_TYPE_BOOLEAN 4;
#define FIELD_TYPE_MEDIA 5;
#define FIELD_TYPE_TEL 6;
#define FIELD_TYPE_MAPS 7;
#define FIELD_TYPE_BROWSER 8;
#define FIELD_TYPE_MAIL 9;
#define FIELD_TYPE_SMS 10;
#define FIELD_TYPE_VIDEO 11;
#define FIELD_TYPE_AUDIO 12;
#define FIELD_TYPE_CAM 13;

@property (nonatomic, unsafe_unretained) IBOutlet id<WebViewDelegate> delegate;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *titleLbl;
@property (nonatomic, strong) IBOutlet UILabel *descriptionLbl;
@property (nonatomic, strong) IBOutlet UILabel *contentsLbl;
@property (nonatomic, strong) IBOutlet UITableView *mediaTableView;
@property (nonatomic,strong) History *history;
@property (nonatomic,strong) ObjectDef *obj;

- (void) refreshUI:(ObjectDef*)_obj;
-(void)buildToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end

