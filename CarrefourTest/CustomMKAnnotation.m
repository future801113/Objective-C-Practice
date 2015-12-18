//
//  CustomMKAnnotation.m
//  CarrefourTest
//
//  Created by Mac on 2015/12/17.
//  Copyright © 2015年 Webcomm. All rights reserved.
//

#import "CustomMKAnnotation.h"

@implementation CustomMKAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

-(id) initWithCoordinate: (CLLocationCoordinate2D) the_coordinate
{
    if (self = [super init])
    {
        coordinate = the_coordinate;
    }
    return self;
}
-(MKAnnotationView *) annotationView{
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"MyCustomAnnotation"];
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    
    UIImage *image = [UIImage imageNamed:@"icon"];
    
    int size = 25;
    // Create a graphics image context
    UIGraphicsBeginImageContext(CGSizeMake(size, size));
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,size,size)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    annotationView.image = newImage;
    
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}

@end