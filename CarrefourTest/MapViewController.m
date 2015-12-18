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

//全域變數是設這邊嗎...?
double selectLan;
double selectLon;
id<MKOverlay> preOverlay;

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
//    [self createAnnotation:CLLocationCoordinate2DMake(25.0467541, 121.5338736) andTitle:@"家樂福1" andAddress:@"台北市中山區渭水路一號一樓"];
//    [self createAnnotation:CLLocationCoordinate2DMake(25.0413598, 121.5329002)andTitle:@"家樂福2" andAddress:@"台北市大安區新生南路一段95號"];
//    [self createAnnotation:CLLocationCoordinate2DMake(25.0422646, 121.5318991)andTitle:@"家樂福3" andAddress:@"台北市中正區忠孝東路二段132號"];
    //傳入地址 自動轉成座標並畫在地圖上
    [self geoCoderAndCreateAnntation:@"家樂福1" andAddress:@"台北市中山區渭水路一號一樓"];
    [self geoCoderAndCreateAnntation:@"家樂福2" andAddress:@"台北市大安區新生南路一段95號"];
    [self geoCoderAndCreateAnntation:@"家樂福3" andAddress:@"台北市中正區忠孝東路二段132號"];
}

//更新位置
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
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
-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
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
- (void) getUserLocation {
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
- (void) createAnnotation:(CLLocationCoordinate2D)mylocation andTitle:(NSString *)title andAddress:(NSString*) inputAddress {
    // 建立一個region，待會要設定給MapView
    MKCoordinateRegion kaos_digital;
    
    // 設定經緯度
    kaos_digital.center = mylocation;
    
    // 設定縮放比例
    kaos_digital.span.latitudeDelta = 0.003;
    kaos_digital.span.longitudeDelta = 0.003;
    
    
    // 準備一個annotation
    CustomMKAnnotation *customMKAnnotation = [[CustomMKAnnotation alloc]initWithCoordinate:mylocation];
    
    
    customMKAnnotation.title = title;
    customMKAnnotation.address = inputAddress;
    
    
    
    [self.mapView setRegion:kaos_digital];
    
    // 把annotation加進MapView裡
    [self.mapView addAnnotation:customMKAnnotation];
}

//載入Custon AnntoatinView
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if([annotation isKindOfClass:[CustomMKAnnotation class]]){
        CustomMKAnnotation *myLocation = (CustomMKAnnotation *)annotation;
        
        
        MKAnnotationView *annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"MyCustomAnnotation"];
        
        if(annotationView == nil)
            annotationView = myLocation.annotationView;
        else
            annotationView.annotation = annotation;
        
        //加入導航按鈕
        UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

        [button addTarget:self action:@selector(buttonAccessoryRouteClicked) forControlEvents:UIControlEventTouchUpInside];
        annotationView.rightCalloutAccessoryView = button;

        
        return annotationView;
    } else {
        return nil;
    }
}

//點選AnnotationView時觸發
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view.annotation isKindOfClass:[CustomMKAnnotation class]]) {
        CustomMKAnnotation *selectAnnotation = view.annotation;
        selectLan = selectAnnotation.coordinate.latitude;
        selectLon = selectAnnotation.coordinate.longitude;
    }
}

// 地理编码
- (void)geoCoderAndCreateAnntation:(NSString *)title andAddress:(NSString*) inputAddress {
    CLGeocoder *geoC = [[CLGeocoder alloc] init];
    // 地理编码方案一：直接根据地址进行地理编码（返回结果可能有多个，因为一个地点有重名）
    [geoC geocodeAddressString:inputAddress completionHandler:^(NSArray<CLPlacemark *> * __nullable placemarks, NSError * __nullable error) {
        // 包含区，街道等信息的地标对象
        CLPlacemark *placemark = [placemarks firstObject];
        NSString *name = placemark.name;
        NSString *getAddress = [NSString stringWithFormat:@"%@", name];
        NSString *latitudeTF = [NSString stringWithFormat:@"%f", placemark.location.coordinate.latitude];
        NSString *longtitudeTF = [NSString stringWithFormat:@"%f", placemark.location.coordinate.longitude];
        NSLog(@"%@ %@  %@  %@", inputAddress, getAddress, latitudeTF, longtitudeTF);
        
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
        [self createAnnotation:location andTitle:title andAddress:inputAddress];
    }];
}


//導航
- (void)findDirectionsFrom:(MKMapItem *)source
                        to:(MKMapItem *)destination
{    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = source;
    request.transportType = MKDirectionsTransportTypeAutomobile;
    request.destination = destination;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         
         //stop loading animation here
         
         if (error) {
             NSLog(@"Error is %@",error);
         } else {
             //若有導航過先清除路線
             if(preOverlay != nil)
                 [self.mapView removeOverlay:preOverlay];
             
             //do something about the response, like draw it on map
             MKRoute *route = [response.routes firstObject];
             [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
         }
     }];
}
//導航路線圖設定
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    preOverlay = overlay;
    
    MKPolylineRenderer *polylineRender = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    polylineRender.lineWidth = 3.0f;
    polylineRender.strokeColor = [UIColor blueColor];
    return polylineRender;
}

- (IBAction)buttonLocate:(id)sender {
    [self getUserLocation];
}


- (IBAction)buttonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) buttonAccessoryRouteClicked {
    //目前座標
    CLLocationCoordinate2D _srcCoord = CLLocationCoordinate2DMake(self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude);
    MKPlacemark *_srcMark = [[MKPlacemark alloc] initWithCoordinate:_srcCoord addressDictionary:nil];
    MKMapItem *_srcItem = [[MKMapItem alloc] initWithPlacemark:_srcMark];
    
    //選到的店
    CLLocationCoordinate2D _destCoord = CLLocationCoordinate2DMake(selectLan, selectLon);
    MKPlacemark *_destMark = [[MKPlacemark alloc] initWithCoordinate:_destCoord addressDictionary:nil];
    MKMapItem *_destItem = [[MKMapItem alloc] initWithPlacemark:_destMark];
    
    //導航
    [self findDirectionsFrom:_srcItem to:_destItem];
}

@end
