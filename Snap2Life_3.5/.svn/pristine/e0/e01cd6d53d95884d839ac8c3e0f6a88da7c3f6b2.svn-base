//
//  s2lResultView.m
//  snap2life suite
//
//  Created by Antonio Stilo on 11.02.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "s2lResultView.h"
#import "RequestUtils.h"
#import "ASVoteView.h"
#import "PersistenceManager.h"
#import <QuartzCore/QuartzCore.h>
#import "UIButton+UIButton_style.h"
#import "S2LIRRequestMaker.h"
#import "Feature.h"
#import "Featuregroup.h"

@implementation s2lResultView

@synthesize imageView,titleLbl,descriptionLbl,contentsLbl,mediaTableView,scrollView,delegate,history,obj;

-(void)buildToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    int width = 320;
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        width = 480;
    }
    if(isIPad)width = 768;
    ratingView.frame = CGRectMake((width-230)/2,ratingView.frame.origin.y, width, 55);
    
    int widthx = ((4+46)*2)+4;
    commentBtn.frame = CGRectMake(widthx,2,width-widthx-4,46);
}

-(void)comment
{
    history.snapFavourite = [NSNumber numberWithBool:![[history snapFavourite] boolValue]];
    PersistenceManager *pm = [PersistenceManager sharedInstance];
    [pm saveAll];
    
    if([history.snapFavourite boolValue]){
        [commentBtn setTitle:NSLocalizedString(@"bookmark_out", nil) forState:UIControlStateNormal];
    }else{
        [commentBtn setTitle:NSLocalizedString(@"bookmark_in", nil) forState:UIControlStateNormal];
    }
}

-(void)shear
{
    [delegate performSelector:@selector(shearOnFaceBook:) withObject:imageView.image];
}

-(void)shearTweet
{
    [delegate performSelector:@selector(shearOnTweeter:) withObject:imageView.image];
}

-(void)parse
{
    
     NSMutableArray *featureList = [[NSMutableArray alloc] init];
     for (Featuregroup* fg in obj.featuregroups.featuregroup){
         for (Feature* f in fg.feature){
             if ([[f name] length] > 0 || [[f value] length] > 0) {
                 [featureList addObject:f];
             }
         }
     
     NSArray *list = [featureList sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
     int order1 = [(Feature*) obj1 order];
     if ([[(Feature*) obj1 value] length] == 0) order1 += 10000;
     int order2 = [(Feature*) obj2 order];
     if ([[(Feature*) obj2 value] length] == 0) order2 += 10000;
     return (order1 < order2)? NSOrderedAscending: (order1 == order2)? NSOrderedSame: NSOrderedDescending;
     }];
     
     // Show results screen if more than one result or if one result and it has an empty URL.
     if ([list count] == 1){
        Feature *f = [list objectAtIndex:0];
         if (![f.value isEqualToString:@""]){
             [self performSelector:@selector(callExternalLink:) withObject:f.value afterDelay:1.0];
         }
     }
         features = list;
         [mediaTableView reloadData];
     }
}

-(void)callExternalLink:(NSString*)value{
    [delegate setCurrentHistory:history];
    [(UIViewController*)delegate performSelector:@selector(openWebUrlAndStore:andTargetName:) withObject:value withObject:[history.snapID stringValue]];
}

- (void) refreshUI:(ObjectDef*)_obj
{
    self.obj = _obj;
    
    [self parse];
    
    
    int height = 120;
    if(isIPad)height = 220;
    
    UIView *topBck = [[UIView alloc] initWithFrame:CGRectMake(4, -20, self.frame.size.width-8, height)];
    topBck.backgroundColor = [UIColor whiteColor];
    topBck.layer.cornerRadius = 22;
    topBck.layer.masksToBounds = YES;
    [self addSubview:topBck];
    [self sendSubviewToBack:topBck];
    

    
    AppDataObject *ado = [[S2LIRRequestMaker sharedClient] ado];
    
    //NSLog(ado.result.title);
    self.backgroundColor = UIColorFromRGB(BACKGROUND, 1);
	self.titleLbl.text = history.snapTitle;
    self.titleLbl.frame = CGRectMake(imageView.frame.origin.x+imageView.frame.size.width+20, imageView.frame.origin.y, self.titleLbl.frame.size.width, self.titleLbl.frame.size.height);
    self.titleLbl.textColor = UIColorFromRGB(SEC_COLOR_1, 1.0);
    [titleLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
	self.descriptionLbl.text = history.snapDesc;
    self.descriptionLbl.frame = CGRectMake(self.titleLbl.frame.origin.x, self.titleLbl.frame.origin.y+self.titleLbl.frame.size.height, self.descriptionLbl.frame.size.width, self.descriptionLbl.frame.size.height);
    self.descriptionLbl.textColor =  UIColorFromRGB(SEC_COLOR_3,1.0);
    [self.descriptionLbl setFont:[UIFont fontWithName:@"Helvetica" size:11]];
    
    //imageView.frame = CGRectMake(8, 8, 80,80);
    CALayer *imageLayer = self.imageView.layer;
    imageLayer.masksToBounds = YES;
    imageLayer.cornerRadius = 12;
    if(isIPad) imageLayer.cornerRadius = 32;
    
    NSData *capturedData = ado.capturedData;
	
	if (capturedData){
        UIImage* img = [[UIImage alloc] initWithData:capturedData];
		[self.imageView setImage:img];
        
        // TO DO STILO
		/*if (ado.rotated){
			CGAffineTransform rotate = CGAffineTransformMakeRotation( 90.0 / 180.0 * 3.14 );
			[self.imageView setTransform:rotate];
		}*/
	}
	
    mediaTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    mediaTableView.delegate = self;
    mediaTableView.dataSource = self;
    mediaTableView.backgroundColor = UIColorFromRGB(BACKGROUND, 1);
    mediaTableView.backgroundView = nil;
    [mediaTableView setSeparatorColor:UIColorFromRGB(MAIN_COLOR,0.0)];
    [mediaTableView reloadData];
    
    UIButton *shareFBBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareFBBtn addTarget:self action:@selector(shear) forControlEvents:UIControlEventTouchUpInside];
    [shareFBBtn setBackgroundImage:[UIImage imageNamed:@"btn_FB.png"] forState:UIControlStateNormal];
    shareFBBtn.frame = CGRectMake(4,0,46,48);
    UIButton *shareTWBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareTWBtn addTarget:self action:@selector(shearTweet) forControlEvents:UIControlEventTouchUpInside];
    [shareTWBtn setBackgroundImage:[UIImage imageNamed:@"btn_TW.png"] forState:UIControlStateNormal];
    shareTWBtn.frame = CGRectMake(52,0,46,48);
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width-320)/2, 0, 320, 55)];
    container.backgroundColor = [UIColor clearColor];
    
    commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if([history.snapFavourite boolValue]){
        [commentBtn setTitle:NSLocalizedString(@"bookmark_out", nil) forState:UIControlStateNormal];
    }else{
        [commentBtn setTitle:NSLocalizedString(@"bookmark_in", nil) forState:UIControlStateNormal];
    }
    [commentBtn addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
    //[commentBtn setBackgroundImage:[UIImage imageNamed:@"facebook_icon"] forState:UIControlStateNormal];
    int width = ((4+46)*2)+4;
    int mWidth = 320-width-4;
    if(isIPad)mWidth = 768-width-4;
    commentBtn.frame = CGRectMake(width,2,mWidth,46);
    [commentBtn setStyle];
    [container addSubview:shareFBBtn];
    [container addSubview:shareTWBtn];
    [container addSubview:commentBtn];
    
    mediaTableView.tableHeaderView = container;
    width = 320;
    CGFloat y = 280;
    height = 400;
    if(isIPad){
        width = 768;
        y = 380;
        height = 960;
    }
    
    //CGFloat y = imageView.frame.origin.y+imageView.frame.size.height+mediaTableView.contentSize.height;
    
    NSLog(@">> Y %f = %f | %f",y,mediaTableView.frame.origin.y,mediaTableView.contentSize.height);
    if(ratingView != nil){
        [ratingView removeFromSuperview];
        ratingView = nil;
    }
    ratingView = [[ASVoteView alloc] initWithFrame:CGRectMake((width-230)/2, y, 320, 55) withHistory:history];
    mediaTableView.tableFooterView = ratingView;
    
    if (isIPad) {
        mediaTableView.scrollEnabled = NO;
        mediaTableView.frame = CGRectMake(0, 200, width, mediaTableView.contentSize.height);
        self.frame = CGRectMake(0, 0, width, height);
        scrollView.frame = CGRectMake(0, 0, width, height);
        scrollView.contentSize = CGSizeMake(width, 1400);
    }

    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return features.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the region at the section index.
    //return NSLocalizedString(@"contents", @"Contents of the Image");
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
    }
    
    NSInteger rowIndex = indexPath.row;
    
    Feature *f = [features objectAtIndex:rowIndex];
    
    NSDate* timestamp = [RequestUtils dateFromIsoString:self.obj.infos.timestamp];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    // Disable the selectability of the text in the cell (only the buttons are of interest).
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    if (f.value != nil && f.value.length > 0) {
        // Set a button if the Feature has a non-null URL.
        [cell.textLabel setText:f.name];
        [cell.textLabel setBackgroundColor:UIColorFromRGB(MAIN_COLOR,0.0)];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"listrowbg.png"]];
        [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"listrowaccessory.png"]]];
    }
    else {
        // Set a two-line cell with the date in grey at the top and the comment below.
        [cell.textLabel setText:[dateFormatter stringFromDate:timestamp]];
        [cell.textLabel setBackgroundColor:[UIColor whiteColor]];
        [cell.textLabel setTextColor:UIColorFromRGB(SEC_COLOR_3,1.0)];
        [cell.detailTextLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        [cell.detailTextLabel setText:f.name];
        [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
        [cell.detailTextLabel setTextColor:UIColorFromRGB(SEC_COLOR_3,1.0)];
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"listrowcommentbg.png"]];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger rowIndex = indexPath.row;

    if (DEBUG_VERBOSE) NSLog(@"ResultSubview.didSelectRowAtIndexPath:%d", rowIndex);
    Feature *f = [features objectAtIndex:rowIndex];
    if ([[f value] length] > 0) {
        NSLog(@"*** URL TO OPEN %@",f.value);
        [delegate openWebUrlAndStore:f.value andTargetName:[history.snapID stringValue]];
    }
}


#pragma mark -
#pragma mark ViewController Methods

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    NSString *contentsLblTxt = NSLocalizedString(@"contents", @"Contents of the Image");
    [contentsLbl setText:contentsLblTxt];
	
}


- (void)viewDidUnload {
    
    self.imageView = nil;
    self.titleLbl = nil;
    self.descriptionLbl = nil;
    self.contentsLbl = nil;
    self.mediaTableView = nil;
    
}

@end
