//
//  AppDelegate.h
//  CarrefourTest
//
//  Created by Mac on 2015/12/15.
//  Copyright © 2015年 Webcomm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, GIDSignInDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

