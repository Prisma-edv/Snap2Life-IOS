//
//  s2lSnapMapViewController.m
//  snap2life suite
//
//  Created by Volker Brendel on 24.01.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import "s2lSnapMapViewController.h"
#import "s2lAnnotation.h"
#import "s2lAppDelegate.h"
#import "s2lResultViewController.h"
#import "SerializerAPI2.h"
#import "S2LNewResultViewController.h"
#import "S2LErrorViewController.h"


#define WIMB_LATTITUDE 51.2345;
#define WIMB_LONGITUDE -0.213428;

#define LONDON_LATTITUDE 51.424046;
#define LONDON_LONGITUDE -0.295258;


#define S2LMAP_SPAN 0.01f;


@implementation s2lSnapMapViewController

@synthesize s2lmapview;

-(IBAction)dismiss:(id)sender{
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [self.locationManager startUpdatingLocation];
    [self setFocus:self.locationManager.location.coordinate];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.toolbarHidden = NO;
    self.navigationController.navigationBarHidden = NO;
    
    if (isIPad) {
        self.view.frame = CGRectMake(0, 0, 768, 960);
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{
    
    History *history = [items objectAtIndex:[view tag]];
    SerializerAPI2 *serializer = [[SerializerAPI2 alloc] init];
    UIViewController *vc;
    if ([history.snapRecognized boolValue]) {
        vc = [self.storyboard instantiateViewControllerWithIdentifier:@"result"];
        [(S2LNewResultViewController*)vc setHistory:history];
        [(S2LNewResultViewController*)vc setIndex:3];
        [(S2LNewResultViewController*)vc setObject:[serializer deserializeObjDef:history.snapServerResponse]];
    }else{
        vc = [self.storyboard instantiateViewControllerWithIdentifier:@"error"];
        [(S2LErrorViewController*)vc setHistory:history];
        [(S2LErrorViewController*)vc setResultIndex:3];
        [(S2LErrorViewController*)vc setErrorObject:[serializer deserializeError:history.snapServerResponse]];
    }
    
    AppDataObject *ado = [[S2LIRRequestMaker sharedClient] ado];
    ado.capturedData = history.snapImage;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)scale:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation: (id<MKAnnotation>) annotation
{       
    if (annotation == s2lmapview.userLocation) {
        return nil;
    }
    
    MKPinAnnotationView *pin = (MKPinAnnotationView *) [s2lmapview dequeueReusableAnnotationViewWithIdentifier: @"asdf"];
    
    if (pin == nil)
    {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier: @"asdf"];
    }
    else
    {
        
    }
    pin.annotation = annotation;
    
//    NSInteger annotationValue = [s2lmapview.annotations indexOfObject:annotation];
    
    pin.tag = [(s2lAnnotation*)annotation tag]; // set the tag property of the button to the index
    
    pin.pinColor = MKPinAnnotationColorRed;
    pin.animatesDrop = YES;
    pin.canShowCallout = YES;
    
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure]; // set the button

    History *thisHistory = [items objectAtIndex:[(s2lAnnotation*)annotation tag]]; // retrieve image for current cast
    
    UIImage *cachedImage = [UIImage imageWithData:thisHistory.snapImage];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[self scale:cachedImage toSize:CGSizeMake(30, 30)]];
    
    pin.leftCalloutAccessoryView = imgView; // apply the image
    
    return pin;
}


// VBR
#pragma mark - IBActions


- (IBAction)getlocation {
    s2lmapview.showsUserLocation = YES;
}

- (void)setFocus:(CLLocationCoordinate2D)coordinate
{
    
    switch (s2lmapview.mapType) {
        case 0:
            s2lmapview.mapType = MKMapTypeStandard;
            break;
        case 1:
            s2lmapview.mapType = MKMapTypeSatellite;
            break;
        case 2:
            s2lmapview.mapType = MKMapTypeHybrid;
            break;
        caseelse:
            s2lmapview.mapType = MKMapTypeStandard;
            break;
    }
    
    [self.s2lmapview setZoomEnabled:YES];
    [self.s2lmapview setScrollEnabled:YES];
    MKCoordinateRegion region = { {0.0, 0.0}, {0.0, 0.0}};
    region.center.latitude = coordinate.latitude;//self.locationManager.location.coordinate.latitude;
    region.center.longitude = coordinate.longitude;//self.locationManager.location.coordinate.longitude;
    region.span.longitudeDelta = 0.007f;
    region.span.latitudeDelta = 0.007f;
    [self.s2lmapview setRegion:region animated:YES];
    //[self.s2lmapview setDelegate:sender];
    
}

-(IBAction)setMapFocus:(id)sender
{
    [self setFocus:self.locationManager.location.coordinate];
}

- (IBAction)setSnapAnnotations:(id)sender
{
  
    [self.s2lmapview removeAnnotations:self.s2lmapview.annotations];
    
    switch (s2lmapview.mapType) {
        case 0:
            s2lmapview.mapType = MKMapTypeStandard;
            break;
        case 1:
            s2lmapview.mapType = MKMapTypeSatellite;
            break;
        case 2:
            s2lmapview.mapType = MKMapTypeHybrid;
            break;
        caseelse:
            s2lmapview.mapType = MKMapTypeStandard;
            break;
    }
    
    [self.s2lmapview setZoomEnabled:YES];
    [self.s2lmapview setScrollEnabled:YES];
    
    PersistenceManager *pm  = [PersistenceManager sharedInstance];
    items = [pm allHistories];
    
    for (int i=0;i<items.count;i++) {
        History *history = [items objectAtIndex:i];
        CLLocationCoordinate2D location;
        location.latitude = [history.snapLatitude doubleValue];
        location.longitude = [history.snapLongitude doubleValue];
        
        s2lAnnotation  *tempAnnotation = [[s2lAnnotation alloc] init];
        tempAnnotation.coordinate = location;
        tempAnnotation.title = @"Snap";
        tempAnnotation.subtitle = history.snapTitle;
        tempAnnotation.tag = i;
        
        [self.s2lmapview addAnnotation:tempAnnotation];
    }
    
    
    if(items.count > 0)[self setFocus:[[self.s2lmapview.annotations objectAtIndex:0] coordinate]];
    
}

- (IBAction)setMapType:(id)sender
{
    switch (((UISegmentedControl *) sender).selectedSegmentIndex) {
        case 0:
            s2lmapview.mapType = MKMapTypeStandard;
            break;
        case 1:
            s2lmapview.mapType = MKMapTypeSatellite;
            break;
        case 2:
            s2lmapview.mapType = MKMapTypeHybrid;
            break;
            
    }
}



- (void)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}



- (void)doneButtonPressed:(id)sender {
    // VBR
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
