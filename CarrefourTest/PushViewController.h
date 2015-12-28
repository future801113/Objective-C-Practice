//
//  PushViewController.h
//  CarrefourTest
//
//  Created by Mac on 2015/12/27.
//  Copyright © 2015年 Webcomm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnSocial.h"

@interface PushViewController : UIViewController
@property (strong, nonatomic) AnSocial *anSocial;

- (IBAction)buttonClick:(id)sender;

@end
