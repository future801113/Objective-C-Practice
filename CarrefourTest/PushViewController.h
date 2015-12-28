//
//  PushViewController.h
//  CarrefourTest
//
//  Created by Mac on 2015/12/27.
//  Copyright © 2015年 Webcomm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnSocial.h"

@interface PushViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) AnSocial *anSocial;
@property (weak, nonatomic) IBOutlet UITextField *inputName;
@property (weak, nonatomic) IBOutlet UITextField *inputPrice;
@property (weak, nonatomic) IBOutlet UITableView *tableViewMerchandise;

//declare a property to store your current responder
@property (nonatomic, assign) id currentResponder;  //點鍵盤外面可收起鍵盤

- (IBAction)buttonClick:(id)sender;

@end
