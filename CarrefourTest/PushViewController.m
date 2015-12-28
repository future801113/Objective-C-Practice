//
//  PushViewController.m
//  CarrefourTest
//
//  Created by Mac on 2015/12/27.
//  Copyright © 2015年 Webcomm. All rights reserved.
//

#import "PushViewController.h"
#import "AnPush.h"
#import "LightspeedCredentials.h"


@implementation PushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.anSocial = [[AnSocial alloc] initWithAppKey:kArrownockAppKey];
}

- (IBAction)buttonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buttonRegisterChannel:(id)sender {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"testuser4" forKey:@"username"];
    [params setObject:@"123456" forKey:@"password"];
    [params setObject:@"123456" forKey:@"password_confirmation"];
    
    [self.anSocial sendRequest:@"users/create.json" method:AnSocialMethodPOST params:params success:^
     (NSDictionary *response) {
         for (id key in response)
         {
             NSLog(@"key: %@ ,value: %@",key,[response objectForKey:key]);
         }
     } failure:^(NSDictionary *response) {
         for (id key in response)
         {
             NSLog(@"key: %@ ,value: %@",key,[response objectForKey:key]);
         }
     }];
}

- (IBAction)buttonRegisterDevice:(id)sender {
    NSArray* arrayChannels = [NSArray arrayWithObjects:@"BroadcastMessage", @"LightspeedNews", nil ];
    
    [[AnPush shared] register:arrayChannels overwrite:YES];
}

@end
