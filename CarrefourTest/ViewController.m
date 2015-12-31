//
//  ViewController.m
//  CarrefourTest
//
//  Created by Mac on 2015/12/15.
//  Copyright © 2015年 Webcomm. All rights reserved.
//

#import "ViewController.h"

#define googleImgSize ((int) 175)

@interface ViewController ()

@end

@implementation ViewController

NSString *lastToken = @"";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.labelName.text = @"";
    self.labelEmail.text = @"";
    self.imagePic.image = nil;
    self.imagePic.hidden = YES;
    
    // Do any additional setup after loading the view, typically from a nib.
    
    // TODO(developer) Configure the sign-in button look/feel
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    
    // Uncomment to automatically sign in the user.
    [[GIDSignIn sharedInstance] signInSilently];
    
    //[[UIApplication sharedApplication] delegate]]
    //AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    //[delegate signInCallBack] = [self refreshProfile];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapSignOut:(id)sender {
    [[GIDSignIn sharedInstance] signOut];
    [self refreshProfile];
}

- (void)refreshProfile {
    GIDGoogleUser *user = [GIDSignIn sharedInstance].currentUser;
    if(user != nil){
        NSString *token = user.authentication.idToken;
        NSString *same = @"False";
        if(lastToken == token){
            same = @"Ture";
        }
        self.buttonSignIn.hidden = YES;
        self.buttonSignOut.hidden = NO;
        self.labelName.text = user.profile.name;
        self.labelEmail.text = user.profile.email;
        self.labelTokenSame.text = same;
        self.textViewToken.text = token;
        NSURL *imageURL = [user.profile imageURLWithDimension:googleImgSize];
        NSData * data = [[NSData alloc] initWithContentsOfURL:imageURL];
        UIImage *image = [[UIImage alloc] initWithData:data];
        self.imagePic.image = image;
        self.imagePic.hidden = NO;
        
        lastToken = token;
    } else {
        self.buttonSignIn.hidden = NO;
        self.buttonSignOut.hidden = YES;
        self.labelName.text = @"";
        self.labelEmail.text = @"";
        self.imagePic.image = nil;
        self.imagePic.hidden = YES;
    }
}


@end
