//
//  AppDelegate.m
//  CarrefourTest
//
//  Created by Mac on 2015/12/15.
//  Copyright © 2015年 Webcomm. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "AnPush.h"
#import "LightspeedCredentials.h"
#import "Neioo.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
//    NSError* configureError;
//    
//    [[GGLContext sharedInstance] configureWithError: &configureError];
//    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
//   手動設定google client ID, 找不到上面的GGLContext
    [GIDSignIn sharedInstance].clientID = GOOGLE_CLIENT_ID;
    
    [GIDSignIn sharedInstance].delegate = self;
    
    
    //LightSpeed Init
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    NSDate *lastLaunch = [[NSUserDefaults standardUserDefaults] objectForKey:@"LSPushLastLaunch"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"LSPushLastLaunch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:-1];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDate *yesterday = [currentCalendar dateByAddingComponents:dateComponents toDate:[NSDate date]  options:0];
    
    
    [AnPush registerForPushNotification:(UIRemoteNotificationTypeAlert|
                                         UIRemoteNotificationTypeBadge|
                                         UIRemoteNotificationTypeSound)];
    if ([yesterday compare:lastLaunch] == NSOrderedDescending || lastLaunch == nil)
    {
        [AnPush registerForPushNotification:(UIRemoteNotificationTypeAlert|
                                             UIRemoteNotificationTypeBadge|
                                             UIRemoteNotificationTypeSound)];
    }
    else
    {
        NSData *tokenData = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
        if (tokenData)
            [AnPush setup:kArrownockAppKey deviceToken:tokenData delegate:self secure:YES];
    }
    
    //Neioo Init
    // 2. Initialize Neioo
    [Neioo setUpAppKey:NEIOO_API_KEY delegate:self withLocationAuthorization:NeiooLocationAuthorizationAlways];
    // 3. start Neioo
    [[Neioo shared] enable];
    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    NSDictionary *options = @{UIApplicationOpenURLOptionsSourceApplicationKey: sourceApplication,
                              UIApplicationOpenURLOptionsAnnotationKey: annotation};
    return [self application:application
                     openURL:url
                     options:options];
}

#pragma mark - GIDSignInDelegate method

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations on signed in user here.
//    NSString *userId = user.userID;                  // For client-side use only!
//    NSString *idToken = user.authentication.idToken; // Safe to send to the server
//    NSString *name = user.profile.name;
//    NSString *email = user.profile.email;
    // ...

    ViewController  *vc = (ViewController *)self.window.rootViewController;
    [vc refreshProfile];
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}

#pragma mark - Lightspeed push-notification registration result handler
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"deviceToken"];
    [AnPush setup:kArrownockAppKey deviceToken:deviceToken delegate:self secure:YES];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"error: %@", error);
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"didReceiveRemoteNotification!");
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    if (application.applicationState == UIApplicationStateActive)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Lightspeed"
                                                        message:(NSString*)[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - AnPushDelegate functions
- (void)didRegistered:(NSString *)anid withError:(NSString *)error
{
    NSLog(@"Arrownock didRegistered\nError: %@", error);
}

- (void)didUnregistered:(BOOL)success withError:(NSString *)error
{
    NSLog(@"Unregistration success: %@\nError: %@", success? @"YES" : @"NO", error);
}

#pragma mark - Application life-cycle management
//- (void)applicationWillResignActive:(UIApplication *)application
//{
//    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//}
//
//- (void)applicationDidEnterBackground:(UIApplication *)application
//{
//    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//}
//
//- (void)applicationWillEnterForeground:(UIApplication *)application
//{
//    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//}
//
//- (void)applicationDidBecomeActive:(UIApplication *)application
//{
//    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//}
//
//- (void)applicationWillTerminate:(UIApplication *)application
//{
//    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//}

-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - NeiooDelegate functions
- (void)neioo:(Neioo *)neioo didEnterSpace:(NeiooSpace *)space
{
    NSLog(@"Enter Space!!!");
}

- (void)neioo:(Neioo *)neioo didLeaveSpace:(NeiooSpace *)space
{
    NSLog(@"Leave Space!!!");
}

- (void)campaignTriggered:(NeiooCampaign *)campaign beacon:(NeiooBeacon *)beacon
{
    for (NeiooAction *action in campaign.actions){
        // ex.
        if ([action.type isEqualToString:@"show_image"]){
            // show image
            NSLog(@"Trigger action!!!!!, action type: %@",action.type);
        }
    }
}
@end
