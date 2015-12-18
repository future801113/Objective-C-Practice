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

#define imageSize ((int) 25)

-(id) initWithCoordinate: (CLLocationCoordinate2D) the_coordinate {
    if (self = [super init])
    {
        coordinate = the_coordinate;
    }
    return self;
}

-(MKAnnotationView *) annotationView {
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"MyCustomAnnotation"];
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    
    UIImage *image = [UIImage imageNamed:@"icon"];
    // Create a graphics image context
    UIGraphicsBeginImageContext(CGSizeMake(imageSize, imageSize));
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0, 0, imageSize, imageSize)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    
    annotationView.image = newImage;
    
    //點擊右邊的I
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [button addTarget:self action:@selector(buttonAccessoryClicked) forControlEvents:UIControlEventTouchUpInside];
    annotationView.rightCalloutAccessoryView = button;
    
    return annotationView;
}

- (void) buttonAccessoryClicked {
    NSLog(@"button have been clicked.");
}



@end