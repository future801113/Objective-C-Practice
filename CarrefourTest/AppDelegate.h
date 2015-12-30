//
//  AppDelegate.h
//  CarrefourTest
//
//  Created by Mac on 2015/12/15.
//  Copyright © 2015年 Webcomm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import "AnPush.h"
#import "Neioo.h"

#define GOOGLE_CLIENT_ID @"388055114325-qnu1q9nq8ucif9n5qi8r5v7qfqjp6i65.apps.googleusercontent.com"

#define NEIOO_API_KEY @"WHCAtOmSEbFzmdncdjI2PI659T4M2P4y"

@interface AppDelegate : UIResponder <UIApplicationDelegate, GIDSignInDelegate, AnPushDelegate, NeiooDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

