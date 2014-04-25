//
//  s2lSnapMapViewController.h
//  snap2life suite
//
//  Created by Volker Brendel on 24.01.13.
//  Copyright (c) 2013 Prisma Gmbh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface s2lSnapMapViewController : UIViewController <MKMapViewDelegate>
{
    MKMapView *s2lmapview;
    NSMutableArray *items;
}

- (IBAction)getlocation;

- (IBAction)setMapFocus:(id)sender;

- (IBAction)setMapType:(id)sender;

- (IBAction)setSnapAnnotations:(id)sender;

- (IBAction)cancelButtonPressed:(id)sender;

- (IBAction)doneButtonPressed:(id)sender;

@property (strong, nonatomic) IBOutlet MKMapView *s2lmapview;

@property (strong, nonatomic) IBOutlet CLLocationManager *locationManager;

@end
