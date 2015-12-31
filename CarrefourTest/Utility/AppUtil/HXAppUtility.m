//
//  HXAppUtility.m
//  NeiooPlayground
//
//  Created by Jefferson on 2015/7/27.
//  Copyright (c) 2015年 Herxun. All rights reserved.
//

#import "HXAppUtility.h"

@implementation HXAppUtility

+ (NSString *)removeWhitespace:(NSString *)originalString
{
    return [originalString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+ (NSString *)removeExtraWhitespace:(NSString *)originalString
{
    //    Replace only space: [ ]+
    //    Replace space and tabs: [ \\t]+
    //    Replace space, tabs and newlines: \\s+
    
    NSString *squashed = [originalString stringByReplacingOccurrencesOfString:@"[ ]+"
                                                                   withString:@" "
                                                                      options:NSRegularExpressionSearch
                                                                        range:NSMakeRange(0, originalString.length)];
    
    return [squashed stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (UIColor *)hexToColor:(int)hexValue alpha:(CGFloat)alpha
{
    NSNumber* red = [NSNumber numberWithInt:(hexValue >> 16)];
    NSNumber* green = [NSNumber numberWithInt:((hexValue >> 8) & 0xFF)];
    NSNumber* blue = [NSNumber numberWithInt:(hexValue & 0xFF)];
    
    CGFloat fAlpha = (alpha)? alpha : 1.0f;
    UIColor* color = [UIColor colorWithRed:[red floatValue]/255.0f green:[green floatValue]/255.0f blue:[blue floatValue]/255.0f alpha:fAlpha];
    
    return color;
}

+ (UIColor *)colorWithHexString:(NSString *)hexValue alpha:(CGFloat)alpha
{
    UIColor *defaultResult = [UIColor whiteColor];
    if ([hexValue hasPrefix:@"#"] && [hexValue length] > 1) {
        hexValue = [hexValue substringFromIndex:1];
    }
    NSUInteger componentLength = 0;
    if ([hexValue length] == 3) {
        componentLength = 1;
    } else if ([hexValue length] == 6) {
        componentLength = 2;
    } else {
        return defaultResult;
    }
    
    BOOL isValid = YES;
    CGFloat components[3];
    
    for (NSUInteger i = 0; i < 3; i++) {
        NSString *component = [hexValue substringWithRange:NSMakeRange(componentLength * i, componentLength)];
        if (componentLength == 1) {
            component = [component stringByAppendingString:component];
        }
        NSScanner *scanner = [NSScanner scannerWithString:component];
        unsigned int value;
        isValid &= [scanner scanHexInt:&value];
        components[i] = (CGFloat)value / 255.0f;
    }
    if (!isValid)
        return defaultResult;
    
    return [UIColor colorWithRed:components[0]
                           green:components[1]
                            blue:components[2]
                           alpha:alpha];
}

+ (BOOL)is4inchScreen
{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    return screenBound.size.height > 560 ? YES : NO;
}

+ (BOOL)isiOS7
{
    return [[[UIDevice currentDevice] systemVersion] intValue] >= 7.0f ? YES : NO;
}

+ (BOOL)isiOS8
{
    return [[[UIDevice currentDevice] systemVersion] intValue] >= 8.0f ? YES : NO;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)setImage:(UIImage *)image withAlpha:(CGFloat)alpha
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (void)presentNavModalViewController:(UIViewController*)vc parentViewController:(UIViewController*)pvc
{
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [pvc presentViewController:nav animated:YES completion:nil];
}

+ (NSDictionary *)parseJSON:(NSString *)jsonStr
{
    NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return json;
}

+ (void)updatedTipsRecord
{
    [[NSUserDefaults standardUserDefaults]setObject:@"true" forKey:@"co.herxun.tips_record"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isTipsShown
{
    NSString *record = [[NSUserDefaults standardUserDefaults] objectForKey:@"co.herxun.tips_record"];
    
    return record ? YES : NO;
}

@end
