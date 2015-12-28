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

- (IBAction)buttonSendNotification:(id)sender {
    NSString* strAlertMessage = [NSString stringWithFormat:@"\"%@\"", @"This is a Lightspeed Push Notification"];
    NSString* strSound = [NSString stringWithFormat:@"\"%@\"", @"default"];
    NSString* strData = [NSString stringWithFormat:@"payload={\"ios\":{\"alert\":%@,\"badge\":1,\"sound\":%@}}", strAlertMessage, strSound];
    NSURL* requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?key=%@", LIGHTSPEED_API_BASEURL, LIGHTSPEED_API_SEND_PUSH, kArrownockAppKey]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:requestURL];
    
    [request setHTTPMethod:@"POST"];
    NSData* postData = [strData dataUsingEncoding:NSUTF8StringEncoding];
    NSString* postDataLengthString = [NSString stringWithFormat:@"%d", [postData length]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:postDataLengthString forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error %@" ,error);
}

@end
