//
//  HXAppUtility.h
//  NeiooPlayground
//
//  Created by Jefferson on 2015/7/27.
//  Copyright (c) 2015年 Herxun. All rights reserved.
//

@import UIKit;
#import <Foundation/Foundation.h>

@interface HXAppUtility : NSObject

+ (NSString *)removeWhitespace:(NSString *)originalString;      // Remove whitespace at the front and end of the string
+ (NSString *)removeExtraWhitespace:(NSString *)originalString; // Remove whitespace at the front and the end of the string + leave only one whitespace between words

+ (UIColor*)hexToColor:(int)hexValue alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHexString:(NSString *)coloString alpha:(CGFloat)alpha;

+ (BOOL)is4inchScreen;
+ (BOOL)isiOS7;
+ (BOOL)isiOS8;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (UIImage *)setImage:(UIImage *)image withAlpha:(CGFloat)alpha;
+ (UIImage *)imageWithColor:(UIColor *)color;

+ (void)presentNavModalViewController:(UIViewController*)vc parentViewController:(UIViewController*)pvc;
+ (NSDictionary *)parseJSON:(NSString *)jsonStr;

+ (void)updatedTipsRecord;
+ (BOOL)isTipsShown;
@end
