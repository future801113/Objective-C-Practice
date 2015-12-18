//
//  MapViewController.h
//  CarrefourTest
//
//  Created by Mac on 2015/12/16.
//  Copyright © 2015年 Webcomm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>

@interface MapViewController : UIViewController <MKMapViewDelegate,  CLLocationManagerDelegate>
    
- (IBAction)buttonClick:(id)sender;

@property(nonatomic, retain) IBOutlet MKMapView *mapView;
@property(nonatomic, retain) CLLocationManager *locationManager;
@end
