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

NSMutableArray *merchandiseArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    merchandiseArray = [[NSMutableArray alloc] init];
//    roleArray = [[NSArray alloc] initWithObjects:@"野蠻人", @"法師", @"弓箭手", @"盜賊", @"德魯伊", @"騎士", nil];
    
    //點鍵盤外面可收起鍵盤
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:singleTap];

    //Social API Client
    self.anSocial = [[AnSocial alloc] initWithAppKey:kArrownockAppKey];
    
    //取出server的merchandise資料並放到tableview
    [self setMerchandiseTable];
}

#pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [merchandiseArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //製作可重複利用的表格欄位Cell
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //設定欄位的內容與類型
    cell.textLabel.text = [merchandiseArray objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}


//Implement the below delegate method:
//點鍵盤外面可收起鍵盤
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentResponder = textField;
}

//Implement resignOnTap:
//點鍵盤外面可收起鍵盤
- (void)resignOnTap:(id)iSender {
    [self.currentResponder resignFirstResponder];
    [self.view endEditing:YES];
}

// use the keyArray as a datasource ...
NSArray *merchandises;
- (void)setMerchandiseTable{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    //[params setObject:@"Tom" forKey:@"name"];
    
    [self.anSocial sendRequest:@"objects/Merchandise/search.json" method:AnSocialMethodGET params:params success:^
     (NSDictionary *response) {
         [merchandiseArray removeAllObjects];
         
         merchandises = [[response valueForKey:@"response"] valueForKey:@"Merchandises"];
         
         for(NSDictionary *merchandise in merchandises){
             NSString *name = [merchandise valueForKey:@"name"];
             NSString *price = [merchandise valueForKey:@"price"];
             NSString *data = [NSString stringWithFormat: @"%@ - %@", name, price];
             [merchandiseArray addObject:data];
         }
         [self.tableViewMerchandise reloadData];
         
         for (id key in response){
             NSLog(@"key: %@ ,value: %@",key,[response objectForKey:key]);
         }
     } failure:^(NSDictionary *response) {
         for (id key in response)
         {
             NSLog(@"key: %@ ,value: %@",key,[response objectForKey:key]);
         }
     }];
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

- (IBAction)buttonNewCustomObject:(id)sender {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *name = self.inputName.text;
    NSString *price = self.inputPrice.text;
    
    [params setObject:name forKey:@"name"];
    [params setObject:price forKey:@"price"];
    
    [self.anSocial sendRequest:@"objects/Merchandise/create.json" method:AnSocialMethodPOST params:params success:^
     (NSDictionary *response) {
         for (id key in response)
         {
             NSLog(@"key: %@ ,value: %@",key,[response objectForKey:key]);
         }
         
         [self setMerchandiseTable];
     } failure:^(NSDictionary *response) {
         for (id key in response)
         {
             NSLog(@"key: %@ ,value: %@",key,[response objectForKey:key]);
         }
     }];
    
    
    self.inputName.text = @"";
    self.inputPrice.text = @"";
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
