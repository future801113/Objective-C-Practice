//
//  MapViewController.m
//  CarrefourTest
//
//  Created by Mac on 2015/12/16.
//  Copyright © 2015年 Webcomm. All rights reserved.
//

#import "MapViewController.h"
#import "CustomMKAnnotation.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    //設定精準度為導航等級
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;

    //要求權限
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
#endif
    
    //當調用了startUpdatingLocation方法後，就開始不斷地請求、刷新用戶的位置，一旦請求到用戶位置就會調用代理的didUpdateUserLocation
    [self.locationManager startUpdatingLocation];
    
    //監聽設備方向
    [self.locationManager startUpdatingHeading];
    
    self.mapView.showsUserLocation = YES;
    
    [self.mapView setMapType:MKMapTypeStandard];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [self getUserLocation];
    
    //大頭針
    [self createAnnotation:CLLocationCoordinate2DMake(25.0467541, 121.5338736)];
    [self createAnnotation:CLLocationCoordinate2DMake(25.0413598, 121.5329002)];
    [self createAnnotation:CLLocationCoordinate2DMake(25.0422646, 121.5318991)];
}

//更新位置
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}


/**
 *  简易指南针的实现
 *  手机朝向改变时调用
 *
 *  @param manager    位置管理者
 *  @param newHeading 朝向对象
 */
-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    /**
     *  CLHeading
     *  magneticHeading : 磁北角度
     *  trueHeading : 真北角度
     */
    
    NSLog(@"%f", newHeading.magneticHeading);
}

//取得經緯度
- (NSString *)deviceLocation {
    return [NSString stringWithFormat:@"latitude: %f longitude: %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
}

//取得定位
- (void) getUserLocation{
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    NSLog(@"LOG: %@", [self deviceLocation]);
    
    //View Area
    MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = self.locationManager.location.coordinate.latitude;
    region.center.longitude = self.locationManager.location.coordinate.longitude;
    region.span.longitudeDelta = 0.005f;
    region.span.longitudeDelta = 0.005f;
    [self.mapView setRegion:region animated:YES];
}

//建立大頭釘
- (void) createAnnotation:(CLLocationCoordinate2D)mylocation{
    // 建立一個CLLocationCoordinate2D
//    CLLocationCoordinate2D mylocation;
//    mylocation.latitude = 25.0467541;
//    mylocation.longitude = 121.5338736;
    
    // 建立一個region，待會要設定給MapView
    MKCoordinateRegion kaos_digital;
    
    // 設定經緯度
    kaos_digital.center = mylocation;
    
    // 設定縮放比例
    kaos_digital.span.latitudeDelta = 0.003;
    kaos_digital.span.longitudeDelta = 0.003;
    
    
    // 準備一個annotation
    CustomMKAnnotation *customMKAnnotation = [[CustomMKAnnotation alloc]initWithCoordinate:mylocation];
    
    
    customMKAnnotation.title = @"光華";
    customMKAnnotation.subtitle = @"i am here";
    
    
    [self.mapView setRegion:kaos_digital];
    
    // 把annotation加進MapView裡
    [self.mapView addAnnotation:customMKAnnotation];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    if([annotation isKindOfClass:[CustomMKAnnotation class]]){
        CustomMKAnnotation *myLocation = (CustomMKAnnotation *)annotation;
        
        
        MKAnnotationView *annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"MyCustomAnnotation"];
        
        if(annotationView == nil)
            annotationView = myLocation.annotationView;
        else
            annotationView.annotation = annotation;
        
        return annotationView;
    } else{
        return nil;
    }

}



- (IBAction)buttonLocate:(id)sender {
    [self getUserLocation];
}


- (IBAction)buttonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
