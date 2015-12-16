//
//  ViewController.h
//  CarrefourTest
//
//  Created by Mac on 2015/12/15.
//  Copyright © 2015年 Webcomm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>

@interface ViewController : UIViewController <GIDSignInUIDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelEmail;
@property (weak, nonatomic) IBOutlet UIImageView *imagePic;
@property (weak, nonatomic) IBOutlet GIDSignInButton *buttonSignIn;
@property (weak, nonatomic) IBOutlet UIButton *buttonSignOut;

- (void) refreshProfile;

@end

