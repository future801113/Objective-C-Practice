

//
//  LightspeedCredentials.h
//  CarrefourTest
//
//  Created by Mac on 2015/12/28.
//  Copyright © 2015年 Webcomm. All rights reserved.
//

#ifndef LSPush_LightspeedCredentials_h
#define LSPush_LightspeedCredentials_h

static NSString* kArrownockAppKey = @"WHCAtOmSEbFzmdncdjI2PI659T4M2P4y";    // Fill in your app key here
#define LIGHTSPEED_API_BASEURL @"http://api.lightspeedmbs.com/v1" // If you are using arrownock.com, change this constant to @"http://api.arrownock.com/v1"
                                                                  // And make sure you are using libArrownock.a instead of libLightspeed.a
#define LIGHTSPEED_API_SEND_PUSH @"push_notification/send.json"
#endif
