//
//  CustomMKAnnotation.h
//  CarrefourTest
//
//  Created by Mac on 2015/12/17.
//  Copyright © 2015年 Webcomm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CustomMKAnnotation : NSObject <MKAnnotation> {
    
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
}

- (id) initWithCoordinate:(CLLocationCoordinate2D)coord;
- (MKAnnotationView *) annotationView;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;


@end